//
//  ATTextField.swift
//  Park 'N Tap
//
//  Created by Amrit on 1/26/17.
//  Copyright © 2017 Amrit. All rights reserved.


import Foundation
import UIKit

class ATTextField: UITextField{
    
    @IBInspectable
    var leading: CGFloat = 20
    
    @IBInspectable
    var tralling: CGFloat = 20
    
    @IBInspectable
    var clearButtonColor: UIColor = .white
    
    @IBInspectable
    var cornerRadius: CGFloat = 20{
        didSet{
            self.setCornerRadius()
        }
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var leftImageColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.setCornerRadius()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = self.clearButtonColor
            }
        }
    }
    
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(cut(_:)) || action == #selector(copy(_:)) ||  action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.select(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.delete(_:)) ||  action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight(_:)) ||  action == #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft(_:)) || action == #selector(UIResponderStandardEditActions.toggleBoldface(_:)) || action == #selector(UIResponderStandardEditActions.toggleItalics(_:)) || action == #selector(UIResponderStandardEditActions.toggleUnderline(_:)) || action == #selector(UIResponderStandardEditActions.increaseSize(_:)) || action == #selector(UIResponderStandardEditActions.decreaseSize(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setCornerRadius()
    }
    
    
    func setCornerRadius(){
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let width = leftImage?.size.width ?? 40
        let leadingWith = self.leftImage != nil ? width+self.leading : self.leading
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
        //UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let width = leftImage?.size.width ?? 40
        let leadingWith = self.leftImage != nil ? width+self.leading : self.leading
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
        //UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let width = leftImage?.size.width ?? 40
        let leadingWith = self.leftImage != nil ? width+self.leading : self.leading
        self.clearButtonMode = .whileEditing
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
        //UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: leadingWith, bottom: 0, right: tralling))
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
       
        let size = bounds.size.height
        return CGRect(x: self.frame.width - size/2 - 20, y: 0, width: size, height: size)
    }
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leading
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = leftImageColor
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: leftImageColor])
    }
}

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            
            return self.placeHolderColor ?? UIColor.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }

    
    func setRightViewIcon(withicon icon: UIImage) {
        
        let width : CGFloat = 30
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        btnView.addTarget(self, action: #selector(self.showPasswordTouched(_:)), for: .touchUpInside)
        self.rightViewMode = .always
        self.rightView = btnView
        btnView.isSelected = false
        btnView.tag = 1
    }
    
    
    @objc func showPasswordTouched(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
        let selectedImageName = "eye"
        let unSelectedImageName = "eyeCross"
        let image = sender.isSelected ? selectedImageName : unSelectedImageName
        sender.setImage(UIImage(named: image), for: .normal)
    }
}
