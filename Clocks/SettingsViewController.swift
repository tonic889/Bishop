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
    
   
    @IBOutlet weak var MilitaryTimeControl: UISegmentedControl!
    {
        didSet
        {
            MilitaryTimeControl.selectedSegmentIndex = is24HourMode ? 1 : 0;
        }
    }
    @IBOutlet weak var FontStyleControl: UISegmentedControl!
    {
        didSet
        {
            FontStyleControl.selectedSegmentIndex = useBold ? 1:0;
        }
    }
    @IBAction func on24HourModeChanged(_ sender: UISegmentedControl) {
        is24HourMode = sender.selectedSegmentIndex == 1;
    }
    
    @IBAction func onUseBoldChanged(_ sender: UISegmentedControl) {
        useBold = sender.selectedSegmentIndex == 1;
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ClockSegue")
        {
            if let clockConfigurable = segue.destination as? ClockConfigurableProtocol {
                clockConfigurable.onConfigurationChanged(Configuration: ClockConfiguration(Is24HourMode: is24HourMode, UseBold: useBold));
                
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
