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
    var timer : Timer?
    var is24HourMode = false;
    var formatter = DateFormatter();
    var useBold = false;
    
    
    @IBOutlet weak var SliderView: UIView!
    @IBOutlet weak var displayTimeSeparator: UILabel!
        {
        didSet
        {
            updateDisplayDate();
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateDisplayDate), userInfo: nil, repeats: true)
            UIApplication.shared.isIdleTimerDisabled = true;
        }
    }
    
    
    @IBOutlet weak var settingsSliderTrack: SettingsSliderTrack!
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
    
    @IBAction func tapGesture(_ sender: Any) {
        toggleSliderVisibility(visibility: self.settingsSlider.alpha < 1.0)
    }
    
    func toggleSliderVisibility(visibility : Bool) {
        let desiredAlpha = visibility ? CGFloat(1.0) : CGFloat(0.0);
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState],
                       animations: {
                        self.settingsSliderTrack.alpha = desiredAlpha
                        self.settingsSlider.alpha = desiredAlpha
        })
    }
    @IBOutlet weak var settingsSlider: UIImageView!
        {
        didSet
        {
            settingsSlider.layer.zPosition = 1
        }
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        if (gesture.state == UIGestureRecognizer.State.began)
        {
            toggleSliderVisibility(visibility: true)
        }
        let buttonHeight = settingsSlider.frame.size.width / 2
        
        var yPos = max(gesture.location(in: SliderView).y, 0) + buttonHeight
        yPos = min(yPos, SliderView.frame.height - buttonHeight)
        settingsSlider.center = CGPoint(x: settingsSlider.center.x, y: yPos)
        if (yPos <= buttonHeight)
        {
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.beginFromCurrentState],
                           animations: {
                            self.settingsSlider.image = UIImage(named: "SettingsSliderComplete")
                            self.settingsSliderTrack.onSwiped()
            }
                , completion: { (finished) in
                    self.performSegue(withIdentifier: "SettingsSegue", sender: self)
                    self.toggleSliderVisibility(visibility: false)
                    
            })
        }
        
        if (gesture.state == UIGestureRecognizer.State.ended)
        {
            resetSlider()
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
    
    @objc func updateDisplayDate()
    {
        let theDate = Date()
        formatter.dateFormat = GetHourFormat()
        displayTimeSeparator.text = formatter.string(from: theDate)
        
        meridiemLabel?.text = GetMeridiemString(aDate: Date())
        setDisplayDateFont();
        setMeridiemFont();
    }
    
    func GetHourFormat() -> String
    {
        return is24HourMode ? "H:mm" : "h:mm";
    }
    
    func setDisplayDateFont()
    {
        let theFont = useBold ? HeavyItalicFont : UltraLightFont
        
        displayTimeSeparator?.font = theFont;
    }
    
    func setMeridiemFont()
    {
        meridiemLabel?.font = useBold ? BoldItalicFont : LightFont
    }
    
    func resetSlider()
    {
        let buttonHeight = settingsSlider.frame.size.width / 2
        settingsSlider.image = UIImage(named: "SettingsSlider")
        settingsSlider.center = CGPoint(x: settingsSliderTrack.center.x, y: settingsSliderTrack.frame.maxY - buttonHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "SettingsSegue")
        {
            if let clockConfigurable = segue.destination as? ClockConfigurableProtocol {
                clockConfigurable.onConfigurationChanged(Configuration: ClockConfiguration(Is24HourMode: is24HourMode, UseBold: useBold));
            }
        }
    }
    
    func onConfigurationChanged(Configuration: ClockConfigurationProtocol) {
        self.is24HourMode = Configuration.Is24HourMode;
        self.useBold = Configuration.UseBold;
        resetSlider()
    }
    
    @IBAction func myUnwindAction(_ segue: UIStoryboardSegue)
    {
        updateDisplayDate();
        settingsSliderTrack.setNeedsDisplay()
    }
}

extension ClockViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive: UITouch) -> Bool {
        let location = shouldReceive.location(in: self.SliderView)
        
        return !settingsSliderTrack.frame.contains(location);
    }
}

