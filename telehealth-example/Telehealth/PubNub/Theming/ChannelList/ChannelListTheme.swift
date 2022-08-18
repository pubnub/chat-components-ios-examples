//
//  ChannelListTheme.swift
//  getting-started
//
//  Created by Jakub Guz on 5/30/22.
//

import Foundation
import UIKit
import PubNubChat
import PubNubChatComponents

let navigationBarAppearance: UINavigationBarAppearance = {
  
  let appearance = UINavigationBarAppearance()
  appearance.configureWithDefaultBackground()
  appearance.backgroundColor = UIColor(named: "ChannelList.NavigationBar.BackgroundColor")!
  
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

let channelListCollectionViewTheme = CollectionViewComponentTheme(
    viewType: UICollectionView.self,
    layoutType: ChannelListCollectionViewLayout.self,
    headerType: ReusableLabelViewComponent.self,
    footerType: ReusableLabelViewComponent.self,
    backgroundColor: UIColor(named: "ChannelList.BackgroundColor")!,
    scrollViewTheme: .init(isScrollEnabled: true, bounces: true, scrollsToTop: true),
    refreshControlTheme: nil,
    prefetchIndexThreshold: nil,
    isPrefetchingEnabled: true
)
        
let channelListCellTheme = ChannelListCellComponentTheme(
    cellType: ChannelListItemCell.self,
    backgroundColor: .clear,
    highlightColor: UIColor(named: "ChannelList.Cell.HighlightedColor")!,
    selectedColor: UIColor(named: "ChannelList.Cell.SelectedColor")!,
    itemTheme: BasicComponentTheme(
      imageView: ImageComponentTheme(customType: UIImageView.self, cornerRadius: 23, margin: .zero),
        primaryLabel: LabelComponentTheme(
            customType: UILabel.self,
            textFont: UIFont(name: "Poppins-Regular", size: 16),
            textColor: UIColor(named: "ChannelList.Cell.PrimaryLabelTextColor")!,
            adjustsFontForContentSizeCategory: true,
            textAlignment: .natural,
            textMargin: .zero
        ),
        secondaryLabel: LabelComponentTheme(
            customType: UILabel.self,
            textFont: UIFont(name: "Poppins-Regular", size: 14),
            textColor: UIColor(named: "ChannelList.Cell.SecondaryLabelTextColor")!,
            adjustsFontForContentSizeCategory: true,
            textAlignment: .natural,
            textMargin: .zero
        )
    )
)

let channelListComponentTheme = ChannelListComponentTheme(
    controllerType: CollectionViewComponent.self,
    backgroundColor: UIColor(named: "ChannelList.BackgroundColor")!,
    navigationBarTheme: navigationBarTheme,
    collectionViewTheme: channelListCollectionViewTheme,
    sectionHeaderTheme: .empty,
    cellTheme: channelListCellTheme
)
