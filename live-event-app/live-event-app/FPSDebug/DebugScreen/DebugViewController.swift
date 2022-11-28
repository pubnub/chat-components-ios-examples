//
//  DebugViewController.swift
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

public final class DebugViewController: UIViewController {
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()
  private let label = UILabel()
  private let logger: TimeLogger
  private let frames: [FrameInfo]
  private lazy var fpsLineChart = UIFPSLinearChart(fpsInfoArray: frames)
  
  public init(logger: TimeLogger = DefaultTimeLogger.shared, frames: [FrameInfo] = []) {
    self.logger = logger
    self.frames = frames.filter { $0.fps < 70 }
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    do {
      try setup(logger: logger)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - private
private extension DebugViewController {
  private func setup(logger: TimeLogger) throws {
    try setupScrollView()
    try setupStackView()
    try setupFPSLineChart()
    try setupLabel()
    
    label.text = logger.description()
  }
  
  private func setupScrollView() throws {
    view?.addSubview(scrollView)
    try scrollView.embedInSuperview()
  }
  
  private func setupStackView() throws {
    scrollView.addSubview(stackView)
    try stackView.embedInSuperview()
    try stackView.activate { view, _ in [
      view.widthAnchor.constraint(equalTo: view.widthAnchor),
      view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ]}
    stackView.axis = .vertical
  }
  
  private func setupLabel() throws {
    stackView.addArrangedSubview(label)
    label.numberOfLines = 0
    view.backgroundColor = .white
  }
  
  private func setupFPSLineChart() throws {
    stackView.addArrangedSubview(fpsLineChart)
    
    try fpsLineChart.activate { view, _ in [
      view.heightAnchor.constraint(equalToConstant: 200)
    ]}
  }
}
