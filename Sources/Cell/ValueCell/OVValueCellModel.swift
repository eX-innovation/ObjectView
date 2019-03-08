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
    
    ///Properties
    public let cellType: OVCellType = .TextFieldCell
    
    public let object: ObjectType
    
    private let _title: () -> Any
    private let _subtitle: () -> Any
    
    private let onUpdate: (()->())?
    
    internal let pickerValues: (() -> (Array<String>))?
    internal private(set) var keyboardType: UIKeyboardType = .default
    
    public let allowCustomInput: Bool
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, ValueType>
    
    var _value: String = ""
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    /// Constructor
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, ValueType>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        onUpdate: (()->())? = nil,
        allowCustomInput: Bool = true,
        pickerValues: (() -> (Array<String>))? = nil) {
        
        self.object = object
        
        self._title = title
        self._subtitle = subtitle
        
        self.onUpdate = onUpdate
        
        self.keyPathWrapper = OVKeyPathWrapper(path)
        self.keyPathWrapper.setObject(object)
        
        self.allowCustomInput = allowCustomInput
        
        self.pickerValues = pickerValues
        
        keyboardType = selectKeyboardType(ValueType.self)
    }
    
    /// Computed properties
    public var title: String {
        return "\(_title())"
    }
    
    public var subtitle: String {
        return "\(_subtitle())"
    }
    
    internal var value: String {
        set {
            _value = newValue
            self.keyPathWrapper.setStringValue(_value)
            onUpdate?()
        }
        
        get {
            _value = self.keyPathWrapper.getStringValue() ?? "Error"
            return _value
        }
    }
    
    /// Methods
    public func updateAll() {
        connectedCell?.update()
    }
    
    private func selectKeyboardType<ValueType>(_ type: ValueType.Type) -> UIKeyboardType {
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
}
