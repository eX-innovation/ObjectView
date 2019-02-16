//
//  OVResolvePlaceholder.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVResolvePlaceholder<ObjectType> {
    
    public let placeholder: Dictionary<String, PartialKeyPath<ObjectType>>
    public let object: ObjectType
    
    public let keyString: String = "$"
    
    public init(
        _ placeholder: Dictionary<String, PartialKeyPath<ObjectType>>,
        _ object: ObjectType) {
        
        self.placeholder = placeholder
        self.object = object
    }
    
    public func resolve(_ str: String?) -> String? {
        guard let casted = str else {
            return  nil
        }
        
        return resolve(casted)
    }
    
    public func resolve(_ str: String) -> String {
        
        var res = str
        
        for (name, path) in placeholder {
            let val = readString(object, path: path)
            res = res.replacingOccurrences(of: keyString+name, with: val)
        }
        
        return res
    }
    
    func readString<T>(_ obj: T, path: PartialKeyPath<T>) -> String {
        guard let value = unwrap(obj[keyPath: path]) else {
            return "N/A"
        }
        
        switch value {
        case let string as String:
            return string
        case let integer as Int:
            return String(integer)
        case let double as Double:
            return String(double)
        default:
            return String(describing: value)
        }
    }
    
    func unwrap(_ value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        
        if mirror.displayStyle != .optional {
            return value
        }
        
        if let child = mirror.children.first {
            return child.value
        } else {
            return nil
        }
    }
}
