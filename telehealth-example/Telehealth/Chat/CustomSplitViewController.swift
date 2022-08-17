//
//  CustomSplitViewController.swift
//
//  PubNub Real-time Cloud-Hosted Push API and Push Notification Client Frameworks
//  Copyright © 2021 PubNub Inc.
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

import UIKit
import PubNub
import PubNubChat
import PubNubChatComponents

class CustomSplitViewController: UIViewController {
  
  private let provider: TelehealthChatProvider!
  
  private weak var channelList: CollectionViewComponent?
  private weak var messageList: ComponentViewController?
    
  init(provider: TelehealthChatProvider) {
    
    self.provider = provider
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    navigationController?.setNavigationBarHidden(false, animated: false)
    navigationItem.title = "Telehealth"
    
    if let currentUser = try? provider.chatProvider.fetchCurrentUser(), let channel = currentUser.memberships.first?.channel {
      setUpChannelListViewController()
      setupMessageListViewController(for: channel.convert() as ChatChannel<VoidCustomData>)
    }
  }
    
  private func setUpChannelListViewController() {
    
    guard let currentUser = try? provider.chatProvider.fetchCurrentUser() else {
      preconditionFailure("Cannot fetch current user")
    }
    
    let channelListViewModel = provider.chatProvider.senderMembershipsChanneListComponentViewModel()
    channelListViewModel.leftBarButtonNavigationItems = nil
    channelListViewModel.layoutShouldContainSupplimentaryViews = false
    channelListViewModel.didSelectChannel = { [weak self] viewController, viewModel, selectedChannel in
      self?.setupMessageListViewController(for: selectedChannel)
    }
    channelListViewModel.customNavigationTitleView = { viewModel in
      UIView.customChannelListNavigationItemTitleView()
    }
        
    let channelListViewController = channelListViewModel.configuredComponentView()
    let navigationController = UINavigationController(rootViewController: channelListViewController)
    navigationController.view.translatesAutoresizingMaskIntoConstraints = false
    navigationController.setNavigationBarHidden(false, animated: false)
    
    addChild(navigationController)
    view.addSubview(navigationController.view)
    channelList = channelListViewController as? CollectionViewComponent
    
    let currentUserView = UIView.customUserView(
      with: currentUser.name,
      secondaryLabelText: (try? Constant.jsonDecoder.decode(TelehealthCustomData.User.self, from: currentUser.custom))?.title,
      avatarURL: currentUser.userAvatarURL,
      directionalLayoutMargins: NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 0)
    )
    
    currentUserView.translatesAutoresizingMaskIntoConstraints = false
    currentUserView.preservesSuperviewLayoutMargins = false
    
    view.addSubview(currentUserView)
    
    NSLayoutConstraint.activate([
      navigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
      navigationController.view.bottomAnchor.constraint(equalTo: currentUserView.topAnchor),
      navigationController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      
      currentUserView.heightAnchor.constraint(equalToConstant: 80),
      currentUserView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      currentUserView.widthAnchor.constraint(equalTo: navigationController.view.widthAnchor, multiplier: 1),
      currentUserView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    navigationController.didMove(toParent: self)
  }
  
  private func setupMessageListViewController<Custom: ChannelCustomData>(for channel: ChatChannel<Custom>) {
    
    guard let messageListViewModel = try? provider.chatProvider.messageListComponentViewModel(pubnubChannelId: channel.id) else {
      preconditionFailure("Cannot create message list for the channel ID: \(channel.id)")
    }
    
    messageListViewModel.customNavigationTitleString = nil
    messageListViewModel.rightBarButtonNavigationItems = nil
    messageListViewModel.customNavigationTitleView = { [weak self] viewModel in
      self?.customMessageListNavigationTitleView(for: channel) ?? UIView()
    }
    
    messageList?.removeFromParent()
    messageList?.view.removeFromSuperview()
    messageList?.didMove(toParent: nil)
    
    let messageListViewController = messageListViewModel.configuredComponentView()
    let navigationController = UINavigationController(rootViewController: messageListViewController)
    navigationController.view.translatesAutoresizingMaskIntoConstraints = false
    navigationController.setNavigationBarHidden(false, animated: false)
    
    addChild(navigationController)
    view.addSubview(navigationController.view)
    messageList = messageListViewController
        
    NSLayoutConstraint.activate([
      navigationController.view.leadingAnchor.constraint(equalTo: channelList?.navigationController?.view.trailingAnchor ?? view.leadingAnchor),
      navigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
      navigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      navigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func customMessageListNavigationTitleView<Custom: ChannelCustomData>(for channel: ChatChannel<Custom>) -> UIView {
    
    let label = UILabel()
    label.text = channel.name
    label.font = UIFont(name: "Poppins-Bold", size: 16)
    label.sizeToFit()
    
    return label
  }
}
