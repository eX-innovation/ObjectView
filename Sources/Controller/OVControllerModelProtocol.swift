//
//  OVControllerModelProtocol.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public protocol OVControllerModelProtocol {
    var onAppear: (()->())? { get }
    var onDisappear: (()->())? { get }
    
    var title: String { get }
    
    func updateAll()
    
    func bindView(_ updateView: @escaping (()->()))
    
    func getSectionCount() -> Int
    func getSection(_ sec: Int) -> OVSectionModelProtocol
    func getSections() -> Array<OVSectionModelProtocol>
}
