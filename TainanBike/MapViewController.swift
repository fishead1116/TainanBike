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
    
    var selectedMarker : GMSMarker? = nil
    var infoView = CustomInfoView(frame: CGRect(x: 0, y: 0, width: 240  , height: 155))

    
    var bikes : [TBike] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadMarker()
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: 22.932706,longitude: 120.230637, zoom: 15)
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.setAllGesturesEnabled(true)
        
        placesClient = GMSPlacesClient.shared()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func optionValueChanged(_ sender: Any) {
        
        if let mode = BikePinMode(rawValue: optionSegmentedControl.selectedSegmentIndex){
            self.pinMode = mode
            reloadMarker()
        }
        
    }
    
    func imageForView(view : UIView) -> UIImage? {
        
        if(UIScreen.main.responds(to: #selector(getter: UIScreen.scale))){
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        }else{
            UIGraphicsBeginImageContext(view.frame.size)
        }
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func reloadMarker(){
        
        TBike.getTBikeStatus { (bikes : [TBike]) in
            
            self.bikes = bikes
            
            self.mapView.clear()
            
            for bike in bikes {
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(bike.latitude, bike.longitude)
                
                let customView = CustomPinView(frame: CGRect.init(x: 0, y: 0, width: 32, height: 32))
                customView.setBike(bike: bike, mode: self.pinMode)
                //customView.label.text = "\(bike.avaliableBikeCount)"
                marker.iconView = customView
                
                marker.map = self.mapView
                
                self.mapView.reloadInputViews()
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



extension MapViewController : GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reloadMarker()
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker:
        GMSMarker) -> UIView? {
        
        return UIView()
        
        guard let pinView = marker.iconView as? CustomPinView else {
            return nil
        }
        selectedMarker = marker
        
        infoView.removeFromSuperview()
        infoView = CustomInfoView(frame: CGRect(x: 0, y: 0, width: 240  , height: 155))
        infoView.setBike(bike: pinView.bike)
        
        
        //infoView.center = mapView.projection.point(for: CLLocationCoordinate2DMake(pinView.bike!.latitude, pinView.bike!.longitude))
        return infoView
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        
//        return true
//        guard let pinView = marker.iconView as? CustomPinView else {
//            return true
//        }
//        selectedMarker = marker
//        
//        infoView.removeFromSuperview()
//        infoView = CustomInfoView(frame: CGRect(x: 0, y: 0, width: 240  , height: 155))
//        infoView.setBike(bike: pinView.bike)
//        
//        infoView.center = mapView.projection.point(for: CLLocationCoordinate2DMake(pinView.bike!.latitude, pinView.bike!.longitude))
//         mapView.addSubview(infoView)
//        
//        return false
//    }
    
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        
//        guard let pinView = selectedMarker?.iconView as? CustomPinView else{
//            return
//        }
//         infoView.center = mapView.projection.point(for: CLLocationCoordinate2DMake(pinView.bike!.latitude, pinView.bike!.longitude))
//    }
//    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        infoView.removeFromSuperview()
//    }
}

