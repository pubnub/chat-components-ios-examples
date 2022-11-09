//
//  SceneDelegate.swift
//  getting-started
//
//  Created by Craig Lane on 1/13/22.
//

import UIKit

import PubNub
import PubNubChat
import PubNubChatComponents

let PUBNUB_PUBLISH_KEY = "myPublishKey"
let PUBNUB_SUBSCRIBE_KEY = "myPublishKey"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // Creates PubNub configuration
  lazy var pubnubConfiguration = {
    return PubNubConfiguration(
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY,
      userId: "myFirstUser"
    )
  }()
  
  var window: UIWindow?
  var chatProvider: PubNubChatProvider?
  var defaultChannelId = "Default"

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    // Enables PubNub logging to the Console
    PubNub.log.levels = [.all]
    PubNub.log.writers = [ConsoleLogWriter()]
    
    if chatProvider == nil {
      // Creates a new ChatProvider
      let provider = PubNubChatProvider(
        pubnubProvider: PubNub(configuration: pubnubConfiguration)
      )
      
      // Preloads dummy data
      preloadData(provider) { [weak self] in
        self?.chatProvider = provider
        self?.setupRootView(windowScene: windowScene)
      }
    } else {
      setupRootView(windowScene: windowScene)
    }
  }
  
  func setupRootView(windowScene: UIWindowScene) {
    // Creates the default ChannelList and MemberList component view models
    guard let channelListViewModel = chatProvider?.senderMembershipsChanneListComponentViewModel(),
          let messageListViewModel = try? chatProvider?.messageListComponentViewModel(pubnubChannelId: defaultChannelId) else {
      preconditionFailure("Could not create intial view models")
    }
    
    // Creates the navigation structure
    let navigation = UINavigationController()
  
    // Loads the MessageList as the root view, but allows for the ChannelList to be the previous view
    navigation.viewControllers = [
      channelListViewModel.configuredComponentView(),
      messageListViewModel.configuredComponentView()
    ]

    // Sets the component as the root view controller
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigation
    self.window = window
    window.makeKeyAndVisible()
  }
  
  func preloadData(_ chatProvider: PubNubChatProvider, completion: @escaping () -> Void) {
    // Creates a user object with uuid
    let user = PubNubChatUser(
      id: chatProvider.pubnubConfig.userId,
      name: "myFirstUser",
      avatarURL: URL(string: "https://picsum.photos/seed/\(chatProvider.pubnubConfig.userId)/200")
    )
    
    // Creates a channel object
    let channel = PubNubChatChannel(
      id: defaultChannelId,
      name: "Default",
      type: "direct",
      avatarURL: URL(string: "https://picsum.photos/seed/\(defaultChannelId)/200")
    )
    
    // Creates a membership between the user and the channel for subscription purposes
    let membership = PubNubChatMember(channel: channel, user: user)
    
    // Subscribes to the default channel
    chatProvider.pubnubProvider.subscribe(.init(channels: [defaultChannelId], withPresence: true))
    
    // Fills the database with the user, channel, and memberships data
    chatProvider.dataProvider.load(members: [membership], completion: completion)
  }
}

