//
//  OVTextFieldCell.swift
//  ObjectView2
//
//  Created by Michael Mayerhofer on 1/28/19.
//  Copyright © 2019 Michael Mayerhofer. All rights reserved.
//

import UIKit

internal class OVTextFieldCell: UITableViewCell, OVCellProtocol, ExStyleTableViewCell {

    var darkMode: Bool = true
    
    internal var model: OVValueCellModelProtocol!
    
    private var textField: UITextField!
    private var toolbar: KeyboardToolbar!
    private var pickerView: UIPickerView?
    
    private var isPickerInput: Bool = false
    
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
        guard let m = model as? OVValueCellModelProtocol else {
            fatalError("OVvalueCell: Cant cast model")
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
        
        if textField != nil {
            return
        }
        
        setupTextField()
        setupToolbar()
        setupPickerView()
    }
    
    func setupTextField() {
        let topBottomGap: CGFloat = 5
        let leftGap: CGFloat = self.frame.width/2.6
        let rightGap: CGFloat = 5
        
        let tfFrame = CGRect(x: leftGap,
                             y: topBottomGap,
                             width: self.frame.width-leftGap-rightGap,
                             height: self.frame.height-(topBottomGap*2))
        
        textField = UITextField(frame:  tfFrame)
        textField.setupStyle()
        //textField.backgroundColor = .lightGray
        textField.textAlignment = .right
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        textField.keyboardType = model.keyboardType
        
        self.accessoryView = textField
    }
    
    func setupPickerView() {
        if model.pickerValues == nil {
            return
        }
        
        pickerView = UIPickerView()
        
        pickerView!.setupStyle()
        pickerView!.delegate = self
        
        textField.inputView = pickerView!
        isPickerInput = true
        
    }
    
    func setupToolbar() {
        toolbar = KeyboardToolbar()
        toolbar.toolBarDelegate = self
        
        var leftButtons: [KeyboardToolbarButton] = []
        
        if model.pickerValues != nil && model.allowCustomInput {
            leftButtons.append(.predefined)
        }
        
        if model.keyboardType == .numberPad ||
           model.keyboardType == .decimalPad {
            leftButtons.append(.minus)
        }
        
        toolbar.setup(leftButtons: leftButtons, rightButtons: [.done])
        
        textField.inputAccessoryView = toolbar
    }
    
    private func updateCell() {
        textField.text = model.value
        
        pickerView?.reloadAllComponents()
    }
    
    private func pickerInputToggle() {
        if model.pickerValues == nil {
            return
        }
        
        if isPickerInput {
            textField.inputView = nil
            textField.reloadInputViews()
            isPickerInput = false
        } else {
            textField.inputView = pickerView!
            textField.reloadInputViews()
            isPickerInput = true
        }
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        model.value = sender.text ?? "Error"
    }
    
}

extension OVTextFieldCell: KeyboardToolbarDelegate {
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, tappedIn toolbar: KeyboardToolbar) {
        
        if type == .predefined {
            pickerInputToggle()
        } else if type == .done {
            self.textField.resignFirstResponder()
        } else if type == .minus {
            if self.textField.text!.contains("-") {
                self.textField.text! = self.textField.text!.replacingOccurrences(of: "-", with: "")
            } else {
                self.textField.text! = "-" + self.textField.text!
            }
        }
    }
}

extension OVTextFieldCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.pickerValues!().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.pickerValues!()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let val = model.pickerValues!()[row]
        self.textField.text = val
        model.value = val
    }
}
