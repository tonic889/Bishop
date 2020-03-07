//
//  ClockConfigurable.swift
//  Clocks
//
//  Created by Brian Cooke on 3/5/20.
//  Copyright © 2020 Brian Cooke. All rights reserved.
//

import Foundation

protocol ClockConfigurableProtocol {
    func onConfigurationChanged(Configuration: ClockConfigurationProtocol)
}

protocol ClockConfigurationProtocol {
    var Is24HourMode: Bool { get }
    var UseBold : Bool {get }
}
