//
//  OVActionCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/4/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

public class OVActionCellModel/*<ObjectType>*/: OVActionCellModelProtocol {
    
    public let cellType: OVCellType = .ActionCell
    
    //public let object: ObjectType
    
    //private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    
    internal let action: () -> ()
    
    private let _title: () -> Any
    public var title: String {
        //return placeholderResolver.resolve("\(_title())")
        return "\(_title())"
    }
    
    public let subtitle: String = ""
    
    public init(
        //_ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        //placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        action: @escaping () -> ()) {
        
        //self.object = object
        
        //self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        
        self.action = action
    }
}

