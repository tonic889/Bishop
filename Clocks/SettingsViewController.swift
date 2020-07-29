//
//  SettingsViewController.swift
//  Clocks
//
//  Created by Brian Cooke on 3/3/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//


import UIKit

class SettingsViewController: UIViewController, ClockConfigurableProtocol {
    
    var is24HourMode = true;
    var useBold = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var versionLabel: UILabel!
        {
        didSet
        {
            versionLabel.text = "v " + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0.1")
            
        }
    }
    
    @IBAction func fontIndicatorValueChanged(_ sender: SegmentedControlView) {
        setControlFonts(segmentCtrl: FontStyleControl)
        
    }
    
    func setControlFonts(segmentCtrl : SegmentedControlView)
    {
        let font = segmentCtrl.selectedSegmentIndex == 0 ? LightFont! : BoldItalicFont!
        
        
        MilitaryTimeControl?.SegmentFonts = [ font, font]
        ReturnButton?.titleLabel?.font = font
    }
    @IBOutlet weak var FontStyleControl: SegmentedControlView!
        {
        didSet
        {
            FontStyleControl.selectedSegmentIndex = useBold ? 1:0;
            setControlFonts(segmentCtrl: FontStyleControl)
            FontStyleControl.SegmentFonts  = [ LightFont!, BoldItalicFont! ]
        }
    }
    @IBOutlet weak var MilitaryTimeControl: SegmentedControlView! {
        didSet
        {
            MilitaryTimeControl.selectedSegmentIndex = is24HourMode ? 1 : 0;
            setControlFonts(segmentCtrl: FontStyleControl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ClockSegue")
        {
            if let clockConfigurable = segue.destination as? ClockConfigurableProtocol {
                clockConfigurable.onConfigurationChanged(Configuration: ClockConfiguration(Is24HourMode: MilitaryTimeControl.selectedSegmentIndex == 1, UseBold: FontStyleControl.selectedSegmentIndex == 1));
                
            }
        }
    }
    func onConfigurationChanged(Configuration: ClockConfigurationProtocol) {
        self.is24HourMode = Configuration.Is24HourMode;
        self.useBold = Configuration.UseBold;
    }
    
    @IBOutlet weak var ReturnButton: UIButton! {
        didSet
        {
            ReturnButton.centerVertically()
            setControlFonts(segmentCtrl: FontStyleControl)
        }
    }
    @IBAction func onAcceptSettings(_ sender: Any) {
        performSegue(withIdentifier: "ClockSegue", sender: self)
        
    }
    
    
}

extension UIButton {
    
    func centerVertically(padding: CGFloat = 20.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: max(0, -(totalHeight - imageViewSize.height)),
            left: 0.0,
            bottom: 0.0,
            right: -self.frame.size.width + imageViewSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
  
}
