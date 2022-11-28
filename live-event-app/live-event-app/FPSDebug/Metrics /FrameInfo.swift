//
//  FrameInfo.swift
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

public struct FrameInfo {
  public let creationTime: TimeInterval
  public let deltaTime: TimeInterval
  public let frameNumber: UInt
  
  public init(previous: FrameInfo) {
    creationTime = CFAbsoluteTimeGetCurrent()
    deltaTime = creationTime - previous.creationTime
    frameNumber = previous.frameNumber + 1
  }
  
  public init(creationTime: TimeInterval = CFAbsoluteTimeGetCurrent(), deltaTime: TimeInterval = Double.leastNonzeroMagnitude, frameNumber: UInt = 0) {
    self.creationTime = creationTime
    self.deltaTime = deltaTime
    self.frameNumber = frameNumber
  }
}

// MARK: - Computed Properties
extension FrameInfo {
  public var fps: Double { 1.0 / deltaTime }
  public var description: String {
    "\(String(format: "%.2f", deltaTime))s\n\(String(format: "%.0f", fps))fps\n\(frameNumber)"
  }
}

// MARK: - Identifiable
extension FrameInfo: Identifiable {
  public var id: UInt {
    frameNumber
  }
}
