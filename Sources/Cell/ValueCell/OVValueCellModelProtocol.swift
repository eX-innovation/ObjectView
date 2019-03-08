//
//  OVValueCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

internal protocol OVValueCellModelProtocol: OVCellModelProtocol {
    
    var allowCustomInput: Bool { get }
    var keyboardType: UIKeyboardType { get }
    
    var value: String { get set }
    
    var pickerValues: (() -> (Array<String>))? { get }
}
