//
//  OVKeyPathWrapper.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVKeyPathWrapper<ObjectType, ValueType> {
    
    /// Path to Property
    public let path: ReferenceWritableKeyPath<ObjectType, ValueType>
    
    /// Reference to Object
    public var object: ObjectType?
    
    public init(_ path: ReferenceWritableKeyPath<ObjectType, ValueType>) {
        self.path = path
    }
    
    public func setObject(_ obj: ObjectType) {
        object = obj
    }
    
    func getValue() -> ValueType {
        return object![keyPath: path]
    }
    
    func setValue(_ val: ValueType) {
        object![keyPath: path] = val
    }
    
    public func getStringValue() -> String? {
        
        var value = ""
        let pathValue = object![keyPath: path]
        
        switch ValueType.self {
        case is String.Type:
            value = pathValue as! String
        case is Int.Type:
            value = String(pathValue as! Int)
        case is Double.Type:
            value = String(pathValue as! Double)
        case is Bool.Type:
            value = String(pathValue as! Bool)
        default:
            value = String(describing: type(of: pathValue)) 
        }
        
        //print("Get string: \(value)")
        
        return value
    }
    
    public func setStringValue(_ str: String) {
        
        //print("Set string: \(str)")
        
        if object == nil {
            //Log!
            print("OVKeyPathWrapper: setStringValue(): Object is nil")
            return
        }
        
        var toWrite: ValueType?
        
        switch ValueType.self {
        case is String.Type:
            toWrite = str as? ValueType
        case is Int.Type:
            toWrite = Int(str) as? ValueType
        case is Double.Type:
            toWrite = Double(str) as? ValueType
        default:
            break
        }
        
        guard let value = toWrite else {
            print("OVKeyPathWrapper: setStringValue(): Could't convert string to value")
            return
        }
        
        object![keyPath: path] = value
    }
    
}
