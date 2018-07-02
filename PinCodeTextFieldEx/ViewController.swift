//
//  ViewController.swift
//  PinCodeTextFieldEx
//
//  Created by Surendra on 02/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, CodeViewDelegate {

    @IBOutlet var codeView: CodeView!
    @IBOutlet var resultLabel: UILabel!
    var textFields: [UnderlineTextField] = []
    
    func didChangePinCodeText() {
        if self.codeView.text.count == self.codeView.limit {
            print("Code is complete")
        }
        else {
            print("Code is not complete")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        codeView.delegate = self
        
        let limit = 7
        let margin: CGFloat = 15
        let spacing: CGFloat = 10
        let height: CGFloat = 50
        
        let possibleWidth: CGFloat = self.view.frame.width - (2 * margin)
        let width = (possibleWidth - (spacing * (CGFloat(limit - 1)))) / CGFloat(limit)
        
        var prevTextField: UITextField? = nil
        
        for i in 0..<limit {
            let textField = createTextField()
            textField.tag = i + 11
            textFields.append(textField)
            self.view.addSubview(textField)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            // Constraints
            let widthC = NSLayoutConstraint.constraints(withVisualFormat: "H:[textField(\(width))]", options: [], metrics: nil, views: ["textField" : textField])
            let heightC = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField(\(height))]", options: [], metrics: nil, views: ["textField" : textField])
            let topC = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[textField]", options: [], metrics: nil, views: ["textField" : textField])
            
            textField.addConstraints(widthC)
            textField.addConstraints(heightC)
            self.view.addConstraints(topC)
            
            if i == 0 {
                let leadingC = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(margin)-[textField]", options: [], metrics: nil, views: ["textField" : textField])
                self.view.addConstraints(leadingC)
            }
            else { //if i == limit - 1 {
                let leadingC = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevTextField]-\(spacing)-[textField]", options: [], metrics: nil, views: ["textField" : textField, "prevTextField": prevTextField!])
                self.view.addConstraints(leadingC)
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
    
    @IBAction func printTextAction(_ sender: Any) {
        var str = ""
        
        for i in 0..<textFields.count {
            let tf = textFields[i]
            
            if (tf.text?.isEmpty)! {
                print("Please enter full number")
                str = ""
                break
            }
            else {
                str = str + tf.text!
            }
        }
        
        resultLabel.text = str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                }
            }
            return false
        }
        return true
    }
    
}

extension ViewController: UnderlineTextFieldDelegate {
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
    }
}

