//
//  OVDictionarySectionModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVDictionarySectionModel<ObjectType, KeyType: Hashable, ValueType>: OVSectionModelProtocol {
    
    /// Properties
    public let sectionType: OVSectionType = .Dictionary
    
    public var object: ObjectType
    
    private let _header: () -> Any
    private let _footer: () -> Any
    
    public let movable: Bool = false // Not supported by Dict
    public let removable: Bool
    public let keepOne: Bool
    public let addable: Bool
    
    public let path: ReferenceWritableKeyPath<ObjectType, Dictionary<KeyType, ValueType>>
    
    private let objectFactory: ((Int, ()->(KeyType, ValueType)) -> ())?
    private let cellFactory: ((Int, KeyType, ValueType) -> (OVCellModelProtocol))
    
    private var cells: Array<OVCellModelProtocol> = []
    private var cellKeys: Array<KeyType> = []
    
    public init(
        _ object: ObjectType,
        header: @escaping @autoclosure () -> Any = "",
        footer: @escaping @autoclosure () -> Any = "",
        removable: Bool = true,
        keepOne: Bool = false,
        path: ReferenceWritableKeyPath<ObjectType, Dictionary<KeyType, ValueType>>,
        cellFactory: @escaping (Int, KeyType, ValueType) -> (OVCellModelProtocol),
        objectFactory: ((Int, ()->(KeyType, ValueType)) -> ())? = nil) {
        
        self.object = object
        
        self._header = header
        self._footer = footer
        
        self.keepOne = keepOne
        self.removable = removable
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
        cellKeys = []
        
        let kp = object[keyPath: path]
        
        var row = 0
        
        // kp is an Array, because of the decalration above
        for (entryKey, entryValue) in kp {
            let cell = cellFactory(row, entryKey, entryValue)
            
            cells.append(cell)
            cellKeys.append(entryKey)
            
            row += 1
        }
    }
    
    public func getCell(_ row: Int) -> OVCellModelProtocol {
        return cells[row]
    }
    
    // Dictionary specific
    
    public func removeObject(at: Int) {
        let key = cellKeys[at]
        
        object[keyPath: path].removeValue(forKey: key)
        setupCellModels()
    }
    
    public func addObject(at: Int) {
        if objectFactory == nil {
            return
        }
        
        /*let (newKey, newValue) = objectFactory!(at, { (key, value) -> () in
            
            })
        
        object[keyPath: path][newKey] = newValue*/
        setupCellModels()
    }
}
