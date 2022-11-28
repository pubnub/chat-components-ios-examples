//
//  UIFPSLinearChart.swift
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

import SwiftUI
import UIKit
import Charts

enum SwiftUIError: Error {
  case noViewError
}

public final class UIFPSLinearChart: UIView {
  var fpsInfoArray: [FrameInfo]
  
  public init(fpsInfoArray: [FrameInfo]) {
    self.fpsInfoArray = fpsInfoArray
    super.init(frame: .zero)
    try? setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension UIFPSLinearChart {
  private func setup() throws {
    guard let chartView = UIHostingController(rootView: FPSLinearChartView(frameInfo: fpsInfoArray)).view else {
      throw SwiftUIError.noViewError
    }
    
    addSubview(chartView)
    try chartView.embedInSuperview()
  }
}

public struct FPSLinearChartView: View {
  let frameInfo: [FrameInfo]
  
  public init(frameInfo: [FrameInfo]) {
    self.frameInfo = frameInfo
  }
  
  public var body: some View {
    if #available(iOS 16.0, *) {
      Chart {
        ForEach(frameInfo) { info in
          LineMark(x: .value("Frame", info.frameNumber),
                   y: .value("FPS", info.fps)
          )
        }
      }
    } else {
      Text("chart is not available")
    }
  }
}
