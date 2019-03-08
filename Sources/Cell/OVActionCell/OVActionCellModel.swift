//
//  OVActionCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/4/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVActionCellModel: OVActionCellModelProtocol {
    
    public let cellType: OVCellType = .ActionCell
    
    private let _title: () -> Any
    
    internal let action: () -> ()
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    public init(
        _ title: @escaping @autoclosure () -> Any,
        action: @escaping () -> ()) {
        
        self._title = title
        
        self.action = action
    }
    
    /// Computed properties
    public var title: String {
        return "\(_title())"
    }
    
    public var subtitle: String {
        return ""
    }
    
    /// Methods
    public func updateAll() {
        connectedCell?.update()
    }
}

