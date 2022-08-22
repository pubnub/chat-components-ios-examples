//
//  ChatFlowCoordinator.swift
//
//  PubNub Real-time Cloud-Hosted Push API and Push Notification Client Frameworks
//  Copyright © 2022 PubNub Inc.
//  https://www.pubnub.com/
//  https://www.pubnub.com/terms
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit
import PubNub
import PubNubChat
import PubNubChatComponents

enum PatientError: Error {
  case membershipFetch(String)
}

protocol ChatFlowCoordinator {
  func start() throws
}

final class DefaultChatFlowCoordinator: ChatFlowCoordinator {
  private let navigationController: UINavigationController
  private let provider: TelehealthChatProvider
  
  init(navigationController: UINavigationController, provider: TelehealthChatProvider) {
    self.navigationController = navigationController
    self.provider = provider
  }
  
  func start() throws {
    navigationController.setNavigationBarHidden(false, animated: false)
    if provider.hasDoctorRole {
      try startWithDoctor()
    } else {
      try startWithPatient()
    }
  }
}

//MARK: - Private
private extension DefaultChatFlowCoordinator {
  private func startWithDoctor() throws {
    setUpChannelListViewController()
  }
  
  private func startWithPatient() throws {
    let viewModel = try makeMessageViewModel()
    navigationController.pushViewController(
      viewModel.configuredComponentView(),
      animated: true
    )
  }
  
  private func makeMessageViewModel() throws -> MessageListComponentViewModel<TelehealthCustomData, PubNubManagedChatEntities> {
    let currentUser = try provider.chatProvider.fetchCurrentUser()
    guard let membership = currentUser.memberships.first(where: { $0.managedUser.id == provider.uuid }) else {
      throw PatientError.membershipFetch("Cannot fetch membership for the current user")
    }
    
    let messageListViewModel = try provider.chatProvider.messageListComponentViewModel(pubnubChannelId: membership.channelId)
    messageListViewModel.customNavigationTitleString = nil
    messageListViewModel.leftBarButtonNavigationItems = nil
    messageListViewModel.rightBarButtonNavigationItems = nil
    messageListViewModel.customNavigationTitleView = { viewModel in
      UIView.customUserView(
        with: membership.channel.name,
        secondaryLabelText: membership.channel.details,
        avatarURL: membership.channel.avatarURL,
        backgroundColor: .clear,
        primaryLabelTextColor: .white,
        secondaryLabelTextColor: .white
      )
    }
    
    return messageListViewModel
  }
  
  private func setUpChannelListViewController() {
    let viewModel = makeChannelViewModel()
    let channelListViewController = viewModel.configuredComponentView()
    channelListViewController.title = "Telehealth"
    navigationController.pushViewController(channelListViewController, animated: true)
  }
  
  private func makeChannelViewModel() -> ChannelListComponentViewModel<TelehealthCustomData, PubNubManagedChatEntities> {
    let channelListViewModel = provider.chatProvider.senderMembershipsChanneListComponentViewModel()
    channelListViewModel.leftBarButtonNavigationItems = nil
    channelListViewModel.layoutShouldContainSupplimentaryViews = false
    channelListViewModel.didSelectChannel = { [weak self] viewController, viewModel, selectedChannel in
      self?.setupMessageListViewController(for: selectedChannel)
    }
    channelListViewModel.customNavigationTitleView = { viewModel in
      UIView.customChannelListNavigationItemTitleView()
    }
    return channelListViewModel
  }
  
  private func setupMessageListViewController<Custom: ChannelCustomData>(for channel: ChatChannel<Custom>) {
    guard let messageListViewModel = try? provider.chatProvider.messageListComponentViewModel(pubnubChannelId: channel.id) else {
      preconditionFailure("Cannot create message list for the channel ID: \(channel.id)")
    }
    
    messageListViewModel.customNavigationTitleString = nil
    messageListViewModel.rightBarButtonNavigationItems = nil
    messageListViewModel.customNavigationTitleView = { [weak self] viewModel in
      guard let name = channel.name, let self = self else { return UIView() }
      return self.customMessageListNavigationTitleView(for: name)
    }
    
    let messageListViewController = messageListViewModel.configuredComponentView()
    navigationController.pushViewController(messageListViewController, animated: true)
  }
  
  private func customMessageListNavigationTitleView(for name: String) -> UIView {
    let label = UILabel()
    label.text = name
    label.font = UIFont(name: "Poppins-Bold", size: 16)
    return label
  }
}
