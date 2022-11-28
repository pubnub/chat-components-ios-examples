//
//  SceneDelegate.swift
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

let PUBNUB_PUBLISH_KEY = "demo"
let PUBNUB_SUBSCRIBE_KEY = "demo"

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // Creates PubNub configuration
  lazy var pubnubConfiguration = {
    return PubNubConfiguration(
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY,
      userId: "user_0",
      useSecureConnections: false,
      origin: "127.0.0.1:8090"
    )
  }()
  
  var window: UIWindow?
  
  var chatProvider: PubNubChatProvider?
  var defaultChannelId = "demo"
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else {
      return
    }
    
    let window = UIWindow(windowScene: windowScene)
    
    // Enables PubNub logging to the Console
    // PubNub.log.levels = [.all]
    // PubNub.log.writers = [ConsoleLogWriter()]
    
    if chatProvider == nil {
      
      // Creates a new ChatProvider
      let provider = PubNubChatProvider(
        pubnubProvider: PubNub(configuration: pubnubConfiguration),
        datastoreConfiguration: DatastoreConfiguration(
          bundle: .pubnubChat,
          dataModelFilename: "PubNubChatModel",
          storageDirectlyURL: nil,
          storageUniqueFilename: "default",
          cleanStorageOnLoad: true
        )
      )
      
      // Sets custom themes for MessageList and MessageInput components
      provider.themeProvider.template.messageListComponent = messageListComponentTheme
      provider.themeProvider.template.messageInputComponent = messageInputComponentTheme
      
      // Preloads dummy data
      preloadData(provider) { [weak self] in
        window.rootViewController = RootViewController(channelId: self?.defaultChannelId ?? "", provider: provider, scene: windowScene)
        self?.window = window
        window.makeKeyAndVisible()
      }
    }
  }
  
  func preloadData(_ chatProvider: PubNubChatProvider, completion: @escaping (() -> Void)) {
    let channel = PubNubChatChannel(
      id: defaultChannelId,
      name: "Default",
      type: "direct",
      avatarURL: URL(string: "https://picsum.photos/seed/\(defaultChannelId)/200")
    )
    
    let user = PubNubChatUser(
      id: pubnubConfiguration.userId,
      name: "user_0",
      avatarURL: URL(string: "https://picsum.photos/seed/\(pubnubConfiguration.userId)/200")
    )
    
    let membership = PubNubChatMember(
      channel: channel,
      user: user
    )
    
    // Subscribes to the default channel
    chatProvider.pubnubProvider.subscribe(.init(channels: [defaultChannelId], withPresence: false))
    
    // Fills the database with the user, channel, and memberships data
    chatProvider.dataProvider.load(members: [membership], completion: completion)
  }
}
