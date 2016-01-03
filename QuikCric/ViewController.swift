//
//  ViewController.swift
//  QuikCric
//
//  Created by Daniel on 12/28/15.
//  Copyright © 2015 danieljvdm. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    let letters = "acdegilmnoprstuw"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIService.query(QueryType.LiveMatches){
            (matches: [Match]) in
            for case let match as CurrentMatch in matches {
                print(match.name)
                for inning in match.innings {
                    print(inning.score)
                }
                //print(match.name)
                //print(match.innings)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}