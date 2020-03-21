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
    
    @IBAction func myUnwindAction(_ segue: UIStoryboardSegue)
    {
        updateDisplayDate();
    }
    
    var timer : Timer?
    var is24HourMode = false;
    var formatter = DateFormatter();
    var useBold = false;
    
    @IBOutlet weak var tapViewRecognizer: UITapGestureRecognizer!
    {
        didSet
        {
            tapViewRecognizer?.delegate = self
        }
    }
    
    @IBOutlet weak var meridiemLabel: UILabel!
    {
        didSet
        {
            meridiemLabel?.text = GetMeridiemString(aDate: Date())
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
    @IBAction func tapGesture(_ sender: Any) {
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: { self.settingsButton.alpha = 1.0 },
                       completion: { (finished) in
                        UIView.animate(withDuration: 3.0,
            delay: 0,
            options: UIView.AnimationOptions.allowUserInteraction,
            animations: { self.settingsButton.alpha = 0.1 } )
        }
        );
        
        
    }
    @IBOutlet weak var displayDate: UILabel!
    {
        didSet
        {
            updateDisplayDate();
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDisplayDate), userInfo: nil, repeats: true)
            UIApplication.shared.isIdleTimerDisabled = true;
        }
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    @objc func updateDisplayDate()
    {
        formatter.dateFormat = GetDateFormat()
        displayDate.text = formatter.string(from: Date())
        meridiemLabel?.text = GetMeridiemString(aDate: Date())
        setDisplayDateFont();
        setMeridiemFont();
    }
    
    func  GetDateFormat() -> String
    {
        return is24HourMode ? "HH:mm" : "hh:mm"
    }
    
    @IBAction func onSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    func setDisplayDateFont()
    {
       
        if (!useBold) {
            displayDate?.font = UIFont(name: "SFProDisplay-Ultralight", size: 124)
        } else {
            displayDate?.font = UIFont(name: "SFProDisplay-HeavyItalic", size: 124)
        }
    }
    
    func setMeridiemFont()
    {
          if (!useBold) {
            meridiemLabel?.font = UIFont(name: "SFProDisplay-Light", size: 36)
          } else {
            meridiemLabel?.font = UIFont(name: "SFProDisplay-BoldItalic", size: 36)
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

extension ClockViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive: UITouch) -> Bool {
        //
        return !settingsButton.frame.contains(shouldReceive.location(in: self.view));

    }
}

