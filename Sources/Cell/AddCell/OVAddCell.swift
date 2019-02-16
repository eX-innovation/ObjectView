//
//  OVAddCell.swift
//  RoomCtrlApp3
//
//  Created by Michael Mayerhofer on 2/15/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

class OVAddCell: UITableViewCell, ExStyleTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        textLabel?.text = "Add Object"
        
        setupColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
