//
//  APIService.swift
//  QuikCric
//
//  Created by Daniel on 12/28/15.
//  Copyright © 2015 danieljvdm. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum QueryType: CustomStringConvertible {
    case PastMatches
    case LiveMatches
    case Scorecard(matchID: Int)
    
    var description: String {
        switch self {
        case .PastMatches:
            return "select * from cricket.past_matches"
        case .LiveMatches:
            return "select * from cricket.scorecard.live"
        case let Scorecard(matchID):
            return "select * from cricket.scorecard where match_id=" + String(matchID)
        }
    }
}

class APIService {
    static let prefix = "http://query.yahooapis.com/v1/public/yql?q="
    static let suffix = "&format=json&diagnostics=true&env=store%3A%2F%2F0TxIGQMQbObzvU4Apia0V0&callback="

    class func query(statement: QueryType, completion: (matches: [Match]) -> Void) {
        
        let query = prefix + statement.description.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())! + suffix
        var matches = [Match]()
        
        Alamofire.request(.GET, query)
            .responseJSON { response in
                if let value = response.result.value {
                    var json = JSON(value)["query"]["results"]
                    print(json.stringValue)
                    if json["Scorecard"].isExists() {
                        json = json["Scorecard"]
                        let match = CurrentMatch(json: json)
                        matches.append(match)
                    } else {
                        for (_, subJson):(String, JSON) in json { //if there's more than 1 match we need to use ["Scorecard"]
                            let match = CurrentMatch(json: subJson)
                            matches.append(match)
                        }
                    }
                    
                    completion(matches: matches)
                }
        }
    }
}