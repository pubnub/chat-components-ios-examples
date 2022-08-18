//
//  LoginViewController.swift
//
//  PubNub Real-time Cloud-Hosted Push API and Push Notification Client Frameworks
//  Copyright © 2021 PubNub Inc.
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

class LoginViewController: UIViewController {
  
  @IBOutlet private var infoLabel: UILabel!
  @IBOutlet private var loginTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var errorView: UIView!
  
  private var provider: TelehealthChatProvider?
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = String()
    navigationController?.navigationBar.tintColor = UIColor(named: "ChannelList.NavigationBar.TintColor")
   
    if let currentAttrString = infoLabel.attributedText {
      
      let mutableVersion = NSMutableAttributedString(attributedString: currentAttrString)
      let range = NSRange(location: 0, length: mutableVersion.length - "Demo page".count)
      
      mutableVersion.addAttribute(
        .foregroundColor,
        value: UIColor(named: "LoginScreen.InfoView.TextColor")!,
        range: range
      )
      
      infoLabel.attributedText = mutableVersion
    }
  }
  
  @IBAction func onLoginButtonTapped(_ sender: UIButton) {
        
    provider = TelehealthChatProvider(with: loginTextField.text ?? String(), completion: { [weak self] in
      self?.configureFinalViewController()
    })
    
    errorView.isHidden = provider != nil
  }
  
  private func configureFinalViewController() {
    
    guard let provider = provider else {
      return
    }
    
    if provider.hasDoctorRole {
      navigationController?.pushViewController(
        CustomSplitViewController(provider: provider),
        animated: true
      )
    } else {
      navigationController?.setNavigationBarHidden(false, animated: false)
      setUpMessageListForPatient(using: provider)
    }
  }
  
  private func setUpMessageListForPatient(using provider: TelehealthChatProvider) {
    
    guard let currentUser = try? provider.chatProvider.fetchCurrentUser() else {
      preconditionFailure("Cannot fetch current user")
    }
    guard let membership = currentUser.memberships.first(where: { $0.managedUser.id == provider.uuid }) else {
      preconditionFailure("Cannot fetch membership for the current user")
    }
    guard let messageListViewModel = try? provider.chatProvider.messageListComponentViewModel(pubnubChannelId: membership.channelId) else {
      preconditionFailure("Cannot create message list for the channel ID: \(membership.channelId)")
    }
    
    messageListViewModel.customNavigationTitleString = nil
    messageListViewModel.leftBarButtonNavigationItems = nil
    messageListViewModel.rightBarButtonNavigationItems = nil
    messageListViewModel.customNavigationTitleView = { viewModel in
      UIView.customUserView(
        with: membership.channel.name,
        secondaryLabelText: membership.channel.details,
        avatarURL: membership.channel.avatarURL,
        backgroundColor: .clear,
        primaryLabelTextColor: .white,
        secondaryLabelTextColor: .white
      )
    }
    
    self.navigationController?.pushViewController(
      messageListViewModel.configuredComponentView(),
      animated: true
    )
  }
  
  @IBAction func onInfoLabelTapped(_ sender: UIGestureRecognizer) {
    let url = URL(string: "https://www.google.pl")!
    
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}

extension LoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
}
