//
//  CarPlayMapView.swift
//  spotgenius-carplay
//
//  Created by Jacob Curtis on 09/08/2022.
//

import UIKit
import CarPlay
import MapKit
import SwiftUI
import Flutter


class CarPlayMapView: UIViewController, CPMapTemplateDelegate, CLLocationManagerDelegate {

    var mapView: MKMapView?
    var locationManager = CLLocationManager()
    
      @objc func showFlutter() {
          print("showFlutter");
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    
              print("showFlutter after");
        present(flutterViewController, animated: false, completion: nil)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Loading the CarPlay mapview")
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()

        //AES REGION
        let region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 41.7256,
                                          longitude: -87.9458),
           latitudinalMeters: 400,
           longitudinalMeters: 400)

        //IEC REGION
        //let region = MKCoordinateRegion(
           //center: CLLocationCoordinate2D(latitude: 41.906029286,
                                          //longitude: -88.057295423),
           //latitudinalMeters: 400,
           //longitudinalMeters: 400)
        
        

        self.mapView = MKMapView(frame: view.bounds)
        self.mapView!.setRegion(region, animated: true)
        self.mapView!.showsUserLocation = true
        self.mapView!.setUserTrackingMode(.follow, animated: true)
        self.mapView!.overrideUserInterfaceStyle = .light

        self.mapView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView!)

        self.mapView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.mapView!.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.mapView!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        //Annotation functions
        
        addAnnotations()
        
        showFlutter()
        print("showflutter is loaded")
        
    }
    
    // Function parses GeoJson data from json file to MapKit polygons and returns list of these polygons
    func parseGeoJSONOriginal() -> [MKOverlay] {
        guard let url = Bundle.main.url(forResource: "aes", withExtension: "json") else {
            fatalError("Unable to get GeoJSON")
        }
        var geoJson = [MKGeoJSONObject]()
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("Unable to decode GeoJSON.")
        }
        var overlays = [MKOverlay]()
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {
                        overlays.append(polygon)
                    }
                }
            }
        }
        return overlays
    }
    
    
    // Function that parses Json data from SpotGenius api and prints to console
    func parseJSONPrint() {
        //guard let url = Bundle.main.url(forResource: "aes", withExtension: "json") else {
        guard let url = URL(string:"https://dev.spotgenius.com/api/v2/app/search") else {
        fatalError("Unable to get GeoJSON")
        }
        let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                if let data = data, let string = String(data: data, encoding: .utf8){
                    print(string)
                }
            }

        task.resume()
    }
    
    //Function that parses Json data from SpotGenius api and returns list of parking lots
    func parseJSON()-> [ParkingLots]{
        
        let lotList: [ParkingLots] = []
        //guard let url = Bundle.main.url(forResource: "aes", withExtension: "json") else {
        guard let url = URL(string:"https://admin.spotgenius.com/api/v2/app/search") else {
        fatalError("Unable to get JSON")
        }
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            
            let decoder = JSONDecoder()

            if let data = data{
                do{
                    let tasks = try decoder.decode([ParkingLots].self, from: data)
                    tasks.forEach{ i in
                        print(i.name)
                        print(type(of: i.name))
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
        //print("Here")
        //print(lotList)
        return lotList

    }
    
    /*
    func parseJSON() {
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
                        
                        //print(i)
                        //return (i)
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }
*/
    /*
    func parseJSONParkingLot() {
        guard let url = URL(string:"https://dev.spotgenius.com/api/v2/app/parking_lots") else {
        fatalError("Unable to get GeoJSON")
        }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                let decoder = JSONDecoder()

                if let data = data{
                    do{
                        let tasks = try decoder.decode([ParkingLots].self, from: data)
                    }
                }
            }
            task.resume()
    }

    func parseGeoJSON() {
        //guard let url = Bundle.main.url(forResource: "aes", withExtension: "json") else {
        guard let url = URL(string:"https://dev.spotgenius.com/api/v2/app/parking_lots") else {
        fatalError("Unable to get GeoJSON")
        }
            let task = URLSession.shared.dataTask(with: url){
                data, response, error in
                
                let decoder = JSONDecoder()

                if let data = data{
                    do{
                        let tasks = try decoder.decode([Post].self, from: data)
                        tasks.forEach{ i in
                            print(i.title)
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            task.resume()
    }
    */
    
    //Function that runs addOverlays function to each polygon object (spot) in parking lot json file
    func addAnnotations() {
        mapView?.delegate = self
        

        //parseJSON()
        mapView?.addOverlays(self.parseGeoJSONOriginal())
    }
    
    
    func mapTemplateDidBeginPanGesture(_ mapTemplate: CPMapTemplate) {
        print("Panning")
    }
    
    func mapTemplate(_ mapTemplate: CPMapTemplate, panWith direction: CPMapTemplate.PanDirection) {
        print("Panning: \(direction)")
    }
}

extension CarPlayMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "ic_place")
            // Displays the information of the annotation
            annotationView.canShowCallout = true
            // Add button for the annotation
            //annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
    // This function is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.fillColor = UIColor.green
            renderer.strokeColor=UIColor.black
            
            renderer.lineWidth=0.2
            return renderer
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.green.withAlphaComponent(0.9)

            return renderer
        }
        return MKOverlayRenderer()
    }
    
}

