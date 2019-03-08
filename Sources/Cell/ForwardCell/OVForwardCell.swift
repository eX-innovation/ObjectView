//
//  OVForwardCell.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

class OVForwardCell: UITableViewCell, OVCellProtocol, ExStyleTableViewCell {

    var darkMode: Bool = true
    
    internal var model: OVForwardCellModelProtocol!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupColor()
        self.textLabel?.setupStyle()
        self.detailTextLabel?.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(_ model: OVCellModelProtocol) {
        guard let m = model as? OVForwardCellModelProtocol else {
            fatalError("OVForwardCell: Cant cast model")
        }
        
        self.model = m
        self.model.connectedCell = self
        
        self.model.statusUpdate = { [weak self] title, subtitle, spinner in
            guard let s = self else {
                return
            }
            
            DispatchQueue.main.async {
                if spinner {
                    s.showSpinner(title, subtitle: subtitle)
                } else {
                    s.hideSpinner()
                }
            }
        }
        
        setupCell()
    }
    
    func update() {
        setupCell()
    }
    
    private func showSpinner(_ title: String?, subtitle: String?) {
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(style: .white)
        }
        
        self.activityIndicatorView.startAnimating()
        
        self.accessoryType = .none
        self.accessoryView = activityIndicatorView
        
        self.textLabel?.text = title ?? model.title
        self.detailTextLabel?.text = subtitle ?? model.subtitle
    }
    
    private func hideSpinner() {
        self.activityIndicatorView.removeFromSuperview()
        self.accessoryView = nil
        
        self.activityIndicatorView.stopAnimating()
        
        setupCell()
    }
    
    private func setupCell() {
        
        self.textLabel?.text = model.title
        self.detailTextLabel?.text = model.subtitle
        
        self.accessoryType = .disclosureIndicator
    }
}
