//
//  OVController.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

class OVController: UITableViewController, ExStyleTableViewController {
    
    var darkMode: Bool = true
    
    public let model: OVControllerModelProtocol
    
    private var loadingForwardModel: Bool = false
    
    init(_ model: OVControllerModelProtocol) {
        self.model = model
        
        super.init(style: .grouped)
        
        self.tableView.register(OVTextFieldCell.self, forCellReuseIdentifier: OVCellType.TextFieldCell.rawValue)
        self.tableView.register(OVSwitchCell.self, forCellReuseIdentifier: OVCellType.SwitchCell.rawValue)
        self.tableView.register(OVForwardCell.self, forCellReuseIdentifier: OVCellType.ForwardCell.rawValue)
        self.tableView.register(OVPickerCell.self, forCellReuseIdentifier: OVCellType.PickerCell.rawValue)
        self.tableView.register(OVActionCell.self, forCellReuseIdentifier: OVCellType.ActionCell.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        
        var showEditButton: Bool = false
        
        for section in model.getSections() {
            if section.getSectionType() == .Array {
                if section.removable || section.movable {
                    showEditButton = true
                }
            }
        }
        
        if showEditButton {
            self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        setupColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationItem.title = self.model.title
        
        model.onAppear?()
        
        setTitle(self.model.title)
        
        for cell in tableView.visibleCells {
            guard let castedCell = cell as? OVCellProtocol else {
                continue
            }
            
            castedCell.update()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        model.onDisappear?()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.getSection(section).getHeader()
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return model.getSection(section).getFooter()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.getSectionCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = model.getSection(section)
        let addRow = section.addable ? 1 : 0
        return section.getCellCount() + addRow
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = model.getSection(indexPath.section)
        
        if indexPath.row >= section.getCellCount() {
            // 'Add' Row
            return true
        }
        
        return section.removable
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let section = model.getSection(indexPath.section)
        
        if indexPath.row >= section.getCellCount() {
            // 'Add' Row
            return false
        }
        
        return section.movable
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = model.getSection(indexPath.section)
        
        // 'Add' Cell
        if indexPath.row >= section.getCellCount() {
            return OVAddCell()
        }
        
        let cellModel = section.getCell(indexPath.row)
        
        let uncastedCell = tableView.dequeueReusableCell(withIdentifier: cellModel.cellType.rawValue,
                                                         for: indexPath)
        
        guard let cell = uncastedCell as? OVCellProtocol else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error1-WrongType"
            return cell
        }
        
        cell.setup(cellModel)
        
        guard let castedCell = cell as? UITableViewCell else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Error2-NotACell"
            return cell
        }
        
        return castedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if loadingForwardModel {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let section = model.getSection(indexPath.section)
        
        if indexPath.row >= section.getCellCount() {
            // Add a Row
            section.addObject(at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .fade)
        }
        
        let cellModel = section.getCell(indexPath.row)
        
        if (cellModel.cellType == .ForwardCell) {
            guard let castedModel = cellModel as? OVForwardCellModelProtocol else {
                return
            }
            
            if castedModel.enableLoading {
                // Model for controller needs to load
                
                // Block other Forward cells
                self.loadingForwardModel = true
                
                // Deselct...
                tableView.deselectRow(at: indexPath, animated: true)
                
                DispatchQueue.global(qos: .userInteractive).async {
                    let vc = OVController(castedModel.controller)
                    
                    DispatchQueue.main.async {
                        self.loadingForwardModel = false
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                // Model for controller can build instant
                let vc = OVController(castedModel.controller)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Move
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        model.getSection(fromIndexPath.section).moveObject(from: fromIndexPath.row, to: to.row)
    }
    
    // Make sure row stays in section
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt
        sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let sourceSection = sourceIndexPath.section
        let destSection = proposedDestinationIndexPath.section
        
        if destSection < sourceSection {
            return IndexPath(row: 0, section: sourceSection)
        } else if destSection > sourceSection {
            return IndexPath(row: self.tableView(tableView, numberOfRowsInSection:sourceSection)-1, section: sourceSection)
        }
        /*
        let sourceRow = proposedDestinationIndexPath.row
        let destRow = sourceIndexPath.row
        let section = model.getSection(destSection)
        let hasAddRow = section.addable
        
        if (hasAddRow && destRow >= section.getCellCount()) {
            return IndexPath(row: self.tableView(tableView, numberOfRowsInSection:sourceSection)-2, section: sourceSection)
        }*/
        
        return proposedDestinationIndexPath
    }
    
    // Remove / Add
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let section = model.getSection(indexPath.section)
        
        if editingStyle == .delete {
            if section.getCellCount() == 1 && section.keepOne {
                return
            }
            
            // Delete the row from the data source
            section.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            section.addObject(at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Remove / Add
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCell.EditingStyle {
            
        if indexPath.row >= model.getSection(indexPath.section).getCellCount() {
            return .insert
        } else {
            return .delete
        }
    }
}
