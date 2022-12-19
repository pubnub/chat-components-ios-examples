//
//  ChannelListTheme.swift
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

import Foundation
import UIKit
import PubNubChat
import PubNubChatComponents

let navigationBarAppearance: UINavigationBarAppearance = {
  let appearance = UINavigationBarAppearance()
  appearance.configureWithDefaultBackground()
  appearance.backgroundColor = UIColor(named: "ChannelList.NavigationBar.BackgroundColor")!
  appearance.titleTextAttributes = [.foregroundColor : UIColor(named: "ChannelList.NavigationBar.ForegroundColor")!]
  return appearance
}()

let navigationBarTheme = NavigationBarTheme(
  largeTitleDisplayMode: .never,
  standardAppearance: navigationBarAppearance,
  compactAppearance: navigationBarAppearance,
  scrollEdgeAppearance: navigationBarAppearance,
  customTitleView: BasicComponentTheme(
    imageView: .empty,
    primaryLabel: LabelComponentTheme(
      customType: UILabel.self,
      textFont: UIFont(name: "Poppins-Bold", size: 13),
      textColor: .white,
      adjustsFontForContentSizeCategory: true,
      textAlignment: .center,
      textMargin: .zero
    )
  ),
  barButtonThemes: [
    "memberPresenceCount": BarButtonItemTheme(
      viewType: BarButtonItemComponent.self,
      buttonTheme: ButtonComponentTheme(
        backgroundColor: nil,
        buttonType: .system,
        tintColor: UIColor(named: "ChannelList.NavigationBar.ForegroundColor")!,
        title: .empty,
        titleHighlighted: .empty,
        titleFont: nil,
        image: ButtonImageStateTheme(
          image: AppearanceTemplate.Image.members,
          backgroundImage: nil
        ),
        imageHighlighted: .empty
      ),
      buttonItemAppearance: UIBarButtonItemAppearance()
    )
  ]
)

let channelListCollectionViewTheme = CollectionViewComponentTheme(
  viewType: UICollectionView.self,
  layoutType: TableCollectionViewLayout.self,
  headerType: ReusableLabelViewComponent.self,
  footerType: ReusableLabelViewComponent.self,
  backgroundColor: UIColor(named: "ChannelList.BackgroundColor")!,
  scrollViewTheme: .init(isScrollEnabled: true, bounces: true, scrollsToTop: true),
  refreshControlTheme: nil,
  prefetchIndexThreshold: nil,
  isPrefetchingEnabled: true
)

let channelListCellTheme = ChannelListCellComponentTheme(
  cellType: ChannelMemberComponentCell.self,
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
