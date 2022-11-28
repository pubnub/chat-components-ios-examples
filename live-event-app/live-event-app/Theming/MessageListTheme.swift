//
//  MessageListTheme.swift
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
import Combine
import ChatLayout

let navigationBarAppearance: UINavigationBarAppearance = {
  let appearance = UINavigationBarAppearance()
  appearance.configureWithDefaultBackground()
  appearance.backgroundColor = UIColor(named: "MessageList.NavigationBar.BackgroundColor")!
  return appearance
}()

let navigationBarTheme = NavigationBarTheme(
  largeTitleDisplayMode: .never,
  standardAppearance: navigationBarAppearance,
  compactAppearance: navigationBarAppearance,
  scrollEdgeAppearance: navigationBarAppearance,
  customTitleView: .empty,
  barButtonThemes: [:]
)

let messageListCollectionViewTheme = CollectionViewComponentTheme(
  viewType: UICollectionView.self,
  layoutType: CollectionViewChatLayout.self,
  headerType: ReusableLabelViewComponent.self,
  footerType: ReusableLabelViewComponent.self,
  backgroundColor: UIColor(named: "MessageList.BackgroundColor")!,
  scrollViewTheme: .init(isScrollEnabled: true, bounces: true, scrollsToTop: true),
  refreshControlTheme: nil,
  prefetchIndexThreshold: nil,
  isPrefetchingEnabled: false
)

let autorItemTheme = MessageListCellComponentTheme(
  textMessageContentCellType: CustomMessageListItemCell.self,
  backgroundColor: .clear,
  highlightColor: .clear,
  selectedColor: .clear,
  alignment: .leading,
  maxWidthPercentage: 0.65,
  bubbleContainerTheme: BubbleComponentTheme(
    alignment: .leading,
    containerType: .normal,
    backgroundColor: UIColor(named: "MessageList.Cell.AuthorBackgroundColor")!,
    tailSize: 0,
    layoutMargin: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  ),
  contentTextTheme: TextViewComponentTheme(
    customType: UITextView.self,
    backgroundColor: .clear,
    textColor: UIColor(named: "MessageList.Cell.AuthorTextContentColor")!,
    textFont: UIFont(name: "Poppins-Regular", size: 14)!,
    usesStandardTextScaling: false,
    dataDetectorTypes: .all,
    linkTextAttributes: [:],
    isEditable: false,
    isExclusiveTouch: false,
    scrollView: .disabled,
    textContainerInset: .zero
  ),
  itemTheme: BasicComponentTheme(
    imageView: ImageComponentTheme(customType: UIImageView.self, cornerRadius: 10),
    primaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Regular", size: 12),
      textColor: UIColor(named: "MessageList.Cell.AuthorTextColor")!,
      adjustsFontForContentSizeCategory: true,
      textAlignment: .natural,
      textMargin: .zero
    ),
    secondaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Regular", size: 11),
      textColor: UIColor(named: "MessageList.Cell.AuthorTextColor")!,
      adjustsFontForContentSizeCategory: true,
      textAlignment: .natural,
      textMargin: .zero
    )
  ),
  dateFormatter: .messageInline
)

let incomingItemTheme = MessageListCellComponentTheme(
  textMessageContentCellType: CustomMessageListItemCell.self,
  backgroundColor: .clear,
  highlightColor: .clear,
  selectedColor: .clear,
  alignment: .trailing,
  maxWidthPercentage: 0.65,
  bubbleContainerTheme: BubbleComponentTheme(
    alignment: .trailing,
    containerType: .normal,
    backgroundColor: UIColor(named: "MessageList.Cell.IncomingBackgroundColor")!,
    tailSize: 0,
    layoutMargin: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  ),
  contentTextTheme: TextViewComponentTheme(
    customType: UITextView.self,
    backgroundColor: .clear,
    textColor: UIColor(named: "MessageList.Cell.IncomingTextColor")!,
    textFont: UIFont(name: "Poppins-Regular", size: 15)!,
    usesStandardTextScaling: false,
    dataDetectorTypes: .all,
    linkTextAttributes: [:],
    isEditable: false,
    isExclusiveTouch: false,
    scrollView: .disabled,
    textContainerInset: .zero
  ),
  itemTheme: BasicComponentTheme(
    imageView: ImageComponentTheme(customType: UIImageView.self, cornerRadius: 10),
    primaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Regular", size: 12),
      textColor: UIColor(named: "MessageList.Cell.IncomingAuthorTextColor")!,
      adjustsFontForContentSizeCategory: true,
      textAlignment: .natural,
      textMargin: .zero
    ),
    secondaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Regular", size: 11),
      textColor: UIColor(named: "MessageList.Cell.IncomingAuthorTextColor")!,
      adjustsFontForContentSizeCategory: true,
      textAlignment: .natural,
      textMargin: .zero
    )
  ),
  dateFormatter: .messageInline
)

let messageListComponentTheme = MessageListComponentTheme(
  controllerType: CollectionViewComponent.self,
  backgroundColor: .clear,
  navigationBarTheme: navigationBarTheme,
  collectionViewTheme:  messageListCollectionViewTheme,
  messageInputComponent: messageInputComponentTheme,
  incomingItemTheme: incomingItemTheme,
  authorItemTheme: autorItemTheme,
  typingIndicatorCellTheme: AnimatedTypingIndicatorCellTheme(
    cellType: IMessageTypingIndicatorCell.self,
    contentViewType: IMessageTypingBubbleView.self,
    backgroundColor: .clear,
    highlightColor: .clear,
    selectedColor: .clear,
    primaryContentColor: .clear,
    secondaryContentColor: .clear,
    animationEnabled: true,
    pulsing: true,
    bounces: true,
    bounceDelay: 0.33,
    bounceOffset: 0.25,
    fades: true
  ),
  enableReactions: false
)

class CustomMessageListItemCell: MessageCollectionViewCellComponent {
  
  private var authorAvatarView: PubNubInlineAvatarComponentView!
  private var messageContentView: PubNubMessageContentTextView!
  
  override func setupSubviews() {
    super.setupSubviews()
    
    authorAvatarView = PubNubInlineAvatarComponentView()
    messageContentView = PubNubMessageContentTextView()
    
    authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
    messageContentView.translatesAutoresizingMaskIntoConstraints = false
    
    cellContainer.axis = .horizontal
    cellContainer.distribution = .fill
    cellContainer.isLayoutMarginsRelativeArrangement = false
    cellContainer.alignment = .center
    
    cellContainer.stackView.addArrangedSubview(authorAvatarView)
    cellContainer.stackView.setCustomSpacing(10, after: authorAvatarView)
    cellContainer.stackView.addArrangedSubview(messageContentView)
    
    authorAvatarView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    authorAvatarView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    delegate = messageContentView
  }
  
  open override func configure<Message: ManagedMessageViewModel>(
    _ message: Message,
    theme: MessageListCellComponentTheme
  ) {
    authorAvatarView.imageView
      .configure(
        message.userViewModel.userAvatarUrlPublisher,
        placeholder: theme.itemTheme.imageView.$localImage.eraseToAnyPublisher(),
        cancelIn: &contentCancellables
      )
      .theming(theme.itemTheme.imageView, cancelIn: &contentCancellables)
    
    messageContentView.textView
      .configure(message.messageTextPublisher, cancelIn: &contentCancellables)
      .theming(theme.contentTextTheme, cancelIn: &contentCancellables)
  }
}
