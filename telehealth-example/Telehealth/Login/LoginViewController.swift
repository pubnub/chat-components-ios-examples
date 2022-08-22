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

final class LoginViewController: UIViewController {
  
  @IBOutlet private var infoLabel: UILabel!
  @IBOutlet private var loginTextField: UITextField!
  @IBOutlet private var passwordTextField: UITextField!
  @IBOutlet private var errorView: UIView!
  
  private var provider: TelehealthChatProvider?
  private var coordinator: ChatFlowCoordinator?
  
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
    guard let provider = provider, let navigationController = navigationController else {
      print("encountered nil during configuration")
      return
    }
      
    do {
      coordinator = DefaultChatFlowCoordinator(navigationController: navigationController, provider: provider)
      try coordinator?.start()
    } catch {
      print(error)
    }
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
