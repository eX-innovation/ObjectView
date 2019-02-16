//
//  OVControllerModel.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public class OVControllerModel<ObjectType>: OVControllerModelProtocol {
    
    //public let object: ObjectType
    
    //private let placeholderResolver: OVResolvePlaceholder<ObjectType>
    
    public let _title: () -> Any
    public var title: String {
        //return placeholderResolver.resolve("\(_title())")
        return "\(_title())"
    }
    
    public let sections: Array<OVSectionModelProtocol>
    
    public var onAppear: (()->())?
    public var onDisappear: (()->())?
    
    public init(
        _ object: ObjectType,
        _ title: @escaping @autoclosure () -> Any,
        //placeholder: Dictionary<String, PartialKeyPath<ObjectType>> = [:],
        sections: Array<OVSectionModelProtocol> = [],
        onAppear: (()->())? = nil,
        onDisappear: (()->())? = nil) {
        
        //self.object = object
        
        //self.placeholderResolver = OVResolvePlaceholder(placeholder, object)
        self._title = title
        
        self.sections = sections
        
        self.onAppear = onAppear
        self.onDisappear = onDisappear
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
