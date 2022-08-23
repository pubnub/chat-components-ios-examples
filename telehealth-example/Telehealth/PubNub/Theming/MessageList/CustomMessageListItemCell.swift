//
//  CustomMessageListItemCell.swift
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

import UIKit
import PubNubChatComponents

class CustomMessageListItemCell: MessageListItemCell {
  
  open override func configure<Message: ManagedMessageViewModel>(
    _ message: Message,
    theme: MessageListCellComponentTheme
  ) {
    
    super.configure(message, theme: theme)
    
    let constraintsToRemove = authorAvatarView.constraints.filter() {
      $0.firstAttribute == .width || $0.firstAttribute == .height
    }
    
    contentContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 0)
    cellContainer.alignment = .top
    
    authorAvatarView.removeConstraints(constraintsToRemove)
    authorAvatarView.imageView.contentMode = .scaleAspectFill
    authorAvatarView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    authorAvatarView.heightAnchor.constraint(equalToConstant: 30).isActive = true
  }
}
