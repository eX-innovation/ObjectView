//
//  OVSwitchCell.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

internal class OVSwitchCell: UITableViewCell, OVCellProtocol, ExStyleTableViewCell {
    
    var darkMode: Bool = true
    
    internal var model: OVSwitchCellModelProtocol!
    
    private var switchView: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupColor()
        textLabel?.setupStyle()
        detailTextLabel?.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(_ model: OVCellModelProtocol) {
        guard let m = model as? OVSwitchCellModelProtocol else {
            fatalError("OVSwitchCell: Cant cast model")
        }
        
        self.model = m
        self.model.connectedCell = self
        
        setupCell()
        updateCell()
    }
    
    func update() {
        setupCell()
        updateCell()
    }
    
    private func setupCell() {
        self.selectionStyle = .none
        
        self.textLabel?.text = model.title
        self.detailTextLabel?.text = model.subtitle
        
        //self.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        //self.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        
        if switchView != nil {
            return
        }
        
        switchView = UISwitch(frame: .zero)
        switchView.addTarget(self, action: #selector(switchDidChange(sender:)), for: .valueChanged)
        
        self.accessoryView = switchView
    }
    
    private func updateCell() {
        switchView.setOn(model.value, animated: true)
    }
    
    @objc func switchDidChange(sender: UISwitch) {
        model.value = sender.isOn
    }
}
