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

let PUBNUB_PUBLISH_KEY = "demo" // "pub-c-key"
let PUBNUB_SUBSCRIBE_KEY = "demo" // "sub-c-key"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // Create PubNub Configuration
  lazy var pubnubConfiguration = {
    return PubNubConfiguration(
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY,
      uuid: "uuid-of-current-user"
    )
  }()
  
  var window: UIWindow?

  var chatProvider: PubNubChatProvider?
  var defaultChannelId = "my-current-channel"

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    // Enable PubNub logging to the Console
    PubNub.log.levels = [.all]
    PubNub.log.writers = [ConsoleLogWriter()]
    
    if chatProvider == nil {
      // Create a new ChatProvider
      let provider = PubNubChatProvider(
        pubnubConfiguration: pubnubConfiguration
      )
      
      // Preload Dummy Data
      preloadData(provider)
      
      // Assign to SceneDelegate for future use
      chatProvider = provider
    }
    
    // Create the default Channel List and Member List Component View Models
    guard let channelListViewModel = chatProvider?.senderMembershipsChanneListComponentViewModel(),
          let messageListViewModel = try? chatProvider?.messageListComponentViewModel(pubnubChannelId: defaultChannelId) else {
      preconditionFailure("Could not create intial view models")
    }
    
    // Create navigation structure
    let navigation = UINavigationController()
  
    // Load the MessageList as the root view, but allow for the ChannelList to be the `Back` view
    navigation.viewControllers = [
      channelListViewModel.configuredComponentView(),
      messageListViewModel.configuredComponentView()
    ]

    // Set the component as the root view controller
    window.rootViewController = navigation
    self.window = window
    window.makeKeyAndVisible()
  }
  
  func preloadData(_ chatProvider: PubNubChatProvider) {
    // Create a user object with UUID
    let user = PubNubChatUser(
      id: chatProvider.pubnubConfig.uuid,
      name: "You",
      avatarURL: URL(string: "https://picsum.photos/seed/\(chatProvider.pubnubConfig.uuid)/200")
    )
    
    // Create a channel object
    let channel = PubNubChatChannel(
      id: defaultChannelId,
      name: "Default",
      type: "direct",
      avatarURL: URL(string: "https://picsum.photos/seed/\(defaultChannelId)/200")
    )
    
    // Create a membership between the User and the Channel for subscription purposes
    let membership = PubNubChatMember(channel: channel, member: user)
    
    // Subscribe to the default channel
    chatProvider.pubnubProvider.subscribe(.init(channels: [defaultChannelId], withPresence: true))
    
    // Fill database with the user, channel, and memberships data
    chatProvider.dataProvider.load(members: [membership])
  }
}

