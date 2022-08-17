//
//  UIView.swift
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

extension UIView {
  
  static func customChannelListNavigationItemTitleView() -> UIView {
    
    let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 180, height: 40))
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = 18
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    imageView.image = UIImage(named: "ChatScreen.QueueIcon")
    imageView.contentMode = .scaleAspectFit
    
    let label = UILabel()
    label.text = "PATIENT QUEUE"
    label.textColor = UIColor(named: "ChannelList.NavigationBar.PrimaryTextColor")
    label.font = UIFont(name: "Poppins-Regular", size: 14)
    label.sizeToFit()
    
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(label)
    
    return stackView
  }
  
  static func customUserView(
    with primaryLabelText: String?,
    secondaryLabelText: String?,
    avatarURL: URL?,
    directionalLayoutMargins: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0),
    backgroundColor: UIColor? = UIColor(named: "CurrentUserView.BackgroundColor")!,
    primaryLabelTextColor: UIColor? = UIColor(named: "CurrentUserView.PrimaryLabelTextColor"),
    secondaryLabelTextColor: UIColor? = UIColor(named: "CurrentUserView.SecondaryLabelTextColor")
  ) -> UIView {
    
    let outerStackView = UIStackView()
    outerStackView.translatesAutoresizingMaskIntoConstraints = false
    outerStackView.backgroundColor = backgroundColor
    outerStackView.axis = .horizontal
    outerStackView.alignment = .center
    outerStackView.spacing = 9
    outerStackView.isLayoutMarginsRelativeArrangement = true
    outerStackView.directionalLayoutMargins = directionalLayoutMargins
    
    let roundedImageView = UIImageView()
    roundedImageView.translatesAutoresizingMaskIntoConstraints = false
    roundedImageView.image = UIImage(data: try! Data(contentsOf: avatarURL!) )
    roundedImageView.layer.cornerRadius = 18
    roundedImageView.contentMode = .scaleAspectFill
    roundedImageView.clipsToBounds = true

    roundedImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
    roundedImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
    let innerStackView = UIStackView()
    innerStackView.axis = .vertical
    innerStackView.alignment = .leading
    
    let usernameLabel = UILabel()
    usernameLabel.text = primaryLabelText
    usernameLabel.textColor = primaryLabelTextColor
    usernameLabel.font = UIFont(name: "Poppins-Bold", size: 14)
    usernameLabel.sizeToFit()
    
    let roleLabel = UILabel()
    roleLabel.text = secondaryLabelText
    roleLabel.textColor = secondaryLabelTextColor
    roleLabel.font = UIFont(name: "Poppins-Regular", size: 11)!
    roleLabel.sizeToFit()
    
    innerStackView.addArrangedSubview(usernameLabel)
    innerStackView.addArrangedSubview(roleLabel)
    
    outerStackView.addArrangedSubview(roundedImageView)
    outerStackView.addArrangedSubview(innerStackView)
    
    return outerStackView
  }
}
