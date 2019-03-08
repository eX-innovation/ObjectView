//
//  OVArraySectionModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVArraySectionModel<ObjectType, ValueType>: OVSectionModelProtocol {
    
    /// Properties
    public let sectionType: OVSectionType = .Array
    
    public var object: ObjectType
    
    public let _header: () -> Any
    public let _footer: () -> Any
    
    private let onUpdate: (()->())?
    
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
        onUpdate: (()->())? = nil,
        movable: Bool = false,
        removable: Bool = false,
        keepOne: Bool = false,
        path: ReferenceWritableKeyPath<ObjectType, Array<ValueType>>,
        cellFactory: @escaping (Int, ValueType) -> (OVCellModelProtocol),
        objectFactory: ((Int) -> (ValueType))? = nil) {
        
        self.object = object
        
        self._header = header
        self._footer = footer
        
        self.onUpdate = onUpdate
        
        self.movable = movable
        self.removable = removable
        self.keepOne = keepOne
        self.addable = objectFactory != nil
        
        self.path = path
        
        self.cellFactory = cellFactory
        self.objectFactory = objectFactory
        
        setupCellModels()
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
    
    public func getCell(_ row: Int) -> OVCellModelProtocol {
        return cells[row]
    }
    
    // Array speicific
    
    public func moveObject(from: Int, to: Int) {
        object[keyPath: path].move(from: from, to: to)
        setupCellModels()
        
        onUpdate?()
    }
    
    public func removeObject(at: Int) {
        object[keyPath: path].remove(at: at)
        setupCellModels()
        
        onUpdate?()
    }
    
    public func addObject(at: Int) {
        if objectFactory == nil {
            return
        }
        
        let new = objectFactory!(at)
        
        object[keyPath: path].append(new)
        setupCellModels()
        
        onUpdate?()
    }
}
