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
        let notification = UILocalNotification()
        notification.alertTitle = score.runs >= 100 ? "Century!" : "Fifty!"
        notification.alertBody = "\(score.batsmanName!) \(score.runs)(\(score.balls))"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    class func sendWicketNotification(score: Score) -> () {
        let notification = UILocalNotification()
        notification.alertTitle = "Wicket!"
        notification.alertBody = "\(score.batsmanName!) \(score.runs)(\(score.balls)) OUT!"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)

    }
    
}

extension Match {
    func compareWith(oldMatch: Match) {
        for (index, score) in self.innings[0].scores.enumerate() {

            let oldScore = oldMatch.innings[0].scores[index]

            if !oldScore.out && score.out {
                NotificationService.sendWicketNotification(score)
                //new wicket
            }
            if (oldScore.runs < 100 && score.runs >= 100) || (oldScore.runs < 50 && score.runs >= 50) {
                NotificationService.sendRunNotification(score)
                //GRATS ON THE CENTURY BRAH
            }
        }
        
    }
    
}