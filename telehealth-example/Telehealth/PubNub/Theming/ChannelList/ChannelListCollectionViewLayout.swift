//
//  CustomChannelListCollectionViewLayout.swift
//  Telehealth
//
//  Created by Jakub Guz on 8/8/22.
//

import UIKit
import PubNubChatComponents

final class ChannelListCollectionViewLayout: UICollectionViewLayout, CollectionViewLayoutComponent {
  static func create(usingSupplimentaryItems: Bool) -> UICollectionViewLayout {
    
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(70.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    
    if usingSupplimentaryItems {
      let headerSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(5.0)
      )
      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [header]
    }
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0, leading: 0, bottom: 0, trailing: 0
    )
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 10
    
    let layout = UICollectionViewCompositionalLayout(
      section: section,
      configuration: config
    )
    
    return layout
  }
}
