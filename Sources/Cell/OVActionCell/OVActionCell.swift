//
//  OVActionCell.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/4/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

class OVActionCell: UITableViewCell, OVCellProtocol, ExStyleTableViewCell {
    
    var darkMode: Bool = true
    
    internal var model: OVActionCellModelProtocol!
    
    private var label: UILabel!
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        accessoryView = nil
        
        setupColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    self.showSpinner()
                }
                
                self.model.action()
                
                DispatchQueue.main.async {
                    self.hideSpinner()
                }
            }
        }
    }
    
    func setup(_ model: OVCellModelProtocol) {
        guard let m = model as? OVActionCellModelProtocol else {
            fatalError("OVActionCell: Cant cast model")
        }
        
        self.model = m
        
        setupCell()
    }
    
    func update() {
        setupCell()
    }
    
    private func showSpinner() {
        
        label.isHidden = true
        
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
            
            activityIndicatorView.frame = self.bounds
        }
        
        activityIndicatorView.startAnimating()
        
        addSubview(activityIndicatorView)
    }
    
    private func hideSpinner() {
        
        label.isHidden = false
        
        activityIndicatorView.removeFromSuperview()
        
        activityIndicatorView.stopAnimating()
    }
    
    private func setupCell() {
        self.accessoryType = .none
        
        if label != nil {
            return
        }
        
        label = UILabel(frame: self.bounds)
        label.setupStyle()
        
        self.addSubview(label)
        
        label.textAlignment = .center
        label.textColor = UIColor.systemBlue
        //label.backgroundColor = .lightGray
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 18)
        label.text = model.title
    }
}
