//
//  CarplaySceneDelegate.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//

import UIKit
import SwiftUI
import CarPlay

class CarplaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate, CPMapTemplateDelegate {

    private var carplayInterfaceController: CPInterfaceController?
    var carWindow: CPWindow?
    
    //var locationService: LocationService
    var mapTemplate: CPMapTemplate?
    var mapView: CarPlayMapView?
    
    //Lots
    private var lots = [ParkingLots]()
    

    //templateApplicationScene
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController, to window: CPWindow) {
        // Background of CPMapTemplate
        
        self.mapView=CarPlayMapView()
        window.rootViewController = self.mapView
        self.carWindow = window
        self.carWindow?.isUserInteractionEnabled = true
        self.carWindow?.isMultipleTouchEnabled = true
        
        if #available(iOS 14.0, *) {
            self.carplayInterfaceController?.setRootTemplate(self.mapTemplate!, animated: true, completion: {_, _ in })
        } else {
            // Fallback on earlier versions
        }
        carplayInterfaceController = interfaceController
        
        //Function to run grid menu template
        grid()
        

    }

    // Grid buttons
    private func grid() {
        let template = CPGridTemplate(title: "SpotGenius", gridButtons: [
            CPGridButton(titleVariants: ["Map"], image: UIImage(systemName: "map")!, handler: map(_:)),
            CPGridButton(titleVariants: ["Search"], image: UIImage(systemName: "magnifyingglass")!, handler: search(_:)),
            CPGridButton(titleVariants: ["Nearby Lots"], image: UIImage(systemName: "mappin.and.ellipse")!, handler: nearbyLotsList(_:)),
            CPGridButton(titleVariants: ["Favorites"], image: UIImage(systemName: "heart")!, handler: favoritesList(_:)),
            CPGridButton(titleVariants: ["Siri"], image: UIImage(systemName: "waveform.circle")!, handler: siri(_:)),
        ])

        carplayInterfaceController?.setRootTemplate(template, animated: true)
    }

    // Grid Button Templates
    
    private func map(_ button: CPGridButton) {
        let template = CPMapTemplate()
        template.mapDelegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }
    
    private func map(location:String) {
        print(location)

        let template = CPMapTemplate()
        template.mapDelegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }
    
/*
    func parseJSON()-> CPListSection{
        
        var CPLotList = [CPListItem]()
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
                        
                        
                        let item = CPListItem(text: i.name, detailText: i.address)
                        item.accessoryType = .disclosureIndicator
                        //item.setImage(UIImage(named: radio.imageSquareUrl))
                        item.handler = { [weak self] item, completion in
                            guard let strongSelf = self else { return }
                            strongSelf.favoriteAlert(lot: i, completion: completion)
                        }
                        CPLotList.append(item)
                        
                        
                    }
                }catch{
                    print(error)
                }
            
            }
        }
        task.resume()
        //print("Here")
        //print(lotList)
        return CPListSection(items: CPLotList)

    }

    func favoriteAlert(lot: ParkingLots, completion: @escaping () -> Void) {
        let template = CPAlertTemplate(titleVariants: ["This is sample alert."], actions: [
            CPAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
                print("OK")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (action) in
                print("Cancel")
                self?.carplayInterfaceController?.dismissTemplate(animated: true)
            }),
        ])
    }
*/
    private func nearbyLotsList(_ button: CPGridButton) {
        
        var CPLotList: [CPListItem] = []
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
                        
                        
                        let item = CPListItem(text: i.name, detailText: i.address)
                        item.accessoryType = .disclosureIndicator
                        //item.setImage(UIImage(named: radio.imageSquareUrl))
                        
                        //Handler
                        item.handler = { [weak self] item, completion in
                            guard let strongSelf = self else { return }
                            strongSelf.map(location: i.gps_coordinates)
                        }
                        
                        CPLotList.append(item)
                        //print(CPLotList)
                        
                    }
                }catch{
                    print(error)
                }
                
                let section = CPListSection(items:CPLotList)
                print(section)
                let template = CPListTemplate(title: "Nearby Lots", sections: [section])
                template.delegate = self
                self.carplayInterfaceController?.pushTemplate(template, animated: true)
    
            }
        }
        task.resume()
    }
    
    private func favoritesList(_ button: CPGridButton) {
        
        var CPLotList: [CPListItem] = []
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
                        
                        
                        let item = CPListItem(text: i.name, detailText: i.address)
                        item.accessoryType = .disclosureIndicator
                        //item.setImage(UIImage(named: radio.imageSquareUrl))
                        
                        //Handler
                        item.handler = { [weak self] item, completion in
                            guard let strongSelf = self else { return }
                            strongSelf.map(location: i.gps_coordinates)
                        }
                        
                        CPLotList.append(item)
                        //print(CPLotList)
                        
                    }
                }catch{
                    print(error)
                }
                
                let section = CPListSection(items:CPLotList)
                print(section)
                let template = CPListTemplate(title: "Nearby Lots", sections: [section])
                template.delegate = self
                self.carplayInterfaceController?.pushTemplate(template, animated: true)
    
            }
        }
        task.resume()
    }

    private func search(_ button: CPGridButton) {
        let template = CPSearchTemplate()
        template.delegate = self

        carplayInterfaceController?.pushTemplate(template, animated: true)
    }

    private func action(_ button: CPGridButton) {
        let template = CPActionSheetTemplate(title: "This is sample action sheet", message: nil, actions: [
            CPAlertAction(title: "OK", style: .default, handler: { (action) in
                print("OK")
            }),
            CPAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                print("Cancel")
            }),
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }


    private func siri(_ button: CPGridButton) {
        let template = CPVoiceControlTemplate(voiceControlStates: [
            CPVoiceControlState(identifier: "identifier", titleVariants: ["Test"], image: nil, repeats: true)
        ])

        carplayInterfaceController?.presentTemplate(template, animated: true)
    }

    private func setInformationTemplate() {
        let items: [CPInformationItem] = [
            CPInformationItem(title: "Template type", detail: "Information Template (CPInformationTemplate)")
        ]

        let infoTemplate = CPInformationTemplate(title: "CarPlay at CocoaHeads", layout: .leading, items: items, actions: [])
        carplayInterfaceController?.setRootTemplate(infoTemplate, animated: true, completion: { success, error in
            debugPrint("Success: \(success)")

            if let error = error {
                debugPrint("Error: \(error)")
            }
        })
    }
    
}
    

//CPTemplate delegates

extension CarplaySceneDelegate: CPSearchTemplateDelegate {

    func searchTemplate(_ searchTemplate: CPSearchTemplate, updatedSearchText searchText: String, completionHandler: @escaping ([CPListItem]) -> Void) {
        print(searchText)

        completionHandler([
            CPListItem(text: searchText, detailText: "")
        ])
    }

    func searchTemplate(_ searchTemplate: CPSearchTemplate, selectedResult item: CPListItem, completionHandler: @escaping () -> Void) {
        print(item.text)

        completionHandler()
    }

}

extension CarplaySceneDelegate: CPListTemplateDelegate {

    func listTemplate(_ listTemplate: CPListTemplate, didSelect item: CPListItem, completionHandler: @escaping () -> Void) {
        let template = CPActionSheetTemplate(title: "Title", message: "Message", actions: [CPAlertAction(title: "title", style: .default, handler: { (action) in

        })])

        carplayInterfaceController?.presentTemplate(template, animated: true)

        // Dismiss indicator
        completionHandler()
    }

}
