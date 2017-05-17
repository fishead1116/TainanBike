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
    
    var myLocation : CLLocation? = nil
    var markers : [GMSMarker] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(myLocation)
        for marker in markers {
            guard let pinView = marker.iconView as? CustomPinView else {
                break
            }
            print(pinView.bike!.stationName)
            print(pinView.bike!.latitude)
            print(pinView.bike!.longitude)
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBackToOneButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMapView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
