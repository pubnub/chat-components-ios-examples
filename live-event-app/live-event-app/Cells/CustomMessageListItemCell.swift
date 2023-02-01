//
//  CustomMessageListItemCell.swift
//  live-event-app
//
//  Created by Maciej Adamczyk on 01/02/2023.
//

import PubNubChatComponents

final class CustomMessageListItemCell: MessageCollectionViewCellComponent {
  private var authorAvatarView: PubNubInlineAvatarComponentView!
  private var messageContentView: PubNubMessageContentTextView!
  
  override func setupSubviews() {
    super.setupSubviews()
    setupAuthorAvatarView()
    setupMessageContentView()
    setupCellContainer()
    
    delegate = messageContentView
  }
  
  public override func configure<Message: ManagedMessageViewModel>(
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

// MARK: - Setup
private extension CustomMessageListItemCell {
  private func setupAuthorAvatarView() {
    authorAvatarView = PubNubInlineAvatarComponentView()
    authorAvatarView.translatesAutoresizingMaskIntoConstraints = false
    authorAvatarView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    authorAvatarView.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  private func setupMessageContentView() {
    messageContentView = PubNubMessageContentTextView()
    messageContentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupCellContainer() {
    cellContainer.axis = .horizontal
    cellContainer.distribution = .fill
    cellContainer.isLayoutMarginsRelativeArrangement = false
    cellContainer.alignment = .center
    cellContainer.stackView.addArrangedSubview(authorAvatarView)
    cellContainer.stackView.setCustomSpacing(10, after: authorAvatarView)
    cellContainer.stackView.addArrangedSubview(messageContentView)
  }
}
