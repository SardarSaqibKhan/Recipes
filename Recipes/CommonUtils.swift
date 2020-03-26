//
//  CommonUtils.swift
//  App
//
//  Created by Pramod on 01/04/19.
//  Copyright © 2019 Pramod. All rights reserved.
//

import Foundation
import UIKit

class CommonUtils : NSObject
{
    class func hasTopNotch() -> Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }
        else{
            if #available(iOS 11.0, *) {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
            }
        }

        return false
    }
    
    // MARK: - Color
    class func colorWith(r: Float, g: Float, b: Float) -> UIColor{
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
    }
    
    class func generateGradientColor(colors: [UIColor], angle: Float = 0, bounds: CGRect) -> CALayer {
        let gradientLayerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: bounds.width, height: bounds.height))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = colors.map { $0.cgColor }
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        return gradientLayerView.layer
        //        layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    //MARK: - Image
    class func imageFrom(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        if let aContext = UIGraphicsGetCurrentContext() {
            layer.render(in: aContext)
        }
        
        let outputImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
}



//MARK: - UIView
extension UIView {
    func addGradient(colors: [UIColor], angle: Float = 0, frame: CGRect? = nil, onBottom : Bool = true){
        var newFrame = CGRect.zero
        if frame == nil{
            newFrame = self.bounds
        }
        else{
            newFrame = frame!
        }
        
        let layer = CommonUtils.generateGradientColor(colors: colors, angle: angle, bounds: newFrame)
        
        if onBottom{
            self.layer.insertSublayer(layer, at: 0)
        }
        else{
            self.layer.addSublayer(layer)
        }
    }

    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable var gredient: Bool {
        get {
            return false
        }
        set {
            if newValue == true {
                self.addGradient(colors: [ThemeColor, GredientLightColor], angle: 135)
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = CommonUtils.colorWith(r: 150, g: 150, b: 150).cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0),
                   shadowOpacity: Float = 0.50,
                   shadowRadius: CGFloat = 2.0) {
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

//MARK: - NavigationBar
extension UINavigationBar {
    func addGradientNavigationBar(colors: [UIColor],
                     angle: Float = 0) {
        
        var gradientFrame = self.bounds
        gradientFrame.size.height += UIApplication.shared.statusBarFrame.size.height
        
        let image = CommonUtils.imageFrom(layer: CommonUtils.generateGradientColor(colors: colors, angle: angle, bounds: gradientFrame))
        self.setBackgroundImage(image, for: .default)
        
    }
}
