//
//  OVEnum.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import Foundation

public enum OVSectionType {
    case Object
    case Array
    case Dictionary
}

public enum OVCellType: String {
    case TextFieldCell
    case SwitchCell
    case ForwardCell
    case PickerCell
    case ActionCell
}


extension Array {
    mutating func move(from sourceIndex: Int, to destinationIndex: Int) {
        guard
            sourceIndex != destinationIndex
                && Swift.min(sourceIndex, destinationIndex) >= 0
                && Swift.max(sourceIndex, destinationIndex) < count
            else {
                return
        }
        
        let direction = sourceIndex < destinationIndex ? 1 : -1
        var sourceIndex = sourceIndex
        
        repeat {
            let nextSourceIndex = sourceIndex + direction
            swapAt(sourceIndex, nextSourceIndex)
            sourceIndex = nextSourceIndex
        }
            while sourceIndex != destinationIndex
    }
}

protocol KeyPathSelfProtocol {}
extension KeyPathSelfProtocol {
    var keyPathSelf: Self {
        get { return self }
        set { self = newValue }
    }
}

extension String : KeyPathSelfProtocol {}

#if !canImport(Essential)

// Theme Management

/*

public protocol ExStyleTableViewCell {
 
    func setupColor()
}

public extension ExStyleTableViewCell where Self: UITableViewCell {
    func setupColor() {
        // ...
    }
}

public protocol ExStyleTableViewController {
    
    func setTitle(_ title: String)
    func setupColor()
    func dynamicRowHeight()
    func removeFooterLines()
}

public extension ExStyleTableViewController where Self: UITableViewController {
    func setupColor() {
        // ...
    }
    
    func removeFooterLines() {
        tableView.tableFooterView = UIView()
    }
    
    func setTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func dynamicRowHeight() {
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    }
}

 */
#endif
