//
//  FoundationExtensions.swift
//  Enroute21 (iOS)
//
//  Created by Markus Seidler on 27/3/21.
//

import Foundation

extension DateFormatter {
    static var short: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

extension String {
    func contains(elementIn array: [String]) -> Bool {
        array.contains(where: { self.contains($0) })
    }
}
