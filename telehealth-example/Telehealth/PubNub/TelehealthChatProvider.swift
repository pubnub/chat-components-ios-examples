//
//  TelehealthChatProvider.swift
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

import Foundation
import PubNub
import PubNubChat
import PubNubChatComponents

class TelehealthChatProvider {
    
  let PUBNUB_PUB_KEY = "pub-c-8aa2a3e0-4047-4e8c-b966-a8f9d27e3269"
  let PUBNUB_SUB_KEY = "sub-c-5dfc52c0-b3e1-11ec-9e6b-d29fac035801"
  
  private(set) var uuid: String = String()
  private(set) var hasDoctorRole: Bool = false

  init?(with login: String, completion: @escaping (() -> Void)) {
    
    // Gets the list of users from the JSON file and maps them into corresponding model class from Chat Components
    let users = (parsePayload(from: "users") as [PubNubUUIDMetadataBase]).map() {
      ChatUser<TelehealthCustomData.User>(
        id: $0.metadataId,
        name: $0.name,
        type: $0.type,
        status: $0.status,
        externalId: $0.externalId,
        avatarURL: URL(string: $0.profileURL ?? String()) ?? URL(string: "https://picsum.photos/100/200"),
        email: $0.email,
        updated: $0.updated,
        eTag: $0.eTag,
        custom: TelehealthUserCustomData(flatJSON: $0.custom)
      )
    }
    
    if let user = users.first(where: { $0.externalId == login }) {
      uuid = user.id
      hasDoctorRole = user.type == "doctor"
    } else {
      return nil
    }
    
    // Gets the list of channels from the JSON file and maps them into corresponding model class from Chat Components
    let channels = (parsePayload(from: "channels") as [PubNubChannelMetadataBase]).map() {
      ChatChannel<VoidCustomData>(
        id: $0.metadataId,
        name: $0.name,
        type: $0.type,
        status: $0.status,
        details: $0.channelDescription,
        avatarURL: URL(string: "https://picsum.photos/200/300")!,
        updated: $0.updated,
        eTag: $0.eTag,
        custom: VoidCustomData()
      )
    }
    
    // Gets all memberships and creates assosiacion between the channel ID and its users
    let memberships = parseListOfDictionaries(from: "memberships").map() { dict -> [ChatMember<TelehealthCustomData>] in
      
      let channel = dict["channel"] as? String ?? String()
      let members = dict["members"] as? [String] ?? []
      
      return members.map() {
        ChatMember<TelehealthCustomData>(
          channelId: channel,
          userId: $0
        )
      }
    }.flatMap() { $0 }
    
    insertObjects(
      channels: channels,
      users: users,
      memberships: memberships,
      completion: completion
    )
  }
  
  lazy var configuration: PubNubConfiguration = {
    PubNubConfiguration(
      publishKey: PUBNUB_PUB_KEY,
      subscribeKey: PUBNUB_SUB_KEY,
      userId: uuid
    )
  }()
  
  lazy var chatProvider: ChatProvider<TelehealthCustomData, PubNubManagedChatEntities> = {
    let provider = ChatProvider<TelehealthCustomData, PubNubManagedChatEntities>(
      pubnubProvider: PubNub(
        configuration: configuration
      )
    )
    
    provider.themeProvider.template.channelListComponent = channelListComponentTheme
    provider.themeProvider.template.messageListComponent = messageListComponentTheme
    provider.themeProvider.template.messageInputComponent = messageInputComponentTheme

    return provider
    
  }()
    
  private func insertObjects(
    channels: [ChatChannel<VoidCustomData>],
    users: [ChatUser<TelehealthCustomData.User>],
    memberships: [ChatMember<TelehealthCustomData>],
    completion: (() -> Void )? = nil
  ) {
    
    chatProvider.pubnubProvider.subscribe(
      SubscribeRequest(
        channels: (channels.filter() { $0.id.contains(uuid) }).map() { $0.id },
        withPresence: true
      )
    )
    
    chatProvider.dataProvider.load(members: memberships, forceWrite: true, completion: { [weak self] in
      self?.chatProvider.dataProvider.load(users: users, completion: {
        self?.chatProvider.dataProvider.load(channels: channels, completion: completion)
      })
    })
  }
  
  private func parsePayload<T: Codable>(from fileName: String) -> T {
    
    let path = Bundle.main.path(forResource: fileName, ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    let decoder = JSONDecoder()
    let formatter = ISO8601DateFormatter()
    
    formatter.formatOptions = [.withFullDate]
    decoder.dateDecodingStrategy = .custom({ decoder in
      
      let container = try decoder.singleValueContainer()
      let dateString = try container.decode(String.self)
      
      if let date = formatter.date(from: dateString) {
        return date
      } else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
      }
    })
    
    return try! decoder.decode(T.self, from: data)
  }
  
  private func parseListOfDictionaries(from fileName: String) -> [[String: Any]] {
    
    let path = Bundle.main.path(forResource: fileName, ofType: "json")!
    let content = try! Data(contentsOf: URL(fileURLWithPath: path))
    
    return try! JSONSerialization.jsonObject(with: content) as! [[String: Any]]
  }
}
