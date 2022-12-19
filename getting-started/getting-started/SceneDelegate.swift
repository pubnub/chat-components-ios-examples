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

let PUBNUB_PUBLISH_KEY = ""
let PUBNUB_SUBSCRIBE_KEY = ""

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // Creates PubNub configuration
  lazy var pubnubConfiguration = {
    return PubNubConfiguration(
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY,
      userId: "user_0"
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
      let provider = PubNubChatProvider(pubnubProvider: PubNub(configuration: pubnubConfiguration))
      
      // Sets custom themes for ChannelList, MesasgeList, MessageInput and MemberList components
      provider.themeProvider.template.channelListComponent = channelListComponentTheme
      provider.themeProvider.template.messageListComponent = messageListComponentTheme
      provider.themeProvider.template.messageInputComponent = messageInputComponentTheme
      provider.themeProvider.template.memberListComponent = memberListComponentTheme
      
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
    
    // Creates the default ChannelList and MessageList component view models
    guard
      let channelListViewModel = chatProvider?.senderMembershipsChanneListComponentViewModel(),
      let messageListViewModel = try? chatProvider?.messageListComponentViewModel(pubnubChannelId: defaultChannelId)
    else {
      preconditionFailure("Could not create intial view models")
    }
    
    // Creates the navigation structure
    let navigation = UINavigationController()
    navigation.navigationBar.tintColor = UIColor(named: "ChannelList.NavigationBar.TintColor")!
    
    // Disables supplementary views for ChannelList and sets custom right bar button items
    channelListViewModel.layoutShouldContainSupplimentaryViews = false
    channelListViewModel.rightBarButtonNavigationItems = { viewController, viewModel in
      [
        UIBarButtonItem(
          image: UIImage(systemName: "plus.circle"),
          style: .plain,
          target: self,
          action: #selector(Self.addingNewChannel)
        )
      ]
    }
    
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
  
  /**
   * This method demonstrates what objects describe channels, users, and memberships and how to insert them into the local database.
   * This is a simplified version that relies on local objects created on-the-fly
   */
  func preloadData(_ chatProvider: PubNubChatProvider, completion: @escaping () -> Void) {
    
    // Creates a channel object
    let channel = PubNubChatChannel(
      id: defaultChannelId,
      name: "Default",
      type: "direct",
      avatarURL: URL(string: "https://picsum.photos/seed/\(defaultChannelId)/200")
    )
    // Creates user objects
    let users = (0...50).map {
      PubNubChatUser(
        id: "user_\($0)",
        name: "user_\($0)",
        avatarURL: URL(string: "https://picsum.photos/seed/\($0)/200")
      )
    }
    // Creates memberships between users and the channel for subscription purposes
    let members = users.map() {
      PubNubChatMember(
        channel: channel,
        user: $0
      )
    }
    
    // Subscribes to the default channel
    chatProvider.pubnubProvider.subscribe(.init(channels: [defaultChannelId], withPresence: true))
    
    // Fills the database with the user, channel, and memberships data
    chatProvider.dataProvider.load(members: members, completion: completion)
  }
  
  /**
   * This method demonstrates how to sync remote objects from PubNub like users, channels and memberships through ChatProvider
   */
  func anotherPreloadData(_ chatProvider: PubNubChatProvider, completion: @escaping () -> Void) {
    chatProvider.dataProvider.syncRemoteUserMembers(
      UserMemberFetchRequest(channelId: "<<INSERT_YOUR_REMOTE_CHANNEL_ID>>"),
      completion: { [weak chatProvider] _ in
        chatProvider?.dataProvider.syncRemoteChannelsPaginated(
          ChannelsFetchRequest(includeCustom: true),
          completion:  { _ in
            chatProvider?.dataProvider.syncRemoteUsersPaginated(
              UsersFetchRequest(includeCustom: true),
              completion:  { _ in
                completion()
              })
          })
      })
  }
  
  /**
   * This method demonstrates how to access the PubNub SDK instance from ChatProvider in order to send a file to the given channel
   */
  func accessingTheSDK() {
    let pubnub = chatProvider?.pubnubProvider.pubnub
    // Specify the file you'd like to send
    let image = UIImage()
    
    pubnub?.send(
      .data(image.jpegData(compressionQuality: 1.0) ?? Data(), contentType: "image/jpeg"),
      channel: defaultChannelId,
      remoteFilename: "FileName"
    ) { result in
      debugPrint(result)
    }
  }
  
  /**
   * This method opens the form and demonstrates how to add a new channel and associate the current user with the given channel
   */
  @objc func addingNewChannel() {
    guard let chatProvider = chatProvider else {
      return
    }
    self.window?.rootViewController?.present(
      AddNewChannelViewController(chatProvider: chatProvider),
      animated: true
    )
  }
}
