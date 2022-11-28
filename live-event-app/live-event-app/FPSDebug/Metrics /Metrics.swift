//
//  Metrics.swift
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

import Foundation
import UIKit
import Combine

public final class MetricsView: UIView {
  private let metricsLabel = UILabel()
  
  private var frameCounter: FrameCounter
  private var cancellables = Set<AnyCancellable>()
  
  public init(frameCounter: FrameCounter = DefaultFrameCounter()) {
    self.frameCounter = frameCounter
    super.init(frame: .zero)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - private
private extension MetricsView {
  private func setup() {
    do {
      try setupLabel()
    } catch {
      print(error)
    }
    setupSubscriber()
  }

  private func setupLabel() throws {
    addSubview(metricsLabel)
    try metricsLabel.embedInSuperview()
    metricsLabel.numberOfLines = 0
  }
  
  private func setupSubscriber() {
    frameCounter
      .publisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak metricsLabel] in
        metricsLabel?.text = $0.description

        let red = 1 - $0.fps / 60.0
        let green = $0.fps / 60.0
        metricsLabel?.backgroundColor = UIColor(red: red, green: green, blue: 0.5, alpha: 1)
      })
      .store(in: &cancellables)
    
    frameCounter.start()
  }
}
