//
//  CustomInfoView.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/4/6.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import UIKit


let infoViewOffset = CGPoint(x:0.0,y:-110.0)

class CustomInfoView: UIView {

    var view: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var availableBikeLabel: UILabel!
    @IBOutlet weak var availableSpaceLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var bike : TBike? {
        didSet {
            guard bike != nil else {
                return
            }
          
            nameLabel.text = "\(bike!.stationName)"
            availableBikeLabel.text = "空車：\(bike!.avaliableBikeCount)"
            availableSpaceLabel.text = "空位：\(bike!.avaliableSpaceCount)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            updateTimeLabel.text = "更新時間：" + dateFormatter.string(from: bike!.updateTime)
            
        }
    }
    
    var distance : Double = 0.0 {
        didSet {
            distanceLabel.text = String.init(format: "距離：%.1f 公里", distance)
            if(distance < 0.0){
                distanceLabel.text = ""
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomInfoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }


    func setBike(bike : TBike?){
        self.bike = bike
    }
    
    
}
