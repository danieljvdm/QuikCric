//
//  Persistance.swift
//  QuikCric
//
//  Created by Daniel on 1/6/16.
//  Copyright © 2016 danieljvdm. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias `Self` = PersistanceService

enum PersistanceError: ErrorType {
    case EmptyJSON
    case WriteError
    case ReadError
}

class PersistanceService {
    
    private static let filename = Self.getDocumentsDirectory().stringByAppendingPathComponent("data.txt")
    
    class func saveJSON(json: JSON) throws {
        guard let str = json.rawString() else {throw PersistanceError.EmptyJSON}
        do {
            try str.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            throw PersistanceError.WriteError
        }
    }
    
    class func retrieveSavedMatches() throws -> [Match] {
        var matches = [Match]()

        do {
            let jsonString = try String(contentsOfFile: filename)
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                let match = CurrentMatch(json: json)
                matches.append(match)
            }
            
            return matches

//            if !json["Scorecard"].isExists() {
//                print(json)
//                let match = CurrentMatch(json: json)
//                print(match)
//                matches.append(match)
//                return matches
//            } else {
//                print("test")
//                for (_, subJson):(String, JSON) in json { //if there's more than 1 match we need to use ["Scorecard"]
//                    let match = CurrentMatch(json: subJson)
//                    matches.append(match)
//                    return matches
//                }
//            }
        } catch {
            throw PersistanceError.ReadError
        }
    }
    
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}