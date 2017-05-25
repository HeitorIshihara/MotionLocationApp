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
    
    //Regioes
    let regiaoFCICoordinate = CLLocationCoordinate2D(latitude: -23.5473474351900, longitude: -46.651433911300)
    let regiaoStarbucksCoordinate = CLLocationCoordinate2D(latitude: -23.5468286695178, longitude: -46.6520971712159)
    
    
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
        
        mapView.delegate = self
        
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
        
        //Adicionar regioes
        let regiaoFCI = MKCoordinateRegionMakeWithDistance(regiaoFCICoordinate, 20, 20)
        let circleRegiaoFCI = MKCircle(center: regiaoFCI.center, radius: 20)
        mapView.add(circleRegiaoFCI)
        
        let regiaoStarbucks = MKCoordinateRegionMakeWithDistance(regiaoStarbucksCoordinate, 20, 20)
        let circleRegiaoStarbucks = MKCircle(center: regiaoStarbucks.center, radius: 20)
        mapView.add(circleRegiaoStarbucks)
        
        //Adicionar Pins
        let pinFCI = MKPointAnnotation()
        pinFCI.title = "FCI"
        pinFCI.coordinate = regiaoFCICoordinate
        mapView.addAnnotation(pinFCI)
        
        let pinStarbucks = MKPointAnnotation()
        pinStarbucks.title = "Praça"
        pinStarbucks.coordinate = regiaoStarbucksCoordinate
        mapView.addAnnotation(pinStarbucks)
        
    }
    
    func centerMap(location: CLLocation){
        //Centraliza o mapa
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = overlay as? MKCircle //O ? verifica se o overlay é um circulo antes de fazer o cast
        let overlayRenderer = MKCircleRenderer(overlay: overlay!)
        overlayRenderer.fillColor = UIColor(colorLiteralRed: 1.0, green: 0.0, blue: 0.0, alpha: 0.03) //Cor do circulo
        overlayRenderer.strokeColor = UIColor.red //Linha do circulo
        overlayRenderer.lineWidth = 1 //Largura da Linha
        return overlayRenderer
    }


}

