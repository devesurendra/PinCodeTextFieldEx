//
//  CodeView.swift
//  PinCodeTextFieldEx
//
//  Created by Surendra on 08/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

protocol CodeViewDelegate: class {
    func didChangePinCodeText()
}

@IBDesignable class CodeView: UIView, UITextFieldDelegate {

    var textFields: [UnderlineTextField] = []
    var delegate: CodeViewDelegate? = nil
    
    @IBInspectable var limit: Int = 7 {
        didSet {
            prepareUI()
        }
    }
    @IBInspectable var margin: CGFloat = 15 {
        didSet {
            prepareUI()
        }
    }
    @IBInspectable var spacing: CGFloat = 10 {
        didSet {
            prepareUI()
        }
    }
    
    var height: CGFloat = 50
    
    var text:String {
        set {
            
        }
        get {
            var str = ""
            
            for i in 0..<limit {
                let tf = textFields[i]
                
                if (tf.text?.isEmpty)! {
                    str = ""
                    break
                }
                else {
                    str = str + tf.text!
                }
            }
            return str
        }
    }
    
    init(frame: CGRect, limit: Int, margin: CGFloat, spacing: CGFloat) {
        self.limit = limit
        self.margin = margin
        self.spacing = spacing
        
        super.init(frame: frame)
        
        self.prepareUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func removeAllTextFields() {
        textFields.removeAll()
        for subView in self.subviews {
            if let _ = subView as? UnderlineTextField {
                subView.removeFromSuperview()
            }
        }
    }
    
    func prepareUI() {
        
        self.removeAllTextFields()
        
        let possibleWidth: CGFloat = self.frame.width - (2 * margin)
        let width = (possibleWidth - (spacing * (CGFloat(limit - 1)))) / CGFloat(limit)
        
        var prevTextField: UITextField? = nil
        
        for i in 0..<limit {
            let textField = createTextField()
            textField.tag = i + 11
            textFields.append(textField)
            self.addSubview(textField)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            // Constraints
            let widthC = NSLayoutConstraint.constraints(withVisualFormat: "H:[textField(\(width))]", options: [], metrics: nil, views: ["textField" : textField])
            let heightC = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField(\(height))]", options: [], metrics: nil, views: ["textField" : textField])
            let topC = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField]-5-|", options: [], metrics: nil, views: ["textField" : textField])
            
            textField.addConstraints(widthC)
            textField.addConstraints(heightC)
            self.addConstraints(topC)
            
            if i == 0 {
                let leadingC = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(margin)-[textField]", options: [], metrics: nil, views: ["textField" : textField])
                self.addConstraints(leadingC)
            }
            else { //if i == limit - 1 {
                let leadingC = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevTextField]-\(spacing)-[textField]", options: [], metrics: nil, views: ["textField" : textField, "prevTextField": prevTextField!])
                self.addConstraints(leadingC)
            }
            
            prevTextField = textField
        }
    }
    
    private func createTextField() -> UnderlineTextField {
        let textField = UnderlineTextField()
        textField.delegate = self
        textField.tfDelegate = self
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.textAlignment = .center
        return textField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        if textField.text!.count < 1  && string.count > 0{
            let nextTag = textField.tag + 1
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            
            if (nextResponder == nil){
                
                nextResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = string
            nextResponder?.becomeFirstResponder()
            
            self.delegate?.didChangePinCodeText()
            
            return false
        }
        else if textField.text!.count >= 1  && string.count == 0 {
            // on deleting value from Textfield
            let previousTag = textField.tag - 1
            
            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
            
            self.delegate?.didChangePinCodeText()
            
            return false
        }
        else if textField.text!.count >= 1  && string.count > 0 {
            
            let nextTag = textField.tag + 1
            
            // get next responder
            var nextResponder = textField.superview?.viewWithTag(nextTag)
            
            if (nextResponder == nil) {
                
                nextResponder = textField.superview?.viewWithTag(1)
            }
            
            if nextResponder != nil {
                
                let tf = nextResponder as! UITextField
                if (tf.text?.isEmpty)! {
                    nextResponder?.becomeFirstResponder()
                    tf.text = string
                    
                    self.delegate?.didChangePinCodeText()
                }
            }
            return false
        }
        
        return true
    }
    
}

extension CodeView: UnderlineTextFieldDelegate {
    func clearTextField(_ textField: UnderlineTextField) {
        let previousTag = textField.tag - 1
        
        // get next responder
        var previousResponder = textField.superview?.viewWithTag(previousTag)
        
        if (previousResponder == nil){
            previousResponder = textField.superview?.viewWithTag(1)
        }
        
        if previousResponder != nil {
            let tf = previousResponder as! UITextField
            tf.text = ""
        }
        
        previousResponder?.becomeFirstResponder()
        self.delegate?.didChangePinCodeText()
    }
}
