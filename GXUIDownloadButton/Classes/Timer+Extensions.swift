//
//  Timer+Extensions.swift
//  GXUIDownloadButton
//
//  Created by Majid Hatami Aghdam on 11/14/18.
//  Copyright © 2018 Majid Hatami Aghdam. All rights reserved.
//

import UIKit

extension Timer {
    @discardableResult class func schedule(delay: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
    @discardableResult class func schedule(repeatInterval interval: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
    
    
    /*class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
     let fireDate = delay + CFAbsoluteTimeGetCurrent()
     let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
     CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
     return timer
     }
     
     class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
     let fireDate = interval + CFAbsoluteTimeGetCurrent()
     let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
     CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
     return timer
     }*/
}
