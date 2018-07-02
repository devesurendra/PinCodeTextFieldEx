//
//  PinCodeView.swift
//  PinCodeTextFieldEx
//
//  Created by Surendra on 02/02/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class PinCodeView: UIView, UITextFieldDelegate {

    //MARK: Customizable from Interface Builder
    @IBInspectable public var underlineWidth: CGFloat = 40
    @IBInspectable public var underlineHSpacing: CGFloat = 10
    @IBInspectable public var underlineVMargin: CGFloat = 0
    @IBInspectable public var characterLimit: Int = 5
    @IBInspectable public var underlineHeight: CGFloat = 3
    
    @IBInspectable public var textColor: UIColor = UIColor.clear
    @IBInspectable public var placeholderColor: UIColor = UIColor.lightGray
    @IBInspectable public var underlineColor: UIColor = UIColor.darkGray
    @IBInspectable public var updatedUnderlineColor: UIColor = UIColor.clear
    
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    //MARK: Init and awake
    override init(frame: CGRect) {
        super.init(frame: frame)
        postInitialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        postInitialize()
    }
    
    override public func prepareForInterfaceBuilder() {
        postInitialize()
    }
    
    private func postInitialize() {
        setNeedsLayout()
        //updateView()
    }
    
    override public func layoutSubviews() {
        layoutCharactersAndPlaceholders()
        super.layoutSubviews()
    }
    
    private func layoutCharactersAndPlaceholders() {
        let marginsCount = characterLimit - 1
        let totalMarginsWidth = underlineHSpacing * CGFloat(marginsCount)
        let totalUnderlinesWidth = underlineWidth * CGFloat(characterLimit)
        
        var currentUnderlineX: CGFloat = bounds.width / 2 - (totalUnderlinesWidth + totalMarginsWidth) / 2
        var currentLabelCenterX = currentUnderlineX + underlineWidth / 2
        
        let totalLabelHeight = font.ascender + font.descender
        let underlineY = bounds.height / 2 + totalLabelHeight / 2 + underlineVMargin
        
        underlines.forEach{
            $0.frame = CGRect(x: currentUnderlineX, y: underlineY, width: underlineWidth, height: underlineHeight)
            currentUnderlineX += underlineWidth + underlineHSpacing
        }
        
        
    }
    
    
    fileprivate var underlines: [UITextField] = []
    
    private func recreateUnderlines() {
        underlines.forEach{ $0.removeFromSuperview() }
        underlines.removeAll()
        
        var tag = 11
        characterLimit.times {
            let underline = createUnderline()
            underline.tag = tag
            underlines.append(underline)
            addSubview(underline)
            
            tag += 1
        }
        
    }
    
    private func createUnderline() -> UITextField {
        let underline = UITextField()
        underline.delegate = self
        underline.backgroundColor = underlineColor
        return underline
    }
    
    
    
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
        else if textField.text!.count >= 1  && string.count == 0{
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
        return true
        
    }
    
}

internal extension Int {
    func times(f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
    func times( f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}
