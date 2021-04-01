//
//  FlightAwareRequest.swift
//  Enroute21 (iOS)
//
//  Created by Markus Seidler on 30/3/21.
//

import Foundation
import Combine

// very simple scheduled, sequential fetcher of FlightAware data
// using the FlightAware REST API
// just enough to support our demo needs
// has some simple cacheing to make starting/stopping in demo all the time
//  so that it does not overwhelm with FlightAware requests
//  (also, FlightAware requests are not free!)
// also has a simple "simulation mode"
// so that it will "work" when no valid FlightAware credentials exist

// to make this actually fetch from FlightAware
// you need a FlightAware account and an API key
// (fetches are not free, see flightaware.com/api for details)
// put your account name and API key in the Info.plist
// under the key "FlightAware Credentials"
// example credentials: "joepilot:2ab78c93fccc11f999999111030304"
// if that key does not exist, simulation mode automatically kicks in

class FlightAwareRequest<Fetched> where Fetched: Codable, Fetched: Hashable {
    // this is the latest accumulation of results from fetches
    // this is a CurrentValueSubject
    // a CurrentValueSubject is a Publisher that holds a value
    // and publishes it whenever it changes
    
    var fetchTimer: Timer? // so that subclasses can throttle fetches of their kind of object
    var query: String { "" } // e.g. Enroute?airport=KSFO
    var offset: Int = 0
    
    private(set) var results = CurrentValueSubject<Set<Fetched>, Never>([])
    private(set) var fetchInterval: TimeInterval = 0

    
    // need to add variables here as they come...
    
    func decode(_ json: Data) -> Set<Fetched> { Set<Fetched>() } // json is JSON received from FlightAware
    // some functions are missing... need to figure out why they are needed
    
    // MARK: - Private Data
    
    private var fetchCancellable: AnyCancellable?
    private var fetchSequenceCount: Int = 0
    private var urlRequest: URLRequest? { Self.authorizedURLRequest(query: query) }
    
    // MARK: - Fetching
    
    // sets the fetchInterval to interval and starts fetchAction (renamed from fetch())
    func fetch(andRepeatEvery interval: TimeInterval, useCache: Bool? = nil) {
        fetchInterval = interval
        if useCache != nil {
            fetchAction(useCache: useCache!)
        } else {
            fetchAction()
        }
    }
    
    func stopFetching() {
        fetchCancellable?.cancel()
        fetchTimer?.invalidate()
        fetchInterval = 0
        fetchSequenceCount = 0
    }
    
    // immediately fetches new data (from cache if available and requested)
    // and, when that data returns, calls handleResults with it
    // (which will schedule the next fetch if appropriate)
    
    func fetchAction(useCache: Bool = true) {
        
        if !useCache || !fetchFromCache() {
            if let urlRequest = self.urlRequest {
                print("fetching \(urlRequest)")
                
                if offset == 0 {
                    fetchSequenceCount = 0
                }
                
                
                //type issue??
                fetchCancellable = URLSession.shared.dataTaskPublisher(for: urlRequest).map {
                    [weak self] data, response in
                    return self?.decode(data) ?? []
                }
                
                
                
//                fetchCancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
//                    .map { [weak self] data, response in
//                        return self?.decode(data) ?? []
//                    }
                
            }
        }
        
    }
    
    private func fetchFromCache() -> Bool {
        
    }
    
    // MARK: - Utility
    
    static func authorizedURLRequest(query: String, credentials: String? = Bundle.main.object(forInfoDictionaryKey: "FlightAware Credentials") as? String) -> URLRequest {
        
    }
    
    
    
    
    
    
}
