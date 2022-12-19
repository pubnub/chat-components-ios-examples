//
//  MemberListTheme.swift
//  getting-started
//
//  Created by Jakub Guz on 12/19/22.
//

import UIKit
import PubNubChat
import PubNubChatComponents
import Combine

let memberListComponentTheme = MemberListComponentTheme(
  controllerType: CollectionViewComponent.self,
  backgroundColor: .secondarySystemBackground,
  navigationBarTheme: navigationBarTheme,
  collectionViewTheme: .pubnubDefaultGroupCollectionView,
  sectionHeaderLabel: .pubnubDefaultGroupSectionHeader,
  cellTheme: MemberListCellComponentTheme(
    cellType: ChannelMemberComponentCell.self,
    backgroundColor: .clear,
    highlightColor: .clear,
    selectedColor: .clear,
    itemTheme: BasicComponentTheme(
      imageView: .pubnubDefaultGroupInline,
      primaryLabel: LabelComponentTheme(
        customType: UILabel.self,
        textFont: UIFont(name: "Poppins-Medium", size: 14)!,
        textColor: AppearanceTemplate.Color.label,
        adjustsFontForContentSizeCategory: true,
        textAlignment: .natural,
        textMargin: .zero
      ),
      secondaryLabel: .pubnubDefaultGroupListItemSecondary
    )
  )
)
