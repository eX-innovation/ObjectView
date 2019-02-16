//
//  OVSectionModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public protocol OVSectionModelProtocol {
    
    func getSectionType() -> OVSectionType
    
    func getCellCount() -> Int
    func getCell(_ row: Int) -> OVCellModelProtocol
    
    func getHeader() -> String?
    func getFooter() -> String?
    
    func update()
    
    // Array Specific
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
    public func moveObject(from: Int, to: Int) { }
    public func removeObject(at: Int) {}
    public func addObject(at: Int) {}
}
