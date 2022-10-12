//
//  LotDataManager.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//


//Unfinished file

import Foundation

class DataManager {
    
    // MARK: - Properties
    static let shared = DataManager()
    var favoriteLots = [ParkingLots]()

    // MARK: - Functions

    func getLots()-> [ParkingLots]{
        
        var lotList: [ParkingLots] = []
        //guard let url = Bundle.main.url(forResource: "aes", withExtension: "json") else {
        guard let url = URL(string:"https://admin.spotgenius.com/api/v2/app/search") else {
        fatalError("Unable to get GeoJSON")
        }
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([ParkingLots].self, from: data)
                    tasks.forEach{ i in
                        print(type(of: i))
                        lotList.append(i)
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
        //print(lotList)
        return lotList

    }
    
    /*
    func updateFavoriteLots(lot: ParkingLots) {
        if favoriteLots.contains(where: {$0.uid == lot.uid}) {
            favoriteLots.removeAll(where: {$0.uid == lot.uid})
        } else {
            favoriteLots.append(lot)
        }
    }*/
}
