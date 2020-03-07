//
//  ClockViewController.swift
//  Clocks
//
//  Created by Brian Cooke on 1/25/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import UIKit
		
class ClockViewController : ViewController, ClockConfigurableProtocol
{
    func onConfigurationChanged(Configuration: ClockConfigurationProtocol) {
        self.is24HourMode = Configuration.Is24HourMode;
        self.useBold = Configuration.UseBold;       
    }
    
    var timer : Timer?
    var is24HourMode = false;
    var formatter = DateFormatter();
    var useBold = false;
    
    @IBOutlet weak var meridiemLabel: UILabel!
    {
        didSet
        {
            meridiemLabel?.text = GetMeridiemString(aDate: Date())
            setFont(label: meridiemLabel)
        }
    }
    
    func GetMeridiemString(aDate:Date) -> String
    {
        if (is24HourMode)
        {
            return "";
        }
        else
        {
            formatter.dateFormat = "a";
            return formatter.string(from: aDate);
        }
        
    }
    @IBOutlet weak var displayDate: UILabel!
        {
            didSet
            {
                setFont(label: displayDate)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDisplayDate), userInfo: nil, repeats: true)
            }
    }
    
    @objc func updateDisplayDate()
    {
        formatter.dateFormat = GetDateFormat()
        displayDate.text = formatter.string(from: Date())
        meridiemLabel.text = GetMeridiemString(aDate: Date())
    }
    
    func  GetDateFormat() -> String
    {
        return is24HourMode ? "HH:mm" : "hh:mm"
    }
    
    @IBAction func onSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    func setFont(label : UILabel?)
    {
        if (useBold) {
            label?.font = label?.font.bold()
        } else {
            label?.font = label?.font.regular()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "SettingsSegue")
           {
               if let clockConfigurable = segue.destination as? ClockConfigurableProtocol {
                    clockConfigurable.onConfigurationChanged(Configuration: ClockConfiguration(Is24HourMode: is24HourMode, UseBold: useBold));
                   
               }
           }
       }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits:.traitBold)
    }
    func regular() -> UIFont {
      return withTraits()
        
    }

}

