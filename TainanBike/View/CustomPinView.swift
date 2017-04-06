//
//  CustomPinView.swift
//  TainanBike
//
//  Created by Li Yun Jung on 2017/3/30.
//  Copyright © 2017年 Li Yun Jung. All rights reserved.
//

import UIKit


public enum BikePinMode : Int {
    
    /** Normal Mode */
    case normal = 0
    
    /** Available Bike Count */
    case bike
    
    /** Available Space Count */
    case space
}


@IBDesignable class CustomPinView: UIView {
    
    var view: UIView!
    var mode : BikePinMode = .normal {
        didSet{
            if(bike == nil){
                
                return
            }
            
            switch(mode){
            case .normal:
                label.text = ""
                imageView.image = UIImage(named: "placeholder_red")
                break;
            case .bike:
                label.text = "\(bike!.avaliableBikeCount)"
                imageView.image = UIImage(named: "placeholder_32")
                break;
            case .space:
                label.text = "\(bike!.avaliableSpaceCount)"
                imageView.image = UIImage(named: "placeholder_32")
                break;
                
            }
            
            
        }
    }
    var bike : TBike?
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var label : UILabel!
    
    func setBike( bike : TBike , mode : BikePinMode){
        
        self.bike = bike
        self.mode = mode
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
        let nib = UINib(nibName: "CustomPinView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    
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
    
    
}
