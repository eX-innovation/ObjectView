//
//  OVObjectSectionModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVObjectSectionModel<ObjectType>: OVSectionModelProtocol {
    
    /// Properties
    public let sectionType: OVSectionType = .Object
    
    public var object: ObjectType
    
    private let _header: () -> Any
    private let _footer: () -> Any
    
    public let cells: Array<OVCellModelProtocol>
    
    public init(
        _ object: ObjectType,
        header: @escaping @autoclosure () -> Any = "",
        footer: @escaping @autoclosure () -> Any = "",
        cells: Array<OVCellModelProtocol>) {
        
        self.object = object
        
        self._header = header
        self._footer = footer
        
        self.cells = cells
    }
    
    /// Computed properties
    public var header: String? {
        let str = "\(_header())"
        
        if str == "" {
            return nil
        }
        
        return str
    }
    
    public var footer: String? {
        let str = "\(_footer())"
        
        if str == "" {
            return nil
        }
        
        return str
    }
    
    public var cellCount: Int {
        return cells.count
    }
    
    /// Methods
    public func updateAll() {
        for cell in cells {
            cell.updateAll()
        }
    }
    
    public func getCell(_ row: Int) -> OVCellModelProtocol {
        return cells[row]
    }
}
