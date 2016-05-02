//
//  ViewController.swift
//  MarcandoLaRuta
//
//  Created by Ivan Duran Martinez on 2/5/16.
//  Copyright © 2016 Ivan Duran Martinez. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapa: MKMapView!
    
    private let controladorPosicion = CLLocationManager()
    private var lastSavedPosition = CLLocation()
    var loc = CLLocation()
    var dist = CLLocationDistance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        controladorPosicion.delegate = self
        controladorPosicion.desiredAccuracy = kCLLocationAccuracyBest
        controladorPosicion.requestWhenInUseAuthorization()
        dist = 0.0
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            controladorPosicion.startUpdatingLocation()
            mapa.showsUserLocation = true
        }
        else{
            controladorPosicion.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        mapa.centerCoordinate = mapa.userLocation.coordinate
        print (manager.location!.horizontalAccuracy)
        if loc.coordinate.latitude == 0.0{
            zoomIn(manager.location!)
            loc = manager.location!
        }else if loc.distanceFromLocation(manager.location!) > 50{
            dist += loc.distanceFromLocation(manager.location!)
            updatePositions(manager)
        }
    }
    
    func updatePositions(manager: CLLocationManager){
        loc = manager.location!
        let anottation = MKPointAnnotation()
        anottation.coordinate = loc.coordinate
        anottation.title = "Long: \(manager.location!.coordinate.longitude) - Lat: \(manager.location!.coordinate.latitude)"
        anottation.subtitle = "Distancia: \(round(dist))"
        mapa.addAnnotation(anottation)
    }
    
    
    func zoomIn(location : CLLocation) {
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        
        mapa.setRegion(region, animated: true)
    }
    
    @IBAction func modoMapa() {
        mapa.mapType = .Standard
    }
    @IBAction func modoSatelite() {
        mapa.mapType = .Satellite
    }
    @IBAction func modoHibrido() {
        mapa.mapType = .Hybrid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

