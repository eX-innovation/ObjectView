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
    
    ///Properties
    public let cellType: OVCellType = .SwitchCell
    
    public let object: ObjectType
    
    private let _title: () -> Any
    private let _subtitle: () -> Any
    
    private let onUpdate: (()->())?
    
    internal let keyPathWrapper: OVKeyPathWrapper<ObjectType, Bool>
    
    /// Reference to cell
    public var connectedCell: OVCellProtocol?
    
    var _value: Bool = false
    
    public init(
        _ object: ObjectType,
        _ path: ReferenceWritableKeyPath<ObjectType, Bool>,
        _ title: @escaping @autoclosure () -> Any,
        subtitle: @escaping @autoclosure () -> Any = "",
        onUpdate: (()->())? = nil) {
        
        self.object = object
        
        //self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
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
    
    internal var value: Bool {
        set {
            _value = newValue
            self.keyPathWrapper.setValue(_value)
            onUpdate?()
        }
        
        get {
            _value = self.keyPathWrapper.getValue()
            return _value
        }
    }
    
    /// Methods
    public func updateAll() {
        connectedCell?.update()
    }
}
