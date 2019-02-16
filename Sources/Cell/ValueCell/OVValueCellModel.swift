//
//  OVCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation
import UIKit

public class OVValueCellModel<ObjectType, ValueType>: OVValueCellModelProtocol {
    
    public let cellType: OVCellType = .TextFieldCell
    
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
    
    internal let pickerValues: (() -> (Array<String>))?
    internal private(set) var keyboardType: UIKeyboardType = .default
    
    public let allowCustomInput: Bool
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, ValueType>
    
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, ValueType>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        allowCustomInput: Bool = true,
        pickerValues: (() -> (Array<String>))? = nil) {
        
        self.object = object
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        self._subtitle = subtitle
        
        self.keyPathWrapper = OVKeyPathWrapper(path)
        self.keyPathWrapper.setObject(object)
        
        self.allowCustomInput = allowCustomInput
        
        self.pickerValues = pickerValues
        
        keyboardType = selectKeyboardType(ValueType.self)
    }
    
    func selectKeyboardType<ValueType>(_ type: ValueType.Type) -> UIKeyboardType {
        switch ValueType.self {
        case is String.Type:
            return .asciiCapable
        case is Int.Type:
            return .numberPad
        case is Double.Type:
            return .decimalPad
        default:
            return .default
        }
    }
    
    var _value: String = ""
    
    var value: String {
        set {
            _value = newValue
            self.keyPathWrapper.setStringValue(_value)
        }
        
        get {
            _value = self.keyPathWrapper.getStringValue() ?? "Error"
            return _value
        }
    }
}
