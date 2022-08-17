//
//  MessageListTheme.swift
//  getting-started
//
//  Created by Jakub Guz on 5/30/22.
//

import UIKit
import PubNubChat
import PubNubChatComponents
import Combine
import ChatLayout

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
    imageView: ImageComponentTheme(customType: UIImageView.self, cornerRadius: 15),
    primaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Bold", size: 11),
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
    imageView: ImageComponentTheme(customType: UIImageView.self, cornerRadius: 15),
    primaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Bold", size: 11),
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
