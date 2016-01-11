//
//  NotificationService.swift
//  QuikCric
//
//  Created by Daniel on 1/7/16.
//  Copyright © 2016 danieljvdm. All rights reserved.
//

import Foundation
import UIKit

class NotificationService {
    class func sendRunNotification(score: Score) -> () {
        var notification = UILocalNotification()
        notification.alertTitle = "Century!"
        notification.alertBody = "\(score.batsmanName) \(score.runs)(\(score.balls))"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    class func sendWicketNotification(score: Score) -> () {
        var notification = UILocalNotification()
        notification.alertTitle = "Wicket!"
        notification.alertBody = "\(score.batsmanName) \(score.runs)(\(score.balls)) OUT!"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)

    }
    
}