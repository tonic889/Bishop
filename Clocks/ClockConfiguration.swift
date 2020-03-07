//
//  ClockConfiguration.swift
//  Clocks
//
//  Created by Brian Cooke on 3/5/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import Foundation

class ClockConfiguration : ClockConfigurationProtocol
{
    private(set) var Is24HourMode: Bool;
    
    private(set) var UseBold: Bool;
    
    init (Is24HourMode: Bool, UseBold: Bool)
    {
        self.Is24HourMode = Is24HourMode;
        self.UseBold = UseBold;
    }
    
    
}
