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
        resetSlider()
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
    
    @IBOutlet weak var displayMinutes: UILabel!
    {
        didSet
        {
             updateDisplayDate();
            
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
        fadeIn(fadeInCompletion : fadeOut(_:) )
    }
    
    func fadeIn(fadeInCompletion : ((Bool) -> Void)? = nil )
    {
      UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.settingsSliderTrack.alpha = 1.0
                        self.settingsSlider.alpha = 1.0 },
                       completion: fadeInCompletion
        )
    }
    
    func fadeOut(_ : Bool)
    {
        UIView.animate(withDuration: 3.0,
        delay: 0,
        options: UIView.AnimationOptions.allowUserInteraction,
        animations: {
            self.settingsSliderTrack.alpha = 0.1
            self.settingsSlider.alpha = 0.1
                    }
        );
    }
    @IBOutlet weak var displayHour: UILabel!
    {
        didSet
        {
            updateDisplayDate();
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDisplayDate), userInfo: nil, repeats: true)
            UIApplication.shared.isIdleTimerDisabled = true;
        }
    }
    
    @objc func updateDisplayDate()
    {
        let theDate = Date()
        formatter.dateFormat = GetHourFormat()
        displayHour?.text = formatter.string(from: theDate)
        
        formatter.dateFormat = GetMinuteFormat();
        displayMinutes?.text = formatter.string(from: theDate)
        
        meridiemLabel?.text = GetMeridiemString(aDate: Date())
        setDisplayDateFont();
        setMeridiemFont();
    }
    
    func  GetHourFormat() -> String
    {
        return is24HourMode ? "H" : "h";
    }
    
    func  GetMinuteFormat() -> String
    {
        return "mm";
    }

    func setDisplayDateFont()
    {
        let theFont = (!useBold) ? UIFont(name: "SFProDisplay-Ultralight", size: 124) : UIFont(name: "SFProDisplay-HeavyItalic", size: 124)
        
        displayHour?.font = theFont;
        displayMinutes?.font = theFont;
        displayTimeSeparator?.font = theFont;
    }
    
    func setMeridiemFont()
    {
          if (!useBold) {
            meridiemLabel?.font = UIFont(name: "SFProDisplay-Light", size: 36)
          } else {
            meridiemLabel?.font = UIFont(name: "SFProDisplay-BoldItalic", size: 36)
          }
      }
    
    @IBOutlet weak var settingsSlider: UIImageView!
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
       
        fadeIn(fadeInCompletion: nil)

        let buttonHeight = settingsSlider.frame.size.width / 2
        var yPos = max(gesture.location(in: view).y, gesture.view!.frame.minY) + buttonHeight
        yPos = min(yPos, gesture.view!.frame.maxY - buttonHeight)
        settingsSlider.center = CGPoint(x: settingsSlider.center.x, y: yPos)
        if (yPos <= gesture.view!.frame.minY + buttonHeight)
        {
            UIView.animate(withDuration: 1,
                   delay: 0,
                   options: UIView.AnimationOptions.allowUserInteraction,
                   animations: {
                    self.settingsSlider.image = UIImage(named: "SettingsSliderComplete")
                               }
                , completion: { (finished) in
                    self.performSegue(withIdentifier: "SettingsSegue", sender: self)
                    self.fadeOut(true)
                })
        }
        
        if (gesture.state == UIGestureRecognizer.State.ended)
        {
            resetSlider()
            fadeOut(true)
        }
    }
    
    func resetSlider()
    {
          let buttonHeight = settingsSlider.frame.size.width / 2
        settingsSlider.image = UIImage(named: "SettingsSlider")
        settingsSlider.center = CGPoint(x: settingsSliderTrack.center.x, y: settingsSliderTrack.frame.maxY - buttonHeight)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SettingsSegue")
        {
            if let clockConfigurable = segue.destination as? ClockConfigurableProtocol {
                clockConfigurable.onConfigurationChanged(Configuration: ClockConfiguration(Is24HourMode: is24HourMode, UseBold: useBold));
                
            }
        }
    }
    
    
    @IBOutlet weak var displayTimeSeparator: UILabel!
    {
        didSet
        {
            updateDisplayDate();
        }
        
    }
    @IBOutlet weak var settingsSliderTrack: UIImageView!
}

extension ClockViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive: UITouch) -> Bool {
        //
        return !settingsSliderTrack.frame.contains(shouldReceive.location(in: self.view));

    }
}

