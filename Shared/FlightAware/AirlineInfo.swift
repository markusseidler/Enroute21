//
//  AirlineInfo.swift
//  Enroute21 (iOS)
//
//  Created by Markus Seidler on 27/3/21.
//

import Foundation

// json decoded directly from what comes back from FlightAware's "AirlineInfo?"

struct AirlineInfo: Codable, Hashable, Identifiable, Comparable {
    
// Example Data
// "AirlineInfo?airlineCode=KAL": "{\"AirlineInfoResult\":{\"name\":\"Korean Air Lines Co., Ltd.\",\"shortname\":\"Korean Air Lines Co.\",\"callsign\":\"Koreanair\",\"location\":\"Republic Of Korea\",\"country\":\"South Korea\",\"url\":\"http://www.koreanair.com/\",\"phone\":\"+1-800-438-5000\"}}\n"
    
    var code: String?
    
    var friendlyName: String { shortname.isEmpty ? (name.isEmpty ? (code ?? ""): name) : shortname }
    var id: String { code ?? callsign }
    
    private(set) var callsign: String
    private(set) var country: String
    private(set) var location: String
    private(set) var name: String
    private(set) var phone: String
    private(set) var shortname: String
    private(set) var url: String
    
    // hashable and equatable functions are not needed any more. However, I add them here for clarity.
    // for hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // for equatable which is part of hashable
    static func == (lhs: AirlineInfo, rhs: AirlineInfo) -> Bool {
        Bool(lhs.id == rhs.id)
    }
    
     
    // for comparable
    static func < (lhs: AirlineInfo, rhs: AirlineInfo) -> Bool {
        Bool(lhs.id < rhs.id)
    }
    
}
