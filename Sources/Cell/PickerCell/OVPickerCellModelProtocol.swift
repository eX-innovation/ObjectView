//
//  OVPickerCellProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/3/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public protocol OVPickerCellModelProtocol: OVCellModelProtocol {
    
    func getCaseCount() -> Int
    
    func getCaseText(_ row: Int) -> String?
    
    func selectCase(_ row: Int)
    
    func getSelectedCase() -> Int
}
