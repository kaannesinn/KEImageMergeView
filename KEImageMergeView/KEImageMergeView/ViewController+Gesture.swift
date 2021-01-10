//
//  ViewController+Gesture.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import Foundation
import UIKit

extension ViewController: UIGestureRecognizerDelegate {
    @objc func canvasPanGesture(recognizer: UIPanGestureRecognizer) {
        if let view = recognizer.view {
            let translation = recognizer.translation(in: view.superview)

            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            
            if view.center.x <= 0 && view.center.y <= 0 {
                view.center = CGPoint(x: 0, y: 0)
            }
            else if view.center.x <= 0 && view.center.y > 0 {
                view.center = CGPoint(x: 0, y: view.center.y)
            }
            else if view.center.x > 0 && view.center.y <= 0 {
                view.center = CGPoint(x: view.center.x, y: 0)
            }
            
            if view.center.x >= self.imgFront.frame.width && view.center.y >= self.imgFront.frame.height {
                view.center = CGPoint(x: self.imgFront.frame.width, y: self.imgFront.frame.height)
            }
            else if view.center.x >= self.imgFront.frame.width && view.center.y < self.imgFront.frame.height {
                view.center = CGPoint(x: self.imgFront.frame.width, y: view.center.y)
            }
            else if view.center.x < self.imgFront.frame.width && view.center.y >= self.imgFront.frame.height {
                view.center = CGPoint(x: view.center.x, y: self.imgFront.frame.height)
            }
            
            recognizer.setTranslation(.zero, in: self.imgFront)
        }
    }
    
    @objc func canvasPinchGesture(recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @objc func canvasRotateGesture(recognizer: UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
