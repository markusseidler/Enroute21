//
//  AirportInfo.swift
//  Enroute21 (iOS)
//
//  Created by Markus Seidler on 29/3/21.
//

import Foundation

// json decoded directly from what comes back from FlightAware's "AirportInfo?"

struct AirportInfo {
    
    // Example Data
    //    "{\"AirportInfoResult\":{\"name\":\"Shanghai Pudong Int\'l\",\"location\":\"Shanghai\",\"longitude\":121.792367,\"latitude\":31.142797,\"timezone\":\":Asia/Shanghai\"}}\n", "AirportInfo?airportCode=KPSP"
    
    var icao: String?
    var friendlyName: String { }
    var id: String { icao ?? name }
    
    private(set) var latitude: String
    private(set) var longitude: String
    private(set) var location: String
    private(set) var name: String
    private(set) var timezone: String
    
    static func friendlyName(name: String, location: String) -> String {
        
        // name is Shanghai Pudong Int'l, location is Shanghai
        var shortName = name
            .replacingOccurrences(of: " Intl", with: " ")
            .replacingOccurrences(of: " Int'l", with: " ")
            .replacingOccurrences(of: "Intl ", with: " ")
            .replacingOccurrences(of: "Int'l ", with: " ")
        
        // shortName is Shanghai Pudong
        
        for nameComponent in location.components(separatedBy: ",").map({ $0.trim }) {
            shortName = shortName
                .replacingOccurrences(of: nameComponent+" ", with: " ")
                .replacingOccurrences(of: " "+nameComponent, with: " ")
        }
        
        // shortName is Pudong
        
        shortName = shortName.components(separatedBy: CharacterSet.whitespaces).joined(separator: " ")
        if !shortName.isEmpty {
            return "\(shortName), \(location)"
        } else {
            return location
        }
        
    }
}
