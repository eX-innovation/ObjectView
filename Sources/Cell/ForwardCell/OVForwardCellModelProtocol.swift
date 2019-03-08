//
//  OVForwardCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

internal protocol OVForwardCellModelProtocol: OVCellModelProtocol {
    
    var controller: OVControllerModelProtocol { get }
    
    var statusUpdate: ((_ title: String?, _ subtitle: String?, _ spinner: Bool)->())? { get set }
    
    var enableLoading: Bool { get }
    
}

extension OVForwardCellModelProtocol {
    var enableLoading: Bool {
        get {
            return false
        }
    }
    
    var statusUpdate: ((_ title: String?, _ subtitle: String?, _ spinner: Bool)->())? {
        get {
            return nil
        }
        set {
            
        }
    }
}
