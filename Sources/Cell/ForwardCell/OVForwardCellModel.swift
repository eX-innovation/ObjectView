//
//  OVForwardCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVForwardCellModel<ObjectType>: OVForwardCellModelProtocol {
    
    internal let controller: OVControllerModelProtocol
    
    public let cellType: OVCellType = .ForwardCell
    
    public let object: ObjectType
    
    private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    
    private let _title: () -> Any
    public var title: String {
        return placeholderResolver.resolve("\(_title())")
    }
    
    private let _subtitle: () -> Any
    public var subtitle: String {
        return placeholderResolver.resolve("\(_subtitle())")
    }
    
    public init(
        _ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        controller: OVControllerModelProtocol?) {
        
        self.object = object
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        self._subtitle = subtitle
        
        self.controller = controller!
    }
}
