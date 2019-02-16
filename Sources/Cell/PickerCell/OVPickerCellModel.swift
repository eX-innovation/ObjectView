//
//  OVPickerCellModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation
import UIKit

public class OVPickerCellModel<ObjectType, ValueType:PickableEnum>: OVPickerCellModelProtocol {
    
    public let cellType: OVCellType = .PickerCell
    
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
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, ValueType>
    
    private let enumCases = Array(ValueType.allCases)
    private var currentValue: ValueType
    
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, ValueType>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:]) {
        
        self.object = object
        self.currentValue = object[keyPath: path]
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        self._subtitle = subtitle
        
        self.keyPathWrapper = OVKeyPathWrapper(path)
        self.keyPathWrapper.setObject(object)
    }
    
    public func getCaseCount() -> Int {
        return enumCases.count
    }
    
    public func getCaseText(_ row: Int) -> String? {
        return String(describing: enumCases[row])
    }
    
    public func selectCase(_ row: Int) {
        if row >= enumCases.count {
            return
        }
        
        currentValue = enumCases[row]
        keyPathWrapper.setValue(currentValue)
    }
    
    public func getSelectedCase() -> Int {
        let ret = enumCases.firstIndex(where: { (val) -> Bool in
            return val == currentValue
        })
        
        return ret ?? 0
    }
}
