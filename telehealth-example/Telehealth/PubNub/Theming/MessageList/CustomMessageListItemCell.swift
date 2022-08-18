//
//  CustomMessageListItemCell.swift
//  Telehealth
//
//  Created by Jakub Guz on 8/10/22.
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
