//
//  FAFlight.swift
//  Enroute21 (iOS)
//
//  Created by Markus Seidler on 27/3/21.
//

import Foundation

// json decoded directly from what comes back from FlightAware "Enroute?"

struct FAFlight {
    // Example Data
    //{\"ident\":\"ASA1002\",\"aircrafttype\":\"A321\",\"actualdeparturetime\":0,\"estimatedarrivaltime\":1588131360,\"filed_departuretime\":1588109400,\"origin\":\"KDCA\",\"destination\":\"KSFO\",\"originName\":\"Reagan National\",\"originCity\":\"Washington, DC\",\"destinationName\":\"San Francisco Intl\",\"destinationCity\":\"San Francisco, CA\"}
    
    
    private(set) var ident: String // ASA1002
    private(set) var aircraft: String // A321
    private(set) var destination: String // KSFO
    private(set) var destinationName: String // San Francisco Intl
    private(set) var destinationCity: String // San Francisco, CA
    private(set) var origin: String // KDCA
    private(set) var originName: String // Reagan National
    private(set) var originCity: String // Washington, DC
    
    // if ident is SKW5373
    // var number is 5373
    // var airlineCode is SKW
    var number: Int { Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0 }
    var airlineCode: String { String(ident.prefix(while: { !$0.isNumber })) }
    
    // time in dataset is in seconds since 1970
    var departure: Date? { actualdeparturetime > 0 ? Date(timeIntervalSince1970: TimeInterval(actualdeparturetime)) : nil }
    var arrival: Date { Date(timeIntervalSince1970: TimeInterval(estimatedarrivaltime)) }
    var filed: Date { Date(timeIntervalSince1970: TimeInterval(filed_departuretime)) }
    
    var id: String { ident }

    var originFullName: String {
        // KSOF -> SOF
        let origin = self.origin.first == "K" ? String(self.origin.dropFirst()) : self.origin
        
        // if the airport has the city name, then the fullName excludes the airport name
        if originName.contains(elementIn: originCity.components(separatedBy: ",")) {
            return origin + " " + originCity
        }
        
        return origin + "\(originName), \(originCity)"
    }
    
    private var actualdeparturetime: Int
    private var estimatedarrivaltime: Int
    private var filed_departuretime: Int
    
    
    
}

extension FAFlight {
    
    // enum CodingKeys to convert data name to variable name like "aircrafttype" to "aircraft"
    private enum CodingKeys: String, CodingKey {
        case ident
        case aircraft = "aircrafttype"
        case actualdeparturetime, estimatedarrivaltime, filed_departuretime
        case origin, destination
        case originName, originCity
        case destinationName, destinationCity
    }
    
    
}
