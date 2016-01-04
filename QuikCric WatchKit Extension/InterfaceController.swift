//
//  InterfaceController.swift
//  QuikCric WatchKit Extension
//
//  Created by Daniel on 12/28/15.
//  Copyright © 2015 danieljvdm. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    var matches = [Match]()
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    func setupTable() {
        tableView.setNumberOfRows(matches.count, withRowType: "MatchRow")
        for var i = 0; i < matches.count; ++i {
            if let row = tableView.rowControllerAtIndex(i) as? MatchRow {
                let match = matches[i]
                row.matchName.setText(match.prettyNameWithFlag)
                row.currentScore.setText(match.innings.first?.score)
                row.lead.setText(match.innings.first?.relativeScore)
            }
        }
    }
    
    func loadData() {
        APIService.query(QueryType.LiveMatches){
            (matches: [Match]) in
            self.matches = matches
            self.setupTable()
        }
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        loadData()
        // Configure interface objects here.
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        self.pushControllerWithName("showDetails", context: matches[rowIndex])
    }
    
    @IBAction func refresh() {
        loadData()
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
