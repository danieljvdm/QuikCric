//
//  DetailInterfaceController.swift
//  QuikCric
//
//  Created by Daniel on 1/2/16.
//  Copyright © 2016 danieljvdm. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {

    @IBOutlet var team: WKInterfaceLabel!
    @IBOutlet var score: WKInterfaceLabel!
    @IBOutlet var matchName: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
        
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let match = context as! Match

        self.setTitle(match.prettyName)
        setupTable(match)
    }
    
    func setupTable(match: Match) {
        guard let currentInnings = match.innings.first else {
            return
        }
        table.setNumberOfRows(currentInnings.scores.count, withRowType: "DetailRow")
        for var i = 0; i < currentInnings.scores.count; ++i {
            if let row = table.rowControllerAtIndex(i) as? DetailRow {
                let score = currentInnings.scores[i]
                for player in match.players {
                    if player.id == score.batsmanId {
                        row.batsman.setText(player.lastName)
                    }
                }
                row.score.setText("\(score.runs) (\(score.balls))")
                if score.out {
                    row.separator.setColor(UIColor.redColor())
                } else {
                    row.separator.setColor(UIColor.greenColor())
                }
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
