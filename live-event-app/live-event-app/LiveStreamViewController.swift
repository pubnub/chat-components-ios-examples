//
//  LiveStremViewController.swift
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

// YouTubeiOSPlayerHelper
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import YouTubeiOSPlayerHelper

protocol LiveStreamPlayerView {
  func loadVideo()
  func play()
}

final class LiveStreamViewController: UIViewController {
  private weak var playerView: (UIView & LiveStreamPlayerView)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
       
    let playerView = createPlayerView()
    playerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(playerView)
    self.playerView = playerView
    
    NSLayoutConstraint.activate([
      playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      playerView.topAnchor.constraint(equalTo: view.topAnchor),
      playerView.widthAnchor.constraint(equalTo: view.widthAnchor),
      playerView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    
    playerView.loadVideo()
  }
  
  private func createPlayerView() -> UIView & LiveStreamPlayerView {
    let youtubePlayerView = YTPlayerView()
    youtubePlayerView.delegate = self
    return youtubePlayerView
  }
}

extension YTPlayerView: LiveStreamPlayerView {
  public func loadVideo() {
    load(
      withVideoId: "b42bhUfcLxc",
      playerVars: ["playsinline": 1]
    )
  }
  public func play() {
    playVideo()
  }
}

extension LiveStreamViewController: YTPlayerViewDelegate {
  func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    playerView.playVideo()
  }
  
  func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
    debugPrint("The player view received an error: \(error)")
  }
}
