//
//  UnderlineTextField.swift
//  PinCodeTextFieldEx
//
//  Created by Surendra on 02/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

protocol UnderlineTextFieldDelegate: class {
    func clearTextField(_ textField: UnderlineTextField)
}

class UnderlineTextField: UITextField {

    let border = CALayer()
    var tfDelegate: UnderlineTextFieldDelegate? = nil
    
    @IBInspectable var borderColor: UIColor = .darkGray {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            setup()
        }
    }
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setup() {
        border.borderColor = self.borderColor.cgColor
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: self.frame.size.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return editingRect(forBounds: bounds)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        print("Delete click")
        self.tfDelegate?.clearTextField(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
