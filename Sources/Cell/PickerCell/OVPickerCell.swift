//
//  OVPickerCell.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 2/2/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

class OVPickerCell: UITableViewCell, OVCellProtocol, ExStyleTableViewCell {

    var darkMode: Bool = true
    
    internal var model: OVPickerCellModelProtocol!
    
    private var picker: UIPickerView!
    private var textField: UITextField!
    private var toolbar: KeyboardToolbar!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        setupColor()
        self.textLabel?.setupStyle()
        self.detailTextLabel?.setupStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(_ model: OVCellModelProtocol) {
        guard let m = model as? OVPickerCellModelProtocol else {
            fatalError("OVPickerCell: Cant cast model")
        }
        
        self.model = m
        
        setupCell()
        updateCell()
    }
    
    func update() {
        setupCell()
        updateCell()
    }
    
    private func setupCell() {
        
        self.textLabel?.text = model.title
        self.detailTextLabel?.text = model.subtitle
        
        if picker != nil && textField != nil {
            return
        }
        
        picker = UIPickerView()
        
        picker.setupStyle()
        picker.delegate = self
        
        let topBottomGap: CGFloat = 5
        let leftGap: CGFloat = self.frame.width/2.6
        let rightGap: CGFloat = 5
        
        let tfFrame = CGRect(x: leftGap,
                             y: topBottomGap,
                             width: self.frame.width-leftGap-rightGap,
                             height: self.frame.height-(topBottomGap*2))
        
        textField = UITextField(frame:  tfFrame)
        textField.setupStyle()
        textField.textAlignment = .right
        textField.inputView = picker
        
        self.accessoryView = textField
        
        setupToolbar()
    }
    
    func setupToolbar() {
        toolbar = KeyboardToolbar()
        toolbar.toolBarDelegate = self
        
        toolbar.setup(leftButtons: [], rightButtons: [.done])
        
        textField.inputAccessoryView = toolbar
    }
    
    private func updateCell() {
        let selected = model.getSelectedCase()
        
        picker.selectRow(selected, inComponent: 0, animated: false)
        textField.text = model.getCaseText(selected)
    }

}

extension OVPickerCell: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, tappedIn toolbar: KeyboardToolbar) {
        
        if type == .done {
            self.textField.resignFirstResponder()
        }
    }
}

extension OVPickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.getCaseCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.getCaseText(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        model.selectCase(row)
        textField.text = model.getCaseText(row)
    }
}
