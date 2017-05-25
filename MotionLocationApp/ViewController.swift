//
//  ViewController.swift
//  MotionLocationApp
//
//  Created by Heitor Ishihara on 24/05/17.
//  Copyright © 2017 Heitor Ishihara. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager: CLLocationManager = CLLocationManager()
    var here: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Variaves de teste
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pedir permissao
        locationManager.requestWhenInUseAuthorization()
        
        //Popup de permissao
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            
            //Configurar precisao
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        //Adicionar regioes
//        let regiao31 = MKCircle(center: here., radius: 50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.location!.distance(from: here) > 2{
            here = manager.location!
            centerMap(location: here)
        }
        
    
        latitude.text = ("Latitude: \(here.coordinate.latitude)")
        longitude.text = ("Longitude: \(here.coordinate.longitude)")
        
    }
    
    func centerMap(location: CLLocation){
        //Centraliza o mapa
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100)
        mapView.setRegion(region, animated: true)
    }


}

