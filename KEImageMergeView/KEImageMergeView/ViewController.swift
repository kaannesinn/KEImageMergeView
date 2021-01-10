//
//  ViewController.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var viewForMerge: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgFront: UIImageView!
    @IBOutlet weak var viewForOverlays: UIView!
    @IBOutlet weak var collectionOverlay: UICollectionView!
    var overlays: OverlayModel? = nil
    var selectedCellIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgBack.kf.setImage(with: URL(string: "https://images2.alphacoders.com/284/thumb-1920-284142.jpg"))
        
        self.addGestureRecognizers()
        
        APIManager.shared.fetchOverlays(sender: self) { (overlayModel) in
            guard let overlayModel = overlayModel else { return }
            debugPrint(overlayModel)
            self.overlays = overlayModel
            self.collectionOverlay.reloadData()
        }
    }

    @IBAction func saveTouched(_ sender: Any) {
    
    func addGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.canvasPanGesture(recognizer:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.canvasPinchGesture(recognizer:)))
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.canvasRotateGesture(recognizer:)))
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotateGesture.delegate = self
        self.imgFront.addGestureRecognizer(panGesture)
        self.imgFront.addGestureRecognizer(pinchGesture)
        self.imgFront.addGestureRecognizer(rotateGesture)
        self.imgFront.isUserInteractionEnabled = true
    }

}
