//
//  ChannelListItemCell.swift
//  Telehealth
//
//  Created by Jakub Guz on 8/8/22.
//

import UIKit
import PubNubChatComponents

class ChannelListItemCell: ChannelMemberComponentCell {
  
  override func setupSubviews() {
    
    super.setupSubviews()
    cellContainer.spacing = 11
    
    let constraintsToRemove = primaryImageView?.constraints.filter() {
      $0.firstAttribute == .width || $0.firstAttribute == .height
    } ?? []
        
    cellContainer.isLayoutMarginsRelativeArrangement = true
    cellContainer.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 0)
    
    primaryImageView?.removeConstraints(constraintsToRemove)
    primaryImageView?.imageView.contentMode = .scaleAspectFill
    primaryImageView?.widthAnchor.constraint(equalToConstant: 46).isActive = true
    primaryImageView?.heightAnchor.constraint(equalToConstant: 46).isActive = true
  }
}
