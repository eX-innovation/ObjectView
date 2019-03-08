//
//  OVSectionModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public protocol OVSectionModelProtocol {
    
    var sectionType: OVSectionType { get }
    
    var header: String? { get }
    var footer: String? { get }
    
    var cellCount: Int { get }
    
    func getCell(_ row: Int) -> OVCellModelProtocol
    
    func updateAll()
    
    // Array Specific
    // ----------------------------
    
    var movable: Bool { get }
    var removable: Bool { get }
    var keepOne: Bool { get }
    var addable: Bool { get }
    
    // Move object in Array
    func moveObject(from: Int, to: Int)
    func removeObject(at: Int)
    func addObject(at: Int)
}

extension OVSectionModelProtocol {
    
    public var movable: Bool { return false }
    public var removable: Bool { return false }
    public var keepOne: Bool { return false }
    public var addable: Bool { return false }
    
    public func moveObject(from: Int, to: Int) { }
    public func removeObject(at: Int) {}
    public func addObject(at: Int) {}
}
