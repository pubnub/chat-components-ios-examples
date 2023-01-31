//
//  RootViewController.swift
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
import PubNubChatComponents

final class RootViewController: UIViewController {
  private let provider: PubNubChatProvider
  private let channelId: String
  private var portraitConstraints: [NSLayoutConstraint] = []
  private var landscapeConstraints: [NSLayoutConstraint] = []
  private var scene: UIWindowScene
  
  init(
    channelId: String,
    provider: PubNubChatProvider,
    scene: UIWindowScene
  ) {
    self.channelId = channelId
    self.provider = provider
    self.scene = scene
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let messageListViewModel = try? provider.messageListComponentViewModel(pubnubChannelId: channelId) else {
      preconditionFailure("Missing required data. Make sure the channel object and current user are stored locally")
    }
    
    messageListViewModel.customNavigationTitleString = nil
    messageListViewModel.customNavigationTitleView = { viewModel in
      let customTitleView = UILabel()
      customTitleView.font = UIFont(name: "Poppins-Bold", size: 14)
      customTitleView.textColor = UIColor(named: "MessageList.NavigationBar.TitleTextColor")
      customTitleView.text = "STREAM CHAT"
      customTitleView.sizeToFit()
      return customTitleView
    }
    
    let messageListViewController = messageListViewModel.configuredComponentView()
    let messageListContainerViewController = UINavigationController(rootViewController: messageListViewController)
    let streamViewController = LiveStreamViewController()
        
    createContainerViewController(
      messageListContainerViewController: messageListContainerViewController,
      streamViewController: streamViewController
    )
    applyConstraints(
      streamViewController: streamViewController,
      messageListContainerViewController: messageListContainerViewController
    )
    setUpMetricsView()
  }
  
  private func createContainerViewController(
    messageListContainerViewController: UINavigationController,
    streamViewController: UIViewController
  ) {
    self.addChild(messageListContainerViewController)
    self.addChild(streamViewController)
    self.view.addSubview(messageListContainerViewController.view)
    self.view.addSubview(streamViewController.view)
            
    messageListContainerViewController.didMove(toParent: self)
    streamViewController.didMove(toParent: self)
  }
  
  private func applyConstraints(
    streamViewController: UIViewController,
    messageListContainerViewController: UIViewController
  ) {
    messageListContainerViewController.view.translatesAutoresizingMaskIntoConstraints = false
    streamViewController.view.translatesAutoresizingMaskIntoConstraints = false

    portraitConstraints = [
      messageListContainerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      messageListContainerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      messageListContainerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      messageListContainerViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 9.0 / 16.0),
      streamViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      streamViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      streamViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      streamViewController.view.bottomAnchor.constraint(equalTo: messageListContainerViewController.view.topAnchor)
    ]
    landscapeConstraints = [
      streamViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      streamViewController.view.trailingAnchor.constraint(equalTo: messageListContainerViewController.view.leadingAnchor),
      streamViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
      streamViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      messageListContainerViewController.view.leadingAnchor.constraint(equalTo: streamViewController.view.trailingAnchor),
      messageListContainerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      messageListContainerViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 7.0 / 16.0),
      messageListContainerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      messageListContainerViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
    ]
    
    NSLayoutConstraint.activate(
      scene.interfaceOrientation.isPortrait ? portraitConstraints : landscapeConstraints
    )
  }
  
  private func setUpMetricsView() {
    let metricsView = MetricsView()
    view.addSubview(metricsView)
    view.bringSubviewToFront(metricsView)
    
    try? metricsView.activate {[
      $0.topAnchor.constraint(equalTo: $1.topAnchor, constant: 40),
      $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor, constant: -20)
    ]}
  }
  
  override func willTransition(
    to newCollection: UITraitCollection,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.willTransition(
      to: newCollection,
      with: coordinator
    )
    coordinator.animate { context in
      NSLayoutConstraint.deactivate(self.scene.interfaceOrientation.isPortrait ? self.landscapeConstraints : self.portraitConstraints)
      NSLayoutConstraint.activate(self.scene.interfaceOrientation.isPortrait ? self.portraitConstraints : self.landscapeConstraints)
    }
  }
}
