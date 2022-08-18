//
//  ChatFlowCoordinator.swift
//  telehealth-example
//
//  Created by Maciej Adamczyk on 18/08/2022.
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
            
        }
        channelListViewModel.customNavigationTitleView = { viewModel in
            UIView.customChannelListNavigationItemTitleView()
        }
        return channelListViewModel
    }
}
