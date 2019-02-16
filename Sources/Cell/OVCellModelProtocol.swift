//
//  OVCellModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation
import UIKit

public protocol OVCellModelProtocol {
    var title: String { get }
    var subtitle: String { get }
    
    var cellType: OVCellType { get }
}
