//
//  MessageInputTheme.swift
//  getting-started
//
//  Created by Jakub Guz on 5/30/22.
//

import UIKit
import PubNubChat
import PubNubChatComponents

let messageInputComponentTheme = MessageInputComponentTheme(
    viewType: MessageInputBarComponent.self,
    backgroundColor: UIColor(named: "MessageInput.BackgroundColor")!,
    placeholderText: "Write a message",
    placeholderTextColor: UIColor(named: "MessageInput.TextView.PlaceholderTextColor")!,
    placeholderTextFont: UIFont(name: "Poppins-Regular", size: 15)!,
    textInputTheme: InputTextViewComponentTheme(
        customType: UITextView.self,
        backgroundColor: UIColor(named: "MessageInput.TextView.BackgroundColor")!,
        textColor: UIColor(named: "MessageInput.TextView.TextColor")!,
        textFont: UIFont(name: "Poppins-Regular", size: 15)!,
        usesStandardTextScaling: true,
        dataDetectorTypes: .all,
        linkTextAttributes: [:],
        isEditable: true,
        isExclusiveTouch: false,
        scrollView: .enabled,
        textContainerInset: .zero,
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
