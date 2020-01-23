//
//  ViewController.swift
//  LocationPoints
//
//  Created by MacStudent on 2020-01-22.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locArray : [CLLocation] = []
    var locArray2D : [CLLocationCoordinate2D] = []
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var mapMapKit: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentUserLocation: CLLocation!
    var mapOverlay: MKOverlay!
    override func viewDidLoad() {
        super.viewDidLoad()
       checkLocationServices()
        
    }
    
    func checkLocationServices()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            setupLocationManager()
            checkLocationAuth()
        }
        else
        {
            let alertV = UIAlertController(title: "Error", message: "Location services is unavaible", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel , handler: nil)
            alertV.addAction(action)
            self.present(alertV, animated: true, completion: nil)
        }
    }
    func setupLocationManager() {
        locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Magic Words
        //******************
           mapMapKit.showsUserLocation = false
        //*******************
       }
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            centerMapView()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            fatalError()
        }
    }
    func centerMapView() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapMapKit.setRegion(region, animated: true)
            currentUserLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
     let touchPoint = sender.location(in: mapMapKit)
      let coordinate = mapMapKit.convert(touchPoint, toCoordinateFrom: mapMapKit)
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      mapMapKit.removeAnnotation(annotation)
        if mapMapKit.annotations.count < 5
      {
      let touchPoint = sender.location(in: mapMapKit)
        let coordinate = mapMapKit.convert(touchPoint, toCoordinateFrom: mapMapKit)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        locArray.append(location)
      let location2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
         let destinationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
              let distance = "\(Int(((currentUserLocation?.distance(from: destinationLocation))!))/100) Kms"
            annotation.title = "\(distance)"
        
        
        
      locArray2D.append(location2D)
      mapMapKit.addAnnotation(annotation)
      }
      if mapMapKit.annotations.count <= 4
      {
        
        addPolyLine()
      }
        else if(mapMapKit.annotations.count == 5)
      {
        addPolygon()
        }
     
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if overlay is MKPolygon
         {
             let renderer = MKPolygonRenderer(overlay: overlay)
             renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
             renderer.strokeColor = UIColor.brown
             renderer.lineWidth = 4
             return renderer
            }
         else if overlay is MKPolyline
         {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
            }
           return MKOverlayRenderer()
     
    }
    public func addPolygon()
    {
     mapMapKit.delegate=self
       let polygon = MKPolygon(coordinates: &locArray2D, count: locArray2D.count)
        mapMapKit.addOverlay(polygon)
     }
    public func addPolyLine()
    {
     mapMapKit.delegate=self
       let polyline = MKPolyline(coordinates: &locArray2D, count: locArray2D.count)
        mapMapKit.addOverlay(polyline)
     }

        
    }
//    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer)
//    {
//        let overlays = mapMapKit.overlays
//        mapMapKit.removeOverlays(overlays)
//        let pinLocation = sender.location(in: self.mapMapKit)
//        let pinCoord = self.mapMapKit.convert(pinLocation, toCoordinateFrom: self.mapMapKit)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = pinCoord
//        //annotation.title = "\(distance)"
//
//       // self.mapMapKit.removeAnnotations(mapMapKit.annotations)
//        self.mapMapKit.addAnnotation(annotation)
//
//        let destinationLocation = CLLocation(latitude: pinCoord.latitude, longitude: pinCoord.longitude)
//
//        let distance = "\(Int(((currentUserLocation?.distance(from: destinationLocation))!))/100) Kms"
//        annotation.title = "\(distance)"
//        lblDistance.text! = distance
//        drawRoute(to: destinationLocation)
//
//    }
    
//    func drawRoute(to destination: CLLocation) {
//        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil)
//        let directionRequest = MKDirections.Request()
//        directionRequest.source = MKMapItem.forCurrentLocation()
//        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
//        directionRequest.transportType = .automobile
//        let direction = MKDirections(request: directionRequest)
//
//        direction.calculate { (response, error)->Void in
//            guard let response = response else {
//                if let error = error {
//                        print("Error: \(error)")
//                    }
//                return
//            }
//
//            let route = response.routes[0]
//            //let path = GMSMutablePath()
//            self.mapMapKit.addOverlay((route.polyline),level: MKOverlayLevel.aboveRoads)
//        }
//    }
    

    




