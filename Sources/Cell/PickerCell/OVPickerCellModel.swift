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
    
    ///Properties
    public let cellType: OVCellType = .PickerCell
    
    public let object: ObjectType
    
    private let _title: () -> Any
    private let _subtitle: () -> Any
    
    private let onUpdate: (()->())?
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, ValueType>
    
    private let enumCases = Array(ValueType.allCases)
    
    private var currentValue: ValueType
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, ValueType>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        onUpdate: (()->())? = nil) {
        
        self.object = object
        self.currentValue = object[keyPath: path]
        
        self._title = title
        self._subtitle = subtitle
        
        self.onUpdate = onUpdate
        
        self.keyPathWrapper = OVKeyPathWrapper(path)
        self.keyPathWrapper.setObject(object)
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
        connectedCell?.update()
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
        
        onUpdate?()
    }
    
    public func getSelectedCase() -> Int {
        let ret = enumCases.firstIndex(where: { (val) -> Bool in
            return val == currentValue
        })
        
        return ret ?? 0
    }
}
