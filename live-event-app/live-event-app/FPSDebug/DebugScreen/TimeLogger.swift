//
//  TimeLogger.swift
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

enum LoggerError: Error {
  case eventDoesNotStarted(String)
}

public protocol TimeLogger {
  var logs: [String] { get }
  func add(_ log: String)
  
  func logEventStarted(_ name: String)
  func logEventFinished(_ name: String) throws
}

public final class DefaultTimeLogger: TimeLogger {
  public static let shared: TimeLogger = DefaultTimeLogger()
  public private(set) var logs: [String] = []
  private var eventsStartTime: [String : TimeInterval] = [:]
  
  public func add(_ log: String) {
    logs.append(log)
  }
  
  public func logEventStarted(_ name: String) {
    add("\(name) event started")
    eventsStartTime[name] = CFAbsoluteTimeGetCurrent()
  }
  
  public func logEventFinished(_ name: String) throws {
    guard let startTime = eventsStartTime[name] else {
      throw LoggerError.eventDoesNotStarted(name)
    }
    let dt = CFAbsoluteTimeGetCurrent() - startTime
    
    add("\(name) finished in \(dt)s")
  }
  
  private init() {}
}

extension TimeLogger {
  public func description() -> String {
    logs.reduce("") {
      "\($0)\($1)\n"
    }
  }
}
