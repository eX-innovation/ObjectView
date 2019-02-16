//
//  OVSwitchCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation
import UIKit

public class OVSwitchCellModel<ObjectType>: OVSwitchCellModelProtocol {
    
    public let cellType: OVCellType = .SwitchCell
    
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
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, Bool>
    
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, Bool>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:]) {
        
        self.object = object
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        self._subtitle = subtitle
        
        self.keyPathWrapper = OVKeyPathWrapper(path)
        self.keyPathWrapper.setObject(object)
    }
    
    var _value: Bool = false
    
    var value: Bool {
        set {
            _value = newValue
            self.keyPathWrapper.setValue(_value)
        }
        
        get {
            _value = self.keyPathWrapper.getValue()
            return _value
        }
    }
}
