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
    
    @IBOutlet weak var FontStyleControl: SegmentedControlView!
        {
        didSet
        {
            FontStyleControl.selectedSegmentIndex = useBold ? 1:0;
        }
    }
    @IBOutlet weak var MilitaryTimeControl: SegmentedControlView! {
        didSet
        {
            MilitaryTimeControl.selectedSegmentIndex = is24HourMode ? 1 : 0;
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
    
    @IBAction func onAcceptSettings(_ sender: Any) {
        performSegue(withIdentifier: "ClockSegue", sender: self)
        
    }
    
    
}
