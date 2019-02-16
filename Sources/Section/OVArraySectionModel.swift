//
//  OVArraySectionModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVArraySectionModel<ObjectType, ValueType>: OVSectionModelProtocol {
    
    public var object: ObjectType
    
    private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    public let _header: () -> Any
    public let _footer: () -> Any
    
    public let movable: Bool
    public let removable: Bool
    public let keepOne: Bool
    public let addable: Bool
   
    public let path: ReferenceWritableKeyPath<ObjectType, Array<ValueType>>
    
    private let objectFactory: ((Int) -> (ValueType))?
    private let cellFactory: ((Int, ValueType) -> (OVCellModelProtocol))
    private var cells: Array<OVCellModelProtocol> = []
    
    public init(
        _ object: ObjectType,
        header: @escaping @autoclosure () -> Any = "",
        footer: @escaping @autoclosure () -> Any = "",
        movable: Bool = false,
        removable: Bool = false,
        keepOne: Bool = false,
        placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        path: ReferenceWritableKeyPath<ObjectType, Array<ValueType>>,
        cellFactory: @escaping (Int, ValueType) -> (OVCellModelProtocol),
        objectFactory: ((Int) -> (ValueType))? = nil) {
        
        self.object = object
        
        self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._header = header
        self._footer = footer
        
        self.movable = movable
        self.removable = removable
        self.keepOne = keepOne
        self.addable = objectFactory != nil
        
        self.path = path
        
        self.cellFactory = cellFactory
        self.objectFactory = objectFactory
        
        setupCellModels()
    }
    
    private func setupCellModels() {
        cells = []
        
        let kp = object[keyPath: path]
        
        var row = 0
        
        // kp is an Array, because of the decalration above
        for entry in kp {
            let cell = cellFactory(row, entry)
            
            cells.append(cell)
            
            row += 1
        }
    }
    
    public func update() {
        setupCellModels()
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
        return .Array
    }
    
    public func moveObject(from: Int, to: Int) {
        object[keyPath: path].move(from: from, to: to)
        setupCellModels()
    }
    
    public func removeObject(at: Int) {
        object[keyPath: path].remove(at: at)
        setupCellModels()
    }
    
    public func addObject(at: Int) {
        if objectFactory == nil {
            return
        }
        
        let new = objectFactory!(at)
        
        object[keyPath: path].append(new)
        setupCellModels()
    }
}
