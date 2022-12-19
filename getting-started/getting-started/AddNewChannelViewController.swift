//
//  AddNewChannelViewController.swift
//  getting-started
//
//  Created by Jakub Guz on 1/4/23.
//

import UIKit
import PubNubChat
import PubNubChatComponents

class AddNewChannelViewController: UIViewController {
  private weak var textField: UITextField?
  private weak var cancelButton: UIButton?
  private weak var createButton: UIButton?
  
  private let chatProvider: PubNubChatProvider
  
  init(chatProvider: PubNubChatProvider) {
    self.chatProvider = chatProvider
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fill
    stackView.axis = .vertical
    stackView.alignment = .center
    
    let textField = UITextField()
    textField.placeholder = "Enter the room name"
    textField.clearButtonMode = .always
    textField.borderStyle = .roundedRect
    
    let createButton = UIButton(type: .system)
    createButton.setTitle("Create", for: .normal)
    createButton.addTarget(self, action: #selector(Self.createButtonTapped(_:)), for: .touchUpInside)
    
    let cancelButton = UIButton(type: .system)
    cancelButton.tintColor = .red
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.addTarget(self, action: #selector(Self.cancelButtonTapped(_:)), for: .touchUpInside)
    
    view.backgroundColor = .white
    view.addSubview(stackView)
    
    stackView.addArrangedSubview(textField)
    stackView.setCustomSpacing(10, after: textField)
    stackView.addArrangedSubview(createButton)
    stackView.setCustomSpacing(30, after: createButton)
    stackView.addArrangedSubview(cancelButton)
    
    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    self.textField = textField
    self.cancelButton = cancelButton
    self.createButton = createButton
  }
  
  @objc func cancelButtonTapped(_ sender: UIButton) {
    dismiss(animated: true)
  }
  
  @objc func createButtonTapped(_ sender: UIButton) {
    guard let currentUser: PubNubChatUser = try? chatProvider.fetchCurrentUser().convert() else {
      return
    }
    
    let channelName = textField?.text ?? String()
    let channel = PubNubChatChannel(
      id: channelName,
      name: channelName,
      type: nil,
      status: nil,
      avatarURL: URL(string: "https://picsum.photos/seed/\(channelName)/200")
    )
    
    let members = PubNubChatMember(
      channel: channel,
      user: currentUser
    )
    
    chatProvider.dataProvider.createRemoteChannel(ChatChannelRequest(channel: channel, includeCustom: true), completion: { [weak self] result in
      switch result {
      case .success(let channel):
        debugPrint("Did create channel: \(channel)")
        self?.chatProvider.dataProvider.createRemoteMembers(MembersModifyRequest(members: [members], modificationDirection: .modifyChannelsByUser), completion: { res in
          switch res {
          case .success(_):
            debugPrint("Did create remote members: \(res)")
            self?.dismiss(animated: true)
          case .failure(let error):
            debugPrint(error)
          }
        })
      case .failure(let error):
        debugPrint(error)
      }
    })
  }
}
