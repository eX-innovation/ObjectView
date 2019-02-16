//
//  OVMultiForwardCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/3/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVMultiForwardCellModel<ObjectType>: OVForwardCellModelProtocol {
    
    internal var controller: OVControllerModelProtocol {
        
        let update = statusUpdate ?? { [unowned self] _, _ in
            if self.enableLoading {
                Log.error("statusUpdate is nil")
            }
        }
        
        guard let ret = controllerFactory(object, update) else {
            return OVControllerModel(object, "Error", sections: [])
        }
        
        return ret
    }
    
    public let cellType: OVCellType = .ForwardCell
    
    public let object: ObjectType
    
    //private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    
    private let _title: () -> Any
    public var title: String {
        //return placeholderResolver.resolve("\(_title())")
        return "\(_title())"
    }
    
    private let _subtitle: () -> Any
    public var subtitle: String {
        //return placeholderResolver.resolve("\(_subtitle())")
        return "\(_subtitle())"
    }
    
    // Indicates that cellFactory takes a while
    internal let enableLoading: Bool
    
    // Set by cell
    internal var statusUpdate: ((_ state: String?, _ spinner: Bool)->())? = nil
    
    private let controllerFactory: (_ obj: ObjectType, _ update:
    (_ state: String?, _ spinner: Bool)->()) -> (OVControllerModelProtocol?)
    
    public init(
        _ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        enableLoading: Bool = false,
        //placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        controllerFactory: @escaping (_ obj: ObjectType, _ update:
        (_ state: String?, _ spinner: Bool)->()) -> (OVControllerModelProtocol?)) {
        
        self.object = object
        
        //self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        self._subtitle = subtitle
        
        self.enableLoading = enableLoading
        
        self.controllerFactory = controllerFactory
    }
}
