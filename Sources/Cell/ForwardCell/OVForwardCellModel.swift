//
//  OVForwardCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVForwardCellModel: OVForwardCellModelProtocol {
    
    /// Properties
    public let cellType: OVCellType = .ForwardCell
    
    internal let controller: OVControllerModelProtocol
    
    private let _title: () -> Any
    private let _subtitle: () -> Any
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    public init(
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        controller: OVControllerModelProtocol?) {
        
        self._title = title
        self._subtitle = subtitle
        
        self.controller = controller!
    }
    
    /// Computed properties
    public var title: String {
        return "\(_title())"
    }
    
    public var subtitle: String {
        return "\(_subtitle())"
    }
    
    /// Methods
    public func updateAll() {
        controller.updateAll()
        connectedCell?.update()
    }
}
