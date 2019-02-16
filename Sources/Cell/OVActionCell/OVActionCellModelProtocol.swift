//
//  OVActionCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/4/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

internal protocol OVActionCellModelProtocol: OVCellModelProtocol {
    
    var action: () -> () { get }
    
}
