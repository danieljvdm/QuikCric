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
        notification.alertBody = "\(score.batsmanName) \(score.runs)(\(score.balls))"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    class func sendWicketNotification(score: Score) -> () {
        let notification = UILocalNotification()
        notification.alertTitle = "Wicket!"
        notification.alertBody = "\(score.batsmanName) \(score.runs)(\(score.balls)) OUT!"
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)

    }
    
}

extension Match {
    func compareWith(oldMatch: Match) {
        //Check for new wickets
        let wickets1 = self.innings[0].wickets, wickets2 = oldMatch.innings[0].wickets
        print("\(wickets1) + \(wickets2)")
        if wickets1 > wickets2 {
            for (index, score) in self.innings[0].scores.enumerate() {
                if !oldMatch.innings[0].scores[index].out && score.out {
                    NotificationService.sendWicketNotification(score)
                    //new wicket
                }
                
                if (oldMatch.innings[0].scores[index].runs < 100 && score.runs >= 100) || (oldMatch.innings[0].scores[index].runs < 50 && score.runs >= 50) {
                    NotificationService.sendRunNotification(score)
                    //GRATS ON THE CENTURY BRAH
                }
            }
        }
    }

}