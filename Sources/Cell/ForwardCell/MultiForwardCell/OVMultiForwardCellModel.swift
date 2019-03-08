//
//  OVMultiForwardCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/3/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVMultiForwardCellModel<ObjectType>: OVForwardCellModelProtocol {
    
    /// Properties
    public let cellType: OVCellType = .ForwardCell
    
    public let object: ObjectType
    
    private let _title: () -> Any
    private let _subtitle: () -> Any
    
    // Indicates that needs to load
    internal let enableLoading: Bool
    
    // Set by cell
    internal var statusUpdate: ((_ title: String?, _ subtitle: String?, _ spinner: Bool)->())? = nil
    
    private let controllerFactory: (_ obj: ObjectType, _ update:
    (_ title: String?, _ subtitle: String?, _ spinner: Bool)->()) -> (OVControllerModelProtocol?)
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    public init(
        _ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        enableLoading: Bool = false,
        controllerFactory: @escaping (_ obj: ObjectType, _ update:
        (_ title: String?, _ subtitle: String?, _ spinner: Bool)->()) -> (OVControllerModelProtocol?)) {
        
        self.object = object
        
        self._title = title
        self._subtitle = subtitle
        
        self.enableLoading = enableLoading
        
        self.controllerFactory = controllerFactory
    }
    
    /// Computed properties
    public var title: String {
        return "\(_title())"
    }
    
    public var subtitle: String {
        return "\(_subtitle())"
    }
    
    internal var controller: OVControllerModelProtocol {
        
        let update = statusUpdate ?? { [unowned self] _, _, _ in
            if self.enableLoading {
                print("statusUpdate is nil")
            }
        }
        
        guard let ret = controllerFactory(object, update) else {
            return OVControllerModel(object, "Error", sections: [])
        }
        
        return ret
    }
    
    /// Methods
    public func updateAll() {
        connectedCell?.update()
    }
}
