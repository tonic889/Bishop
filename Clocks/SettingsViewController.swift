//
//  SettingsViewController.swift
//  Clocks
//
//  Created by Brian Cooke on 3/3/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
