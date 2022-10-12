//
//  ParkingLots.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//

import Foundation

//Initialising fields for parking lot data https://admin.spotgenius.com/api/v2/app/search

struct ParkingLots:Codable{
    let id: Int
    let name: String
    let address: String
    let gps_coordinates: String
    let polygon: String
    let is_private: Bool
    let max_park_minutes: Int? //change this
    let is_parking_permit_feature_enabled: Bool
    let num_free_parking_spots: Int
    let num_total_parking_spots: Int
    
}

