//
//  OVCellProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public protocol OVCellProtocol {
    
    func setup(_ model: OVCellModelProtocol)
    func update()
    
}
