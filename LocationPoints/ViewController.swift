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
    var screenPoints : [CGPoint] = [CGPoint]()
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
  
    @IBAction func longEr(_ sender: UILongPressGestureRecognizer)
    {
        self.mapMapKit.removeAnnotations(mapMapKit.annotations)
        self.removePolygon()
        self.removePolyLine()
        
        let overlays = mapMapKit.overlays
        mapMapKit.removeOverlays(overlays)
        locArray2D.removeAll()
        
       
              
        
    
    }
    func centerMapView() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan.init(latitudeDelta: 2.0, longitudeDelta: 2.0)
            let region = MKCoordinateRegion.init(center: location, span: span)
            mapMapKit.setRegion(region, animated: true)
            currentUserLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
        }
    }
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer)
    {
     let touchPoint = sender.location(in: mapMapKit)
        screenPoints.append(touchPoint)
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
        
        
//              let distance = "\(Int(distance 100)) Kms"
//           annotation.title = "\(distance)"
        
        
        
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
        let location1: CLLocation = CLLocation(latitude: locArray2D[0].latitude, longitude: locArray2D[0].longitude)
        let location2: CLLocation = CLLocation(latitude: locArray2D[1].latitude, longitude: locArray2D[1].longitude)
        let location3: CLLocation = CLLocation(latitude: locArray2D[2].latitude, longitude: locArray2D[2].longitude)
        let location4: CLLocation = CLLocation(latitude: locArray2D[3].latitude, longitude: locArray2D[3].longitude)
        let location5: CLLocation = CLLocation(latitude: locArray2D[4].latitude, longitude: locArray2D[4].longitude)
          // let location6: CLLocation = CLLocation(latitude: points[5].latitude, longitude: points[5].longitude)
           
          let distance1 = location1.distance(from: location2)
          let distance2 = location2.distance(from: location3)
          let distance3 = location1.distance(from: location3)
          let distance4 = location1.distance(from: location4)
          let distance5 = location1.distance(from: location5)
          
           
           
          let label1: UILabel = UILabel(frame: CGRect(x: (screenPoints[0].x + screenPoints[1].x - 80) / 2, y: (screenPoints[0].y + screenPoints[1].y) / 2, width: 120, height: 30))
          label1.text = "\(Int(distance1/1000)) km"
          self.mapMapKit.addSubview(label1)
           
          let label2: UILabel = UILabel(frame: CGRect(x: (screenPoints[1].x + screenPoints[2].x - 80) / 2, y: (screenPoints[1].y + screenPoints[2].y) / 2, width: 120, height: 30))
          label2.text = "\(Int(distance2/1000)) km"
          self.mapMapKit.addSubview(label2)
           
          let label3: UILabel = UILabel(frame: CGRect(x: (screenPoints[2].x + screenPoints[3].x - 80) / 2, y: (screenPoints[2].y + screenPoints[3].y) / 2, width: 120, height: 30))
          label3.text = "\(Int(distance3/1000)) km"
          self.mapMapKit.addSubview(label3)
          
          let label4: UILabel = UILabel(frame: CGRect(x: (screenPoints[3].x + screenPoints[4].x - 80) / 2, y: (screenPoints[3].y + screenPoints[4].y) / 2, width: 120, height: 30))
            label4.text = "\(Int(distance4/1000)) km"
            self.mapMapKit.addSubview(label4)
          
          let label5: UILabel = UILabel(frame: CGRect(x: (screenPoints[4].x + screenPoints[0].x - 80) / 2, y: (screenPoints[4].y + screenPoints[0].y) / 2, width: 120, height: 30))
            label5.text = "\(Int(distance5/1000)) km"
            self.mapMapKit.addSubview(label5)
        
        //let label6: UILabel = UILabel(frame: CGRect(x: (screenPoints[4].x + screenPoints[0].x - 80) / 2, y: (screenPoints[4].y + screenPoints[0].y) / 2, width: 120, height: 30))
                  
        let distance = "\(Int(distance1+distance2+distance3+distance4+distance5)/1000) Kms"
        lblDistance.text = "\(distance)"
        
       // let distance = "\(Int(distance1+distance2+distance3+distance4+distance5)/100) Kms"
        //lblDistance.text = "\(distance)"
                      
     }
    public func addPolyLine()
    {
     mapMapKit.delegate=self
       let polyline = MKPolyline(coordinates: &locArray2D, count: locArray2D.count)
        mapMapKit.addOverlay(polyline)
     }
    public func removePolygon()
    {
        mapMapKit.delegate=self
        let polygon = MKPolygon(coordinates: &locArray2D, count: locArray2D.count)
        mapMapKit.removeOverlay(polygon)
    }
    public func removePolyLine()
    {
        mapMapKit.delegate=self
        let polyline = MKPolyline(coordinates: &locArray2D, count: locArray2D.count)
        mapMapKit.removeOverlay(polyline)
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let overlays = mapMapKit.overlays
        mapMapKit.removeOverlays(overlays)
        locArray2D.removeAll()
        mapMapKit.removeAnnotation(view.annotation!)
//    removePolygon()
//    removePolyLine()
        
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
    

    




