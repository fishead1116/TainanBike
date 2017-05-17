//
//  ViewController.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/3/28.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces



class MapViewController: UIViewController {
    
    @IBOutlet weak var optionSegmentedControl: UISegmentedControl!
    var pinMode : BikePinMode = .normal
    
    @IBOutlet weak var mapView: GMSMapView!
    var placesClient: GMSPlacesClient?
    
    var locationManager = CLLocationManager()
    var isCameraSetted = false
    
    var selectedMarker : GMSMarker? = nil
    var markers : [GMSMarker] = []

    var infoView = CustomInfoView(frame: CGRect(x: 0, y: 0, width: 240  , height: 155))

    //var bikes : [TBike] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadMarker()
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 22.932706,longitude: 120.330637, zoom: 15)
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.setAllGesturesEnabled(true)
        
        placesClient = GMSPlacesClient.shared()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func optionValueChanged(_ sender: Any) {
        
        if let mode = BikePinMode(rawValue: optionSegmentedControl.selectedSegmentIndex){
            self.pinMode = mode
            reloadMarker()
        }else{
            performSegue(withIdentifier: "distance", sender: self)
        }
    }
    
//    func imageForView(view : UIView) -> UIImage? {
//        
//        if(UIScreen.main.responds(to: #selector(getter: UIScreen.scale))){
//            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
//        }else{
//            UIGraphicsBeginImageContext(view.frame.size)
//        }
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let distance = segue.destination as? DistanceViewController{
            distance.myLocation = mapView.myLocation
            distance.markers = markers
        }
    }
    
    
    @IBAction func unwindToMapView(segue:UIStoryboardSegue) {
        
    }
}

extension MapViewController {
    
    func reloadMarker(){
        
        TBike.getTBikeStatus { (bikes : [TBike]) in
            
            self.mapView.clear()
            self.markers = []
            
            for bike in bikes {
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(bike.latitude, bike.longitude)
                
                let customView = CustomPinView(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
                customView.setBike(bike: bike, mode: self.pinMode)
                //customView.label.text = "\(bike.avaliableBikeCount)"
                marker.iconView = customView
                
                marker.map = self.mapView
                self.markers.append(marker)
            
            }
            
            self.mapView.reloadInputViews()
        }
        
    }
    
    func buttonClick(_ sender: UIButton!) {
        if let marker = sender.superview?.superview as? CustomInfoView{
            guard let bike = marker.bike else{
                return
            }
            let dLat = bike.latitude
            let dLon = bike.longitude
            var url : URL?  = URL(string: "http://maps.google.com/maps?f=d&saddr=&daddr=\(dLat),\(dLon)&directionsmode=walking")
            
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                
                url = URL(string: "comgooglemaps://maps.google.com/maps?f=d&saddr=&daddr=\(dLat),\(dLon)&directionsmode=walking")
            }
            
            if let url = url{
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            
        }
    }

}


extension MapViewController : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reloadMarker()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker:
        GMSMarker) -> UIView? {
        
        return UIView()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        //return true
        guard let pinView = marker.iconView as? CustomPinView else {
            return true
        }
        
        
        selectedMarker = marker
        
        infoView.removeFromSuperview()
        infoView = CustomInfoView(frame: CGRect(x: 0, y: 0, width: 240  , height: 155))
        infoView.setBike(bike: pinView.bike)
        if let myLocation = mapView.myLocation , let bike = pinView.bike {
            let destination = CLLocation(latitude: bike.latitude, longitude: bike.longitude)
            infoView.distance = destination.distance(from: myLocation) / 1000.0
        }else{
            infoView.distance = -1.0
        }
        infoView.mapButton.addTarget(self, action: #selector(self.buttonClick(_:)), for: UIControlEvents.touchUpInside)
        
        infoView.center = mapView.projection.point(for: CLLocationCoordinate2DMake(pinView.bike!.latitude, pinView.bike!.longitude)) + infoViewOffset
        
        mapView.addSubview(infoView)
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        guard let pinView = selectedMarker?.iconView as? CustomPinView else{
            return
        }
        infoView.center = mapView.projection.point(for: CLLocationCoordinate2DMake(pinView.bike!.latitude, pinView.bike!.longitude)) + infoViewOffset
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.removeFromSuperview()
    }
    
}

extension MapViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard locations.count > 0 else{
            return
        }
        
        let location = locations.last!
        //mapView.myLocation = locations.last!
        
        if !isCameraSetted {
            //first time setting camera
            mapView.animate(to: GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15))
            isCameraSetted = true
        }
    }
    
    
}

func +( left: CGPoint , right : CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}


