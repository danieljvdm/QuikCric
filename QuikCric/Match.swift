//
//  Match.swift
//  QuikCric
//
//  Created by Daniel on 12/29/15.
//  Copyright © 2015 danieljvdm. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Match: AnyObject {
    var id: Int {get}
    var seriesName: String {get}
    var name: String {get}
    var status: String {get}
    var innings: [Innings] {get}
    var teams: [Team] {get}
    var prettyName: String {get}
    var prettyNameWithFlag: String {get}
    var players: [Player] {get}
}

extension Match {
    var prettyNameWithFlag: String {
        let team1 = teams[0]
        let team2 = teams[1]
        return "\(team1.flag) \(team1.shortName) v \(team2.shortName) \(team2.flag)"
    }
    
    var prettyName: String {
        let team1 = teams[0]
        let team2 = teams[1]
        return "\(team1.shortName) v \(team2.shortName)"
    }
    
    var players: [Player] {
        let squad1 = teams[0].squad
        let squad2 = teams[1].squad
        let test = squad1 + squad2
        return test
    }
    
    func compareWith(oldMatch: Match) {
        //Check for new wickets
        let wickets1 = self.innings[0].wickets, wickets2 = oldMatch.innings[0].wickets
        if wickets1 > wickets2 {
            for (index, score) in self.innings[0].scores.enumerate() {
                if !oldMatch.innings[0].scores[index].out && score.out {
                    NotificationService.sendWicketNotification(score)
                    //new wicket
                }
                
                if oldMatch.innings[0].scores[index].runs < 100 && score.runs >= 100 {
                    NotificationService.sendRunNotification(score)
                    //GRATS ON THE CENTURY BRAH
                }
            }
        }
    }
}




class CurrentMatch : Match {
    let id: Int
    let seriesName: String
    let name: String
    let status: String
    var innings = [Innings]()
    var teams = [Team]()
    
    init(json: JSON){
        id = json["mid"].intValue
        seriesName = json["series"]["series_name"].stringValue
        name = json["mn"].stringValue
        status = json["ms"].stringValue
        for (_, subJson) in json["teams"] {
            teams.append(Team(json: subJson))
        }
        if let _ = json["past_ings"].array {
            for (_, subJson) in json["past_ings"] {
                innings.append(Innings(json: subJson, teams: teams))
            }
        }
        else if let _ = json["past_ings"].dictionary {
            innings.append(Innings(json: json["past_ings"], teams: teams))
        }
    }
}

//struct PastMatch: Match {
//    
//}

struct Team {
    let id: Int
    let name: String
    let shortName: String
    var squad = [Player]()
    var flag: String {
        switch shortName {
        case "SA":
            return "🇿🇦"
        case "ENG":
            return "🇬🇬"
        case "AUS":
            return "🇦🇺"
        case "WI":
            return "🇯🇲"
        case "AFG":
            return "🇦🇫"
        case "ZIM":
            return "🇿🇼"
        default:
            return ""
        }
    }
    
    init(json: JSON){
        id = json["i"].intValue
        name = json["fn"].stringValue
        shortName = json["sn"].stringValue
        
        for(_, subJson) in json["squad"] {
            let player = Player(id: subJson["i"].intValue, name: subJson["short"].stringValue, captain: subJson["captain"].boolValue, viceCaptain: subJson["vicecaptain"].boolValue, wickie: subJson["keeper"].boolValue)
            squad.append(player)
        }
    }
}

enum TeamFlag {
    case Country(String)
    
    var description: String {
        switch self {
        case .Country(let country):
            switch country {
            case "SA":
                return "🇿🇦"
            case "ENG":
                return "🇬🇬"
            case "AUS":
                return "🇦🇺"
            case "WI":
                return "🇯🇲"
            case "AFG":
                return "🇦🇫"
            case "ZIM":
                return "🇿🇼"
            default:
                return country
            }
        }
    }
}

struct Player {
    let id: Int
    let name: String
    let captain: Bool
    let viceCaptain: Bool
    let wickie: Bool
    var lastName: String {
        var fullnamearr = name.componentsSeparatedByString(" ")
        fullnamearr.removeAtIndex(0)
        return fullnamearr.reduce(""){$0 == "" ? $1 : $0 + " " + $1}
    }
}

struct Innings {
    let number: Int
    let battingTeam: Int
    var battingTeamName: String {
        switch battingTeam {
        case 1:
            return "AUS"
        case 2:
            return "2"
        case 3:
            return "ENG"
        case 4:
            return "4"
        case 5:
            return "5"
        case 6:
            return "6"
        case 7:
            return "SA"
        case 9:
            return "WI"
        case 1188:
            return "AFG"
        default:
            return String(battingTeam)
        }
    }
    let runs: Int
    let wickets: Int
    let tl: String?
    let ru: String?
    var score: String {
        return "\(battingTeamName) \(runs) for \(wickets)"
    }
    var summary: String {
        return "\(runs)/\(wickets) \(relativeScore)"
    }
    var scores = [Score]()
    var relativeScore: String {
        if number == 1 {
            return "Lead by \(runs)"
        } else {
            if let lead = tl {
                return lead
            } else if let lead = ru {
                return lead
            }
        }
        
        return ""
    }

    init(json: JSON, teams: [Team]){
        number = json["s"]["i"].intValue
        battingTeam = json["s"]["a"]["i"].intValue
        runs = json["s"]["a"]["r"].intValue
        wickets = json["s"]["a"]["w"].intValue
        ru = json["s"]["a"]["ru"].string
        tl = json["s"]["a"]["tl"].string
        
        for(_, subJson) in json["d"]["a"]["t"] {
            guard let _ = subJson["c"].string else {
                continue
            }
            scores.append(Score(json: subJson, teams: teams))
        }
    }
}

struct Score {
    let batsmanId: Int
    var batsmanName: String?
    let runs: Int
    let balls: Int
    let strikeRate: Double
    let out: Bool
    
    init(json: JSON, teams: [Team]){
        batsmanId = json["i"].intValue
        runs = json["r"].intValue
        balls = json["b"].intValue
        strikeRate = json["sr"].doubleValue
        let players = teams[0].squad + teams[1].squad
        for player in players {
            if player.id == batsmanId {
                self.batsmanName = player.lastName
                break
            }
        }
        if let _ = json["dt"].string {
            out = true
        } else {
            out = false
        }
    }
}