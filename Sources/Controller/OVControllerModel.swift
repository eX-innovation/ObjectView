//
//  OVControllerModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVControllerModel<ObjectType>: OVControllerModelProtocol {
    
    /// Properties
    private let _title: () -> Any
    
    public let sections: Array<OVSectionModelProtocol>
    
    public var onAppear: (()->())?
    public var onDisappear: (()->())?
    
    internal var updateView: (()->())?
    
    /// Constructor
    public init(
        _ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        sections: Array<OVSectionModelProtocol> = [],
        onAppear: (()->())? = nil,
        onDisappear: (()->())? = nil) {
        
        self._title = title
        
        self.sections = sections
        
        self.onAppear = onAppear
        self.onDisappear = onDisappear
    }
    
    /// Computed properties
    public var title: String {
        return "\(_title())"
    }
    
    /// Methods
    public func updateAll() {
        
        updateView?()
        
        for section in sections {
            section.updateAll()
        }
    }
    
    public func bindView(_ updateView: @escaping (()->())) {
        self.updateView = updateView
    }
    
    public func getSectionCount() -> Int {
        return sections.count
    }
    
    public func getSection(_ sec: Int) -> OVSectionModelProtocol {
        return sections[sec]
    }
    
    public func getSections() -> Array<OVSectionModelProtocol> {
        return sections
    }
    
}
