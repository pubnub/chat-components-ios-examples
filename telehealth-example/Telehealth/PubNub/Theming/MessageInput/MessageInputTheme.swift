//
//  MessageInputTheme.swift
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
import PubNubChat
import PubNubChatComponents

final class CustomMessageInputBarComponent: MessageInputBarComponent {
  override func setupComponent() {
    super.setupComponent()
    inputTextView?.layer.cornerRadius = 8
  }
}

let messageInputComponentTheme = MessageInputComponentTheme(
  viewType: CustomMessageInputBarComponent.self,
  backgroundColor: UIColor(named: "MessageInput.BackgroundColor")!,
  placeholderText: "Write a message",
  placeholderTextColor: UIColor(named: "MessageInput.TextView.PlaceholderTextColor")!,
  placeholderTextFont: UIFont(name: "Poppins-Regular", size: 15)!,
  textInputTheme: InputTextViewComponentTheme(
    customType: UITextView.self,
    backgroundColor: UIColor(named: "MessageInput.TextView.BackgroundColor")!,
    textColor: UIColor(named: "MessageInput.TextView.TextColor")!,
    textFont: UIFont(name: "Poppins-Regular", size: 15)!,
    dataDetectorTypes: .all,
    linkTextAttributes: [:],
    isEditable: true,
    isExclusiveTouch: false,
    scrollView: .enabled,
    textContainerInset: UIEdgeInsets(top: 6, left: 4, bottom: 0, right: 0),
    typingAttributes: [:],
    autocapitalizationType: .sentences,
    autocorrectionType: .no,
    spellCheckingType: .no,
    smartQuotesType: .default,
    smartDashesType: .default,
    smartInsertDeleteType: .default,
    keyboardType: .default,
    keyboardAppearance: .default,
    textContentType: nil
  ),
  sendButton: ButtonComponentTheme(
    backgroundColor: .clear,
    buttonType: .custom,
    tintColor: UIColor(named: "MessageInput.SendButton.TintColor")!,
    title: .empty,
    titleHighlighted: .empty,
    titleFont: AppearanceTemplate.Font.caption1,
    image: ButtonImageStateTheme(
      image: UIImage(named: "MessageList.SendIcon")?.withTintColor(UIColor(named: "MessageInput.SendButton.TintColor")!),
      backgroundImage: nil
    ),
    imageHighlighted: .empty
  ),
  typingIndicatorService: .shared,
  publishTypingIndicator: true,
  displayTypingIndicator: false
)
