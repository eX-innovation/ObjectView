//
//  OVSwitchCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

internal protocol OVSwitchCellModelProtocol: OVCellModelProtocol {
    
    var value: Bool { get set }
    
}
