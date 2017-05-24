//
//  DistanceViewController.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/5/17.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class DistanceViewController: UIViewController {
    
    var markerDistances : [(marker: GMSMarker,distance : Double)] = []
    var selected : GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markerDistances.sort {
            return $0.distance <= $1.distance
        }
        for tuple in markerDistances {
            
            guard let pinView = tuple.marker.iconView as? CustomPinView else {
                break
            }
            print(pinView.bike!.stationName)
            print(tuple.distance)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(segue.destination)
        if let mapController = segue.destination as? MapViewController ,selected != nil{
            
            mapController.selectedMarker = selected
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DistanceViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markerDistances.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let distance = markerDistances[indexPath.row].distance
        guard let pinView = markerDistances[indexPath.row].marker.iconView as? CustomPinView else {
            return UITableViewCell()
        }
        let name = pinView.bike!.stationName
        
        var cell :DistanceTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: "Distance") as? DistanceTableViewCell
        
        if (cell == nil){
            if let nib:Array = Bundle.main.loadNibNamed("DistanceTableViewCell", owner: self, options: nil){
                cell = nib[0] as? DistanceTableViewCell
            }
        }
        
        
        cell?.distanceNameLabel.text  = String.init(format: "%.1f公里", distance / 1000)
        cell?.stationNameLabel.text = name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selected = markerDistances[indexPath.row].marker
        performSegue(withIdentifier: "unwindToMapView", sender: self)
        
    }
    
}
