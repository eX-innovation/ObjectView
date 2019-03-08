//
//  OVCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public protocol OVCellModelProtocol {
    
    var cellType: OVCellType { get }
    
    var title: String { get }
    var subtitle: String { get }
    
    /// Reference to cell
    var connectedCell: OVCellProtocol? { get set }
    
    /// This call will tell the model and the cell to update
    func updateAll()
}
