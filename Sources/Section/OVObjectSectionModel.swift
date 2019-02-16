//
//  OVObjectSectionModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVObjectSectionModel<ObjectType>: OVSectionModelProtocol {
    
    public var object: ObjectType
    
    private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    public let _header: () -> Any
    public let _footer: () -> Any
    
    public let movable: Bool = false
    public let removable: Bool = false
    public let keepOne: Bool = false
    public let addable: Bool = false
    
    public let cells: Array<OVCellModelProtocol>
    
    public init(
        _ object: ObjectType,
        header: @escaping @autoclosure () -> Any = "",
        footer: @escaping @autoclosure () -> Any = "",
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        cells: Array<OVCellModelProtocol>) {
        
        self.object = object
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._header = header
        self._footer = footer
        
        self.cells = cells
    }
    
    public func update() {
        
    }
    
    public func getCellCount() -> Int {
        return cells.count
    }
    
    public func getCell(_ row: Int) -> OVCellModelProtocol {
        return cells[row]
    }
    
    public func getHeader() -> String? {
        let str = "\(_header())"
        
        if str == "" {
            return nil
        }
        
        return String(placeholderResolver.resolve(str))
    }
    
    public func getFooter() -> String? {
        let str = "\(_footer())"
        
        if str == "" {
            return nil
        }
        
        return String(placeholderResolver.resolve(str))
    }
    
    public func getSectionType() -> OVSectionType {
        return .Object
    }
}
