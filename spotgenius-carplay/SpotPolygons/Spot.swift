//
//  Spot.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//

import SwiftUI
import CoreLocation
import MapKit

// Initalising fields in "aes.json" file, that contains parking spot data

struct Spot: Identifiable, Codable {
    let id: UUID
    let polygon: String
    let current_status:String
    let is_handicap_parking: Bool
    let is_status_marked_unknown: Bool


}

