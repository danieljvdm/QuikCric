//
//  Persistance.swift
//  QuikCric
//
//  Created by Daniel on 1/6/16.
//  Copyright © 2016 danieljvdm. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PersistanceError: ErrorType {
    case EmptyJSON
    case WriteError
    case ReadError
}

class Persistance {
    
    private static let filename = Persistance.getDocumentsDirectory().stringByAppendingPathComponent("data.txt")
    
    class func saveJSON(json: JSON) throws {
        guard let str = json.rawString() else {throw PersistanceError.EmptyJSON}
        do {
            try str.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            throw PersistanceError.WriteError
        }
    }
    
    class func retrieveJSON() throws -> JSON {
        do {
            let jsonString = try String(contentsOfFile: filename)
            return JSON(jsonString)
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