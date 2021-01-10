//
//  AppUtils.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit

class AppUtils: NSObject {
    static let shared = AppUtils()
    
    func setObject(key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func addImageToImage(background: UIImage, foreground: UIImage, foregroundImageRect: CGRect, finalImageWidth: CGFloat, finalImageHeight: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: finalImageWidth, height: finalImageHeight))
        background.draw(at: CGPoint(x: 0, y: 0))
        foreground.draw(at: foregroundImageRect.origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    static func resizeImage(originalImage: UIImage, size: CGSize) -> UIImage? {
        let destinationSize = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContext(destinationSize)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: destinationSize.width, height: destinationSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func mixImagesByBlending(background: UIImage, foreground: UIImage, backgroundRect: CGRect, foregroundRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(backgroundRect.size)
        background.draw(in: backgroundRect)
        foreground.draw(in: foregroundRect, blendMode: .normal, alpha: 0.5)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageFromView(view: UIView) -> UIImage? {
        var imageSize = CGSize.zero
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation == .portrait {
            imageSize = UIScreen.main.bounds.size
        }
        else {
            imageSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        for window in UIApplication.shared.windows {
            context.saveGState()
            context.translateBy(x: window.center.x, y: window.center.y)
            context.concatenate(window.transform)
            context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            if orientation == .landscapeLeft {
                context.rotate(by: CGFloat(Double.pi/2))
                context.translateBy(x: 0, y: -imageSize.width)
            } else if orientation == .landscapeRight {
                context.rotate(by: CGFloat(-Double.pi/2))
                context.translateBy(x: -imageSize.height, y: 0)
            } else if orientation == .portraitUpsideDown {
                context.rotate(by: CGFloat(Double.pi))
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            
            window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            
            context.restoreGState()
        }
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    static func applyOverlayImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
