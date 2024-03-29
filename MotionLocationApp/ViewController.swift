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
    
    let motionManager: CMMotionManager = CMMotionManager()
    let locationManager: CLLocationManager = CLLocationManager()
    var here: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicador: UILabel!
    
    //Regioes
    let regiaoFCICoordinate = CLLocation(latitude: -23.5473474351900, longitude: -46.651433911300)
    let regiaoStarbucksCoordinate = CLLocation(latitude: -23.5468286695178, longitude: -46.6520971712159)
    
    //Parametros
    var yawData: Double = 0
    
    //Variaves de teste
//    @IBOutlet weak var latitude: UILabel!
//    @IBOutlet weak var longitude: UILabel!
//    @IBOutlet weak var roll: UILabel!
//    @IBOutlet weak var pitch: UILabel!
//    @IBOutlet weak var yaw: UILabel!
    
    
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
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.main, withHandler: {
                (deviceMotionData, error) in
                if error != nil {
                }else{
                    if let data = deviceMotionData {
//                        self.roll.text = "roll: \(data.attitude.roll * 180 / M_PI) degrees"
//                        self.pitch.text = "pitch: \(data.attitude.pitch * 180 / M_PI) degrees"
//                        self.yaw.text = "yaw: \(data.attitude.yaw * 180 / Double.pi) degrees"
                        self.yawData = data.attitude.yaw * 180 / Double.pi
                        

                        
                        //Verificar se o usuario se encontra em alguma das regioes
                        if self.here.distance(from: self.regiaoFCICoordinate) < 20 {
                            
                            if (self.yawData > -45.0 && self.yawData < 45.0) {
                                self.indicador.text = "Você está olhando para o MackGraphe"
                            }
                            else if((self.yawData < -135.0 && self.yawData > -180.0) || (self.yawData < 180.0 && self.yawData > 135.0)){
                                self.indicador.text = "Você está olhando para a FCI"
                            }
                            else {
                                self.view.backgroundColor = UIColor.white
                                self.indicador.text = "Olá!"
                            }
                            
                        }
                        
                        if self.here.distance(from: self.regiaoStarbucksCoordinate) < 20 {
                            
                            if (self.yawData > -45.0 && self.yawData < 45.0) {
                                self.indicador.text = "Você está olhando para a praça de alimentação"
                            }
                            else if((self.yawData < -135.0 && self.yawData > -180.0) || (self.yawData < 180.0 && self.yawData > 135.0)){
                                self.indicador.text = "Você está olhando para o Starbucks"
                            }
                            else {
                                self.view.backgroundColor = UIColor.white
                                self.indicador.text = "Olá!"
                            }
                            
                        }
                        
                    }
                }
            })
        }
        
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
        
        
//        latitude.text = ("Latitude: \(here.coordinate.latitude)")
//        longitude.text = ("Longitude: \(here.coordinate.longitude)")
        
        //Adicionar regioes
        let regiaoFCI = MKCoordinateRegionMakeWithDistance(regiaoFCICoordinate.coordinate, 20, 20)
        let circleRegiaoFCI = MKCircle(center: regiaoFCI.center, radius: 20)
        mapView.add(circleRegiaoFCI)
        
        let regiaoStarbucks = MKCoordinateRegionMakeWithDistance(regiaoStarbucksCoordinate.coordinate, 20, 20)
        let circleRegiaoStarbucks = MKCircle(center: regiaoStarbucks.center, radius: 20)
        mapView.add(circleRegiaoStarbucks)
        
        //Adicionar Pins
        let pinFCI = MKPointAnnotation()
        pinFCI.title = "FCI"
        pinFCI.coordinate = regiaoFCICoordinate.coordinate
        mapView.addAnnotation(pinFCI)
        
        let pinStarbucks = MKPointAnnotation()
        pinStarbucks.title = "Praça"
        pinStarbucks.coordinate = regiaoStarbucksCoordinate.coordinate
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

