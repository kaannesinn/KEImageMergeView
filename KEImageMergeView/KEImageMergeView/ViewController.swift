//
//  ViewController.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import UIKit
import Kingfisher
import Loaf

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
        let overlayedImage = AppUtils.applyOverlayImage(view: self.viewForMerge)
        
        let alert = UIAlertController(title: "", message: StaticKeys.Texts.WhereToSaveImage, preferredStyle: .actionSheet)
        let pngSaveAction = UIAlertAction(title: StaticKeys.Texts.PNG_Disk, style: .default) { (action) in
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("overlayedImage_\(self.selectedCellIndex).png") else { return }
            guard let data = overlayedImage?.pngData() else { return }
            do {
                try data.write(to: url)
                Loaf("\(StaticKeys.Success.SaveImage) \("overlayedImage_\(self.selectedCellIndex).png")", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
            catch {
                Loaf(StaticKeys.Error.SaveImage, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
        let jpegSaveAction = UIAlertAction(title: StaticKeys.Texts.JPEG_Disk, style: .default) { (action) in
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("overlayedImage_\(self.selectedCellIndex).jpeg") else { return }
            guard let data = overlayedImage?.jpegData(compressionQuality: 0.7) else { return }
            do {
                try data.write(to: url)
                Loaf("\(StaticKeys.Success.SaveImage) \("overlayedImage_\(self.selectedCellIndex).jpeg")", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
            catch {
                Loaf(StaticKeys.Error.SaveImage, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
        let pngUserDefSaveAction = UIAlertAction(title: StaticKeys.Texts.PNG_User_Def, style: .default) { (action) in
            guard let data = overlayedImage?.pngData() else { return }
            AppUtils.shared.setObject(key: "\(StaticKeys.UserDefaults.PNG_Save)_\(self.selectedCellIndex)", value: data)
            Loaf("\(StaticKeys.Success.SaveImage)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            
            guard let imgData = AppUtils.shared.getObject(key: "\(StaticKeys.UserDefaults.PNG_Save)_\(self.selectedCellIndex)") as? Data else { return }
            guard let img = UIImage(data: imgData) else { return }
            debugPrint(img)
        }
        let jpegUserDefSaveAction = UIAlertAction(title: StaticKeys.Texts.JPEG_User_Def, style: .default) { (action) in
            guard let data = overlayedImage?.jpegData(compressionQuality: 0.7) else { return }
            AppUtils.shared.setObject(key: "\(StaticKeys.UserDefaults.JPEG_Save)_\(self.selectedCellIndex)", value: data)
            Loaf("\(StaticKeys.Success.SaveImage)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            
            guard let imgData = AppUtils.shared.getObject(key: "\(StaticKeys.UserDefaults.JPEG_Save)_\(self.selectedCellIndex)") as? Data else { return }
            guard let img = UIImage(data: imgData) else { return }
            debugPrint(img)
        }
        let pngSaveActionWithSizeReduce = UIAlertAction(title: StaticKeys.Texts.PNG_Resized_Disk, style: .destructive) { (action) in
            let resizedImg = AppUtils.resizeImage(originalImage: overlayedImage!,
                                                  size: CGSize(width: 600,
                                                               height: 600*(overlayedImage?.size.height)!/(overlayedImage?.size.width)!))

            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("overlayedImage_resized_\(self.selectedCellIndex).png") else { return }
            guard let data = resizedImg?.pngData() else { return }
            do {
                try data.write(to: url)
                Loaf("\(StaticKeys.Success.SaveImage) \("overlayedImage_resized_\(self.selectedCellIndex).png")", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
            catch {
                Loaf(StaticKeys.Error.SaveImage, state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
        let pngUserDefSaveActionWithSizeReduce = UIAlertAction(title: StaticKeys.Texts.PNG_Resized_User_Def, style: .destructive) { (action) in
            guard let data = overlayedImage?.pngData() else { return }
            AppUtils.shared.setObject(key: "\(StaticKeys.UserDefaults.PNG_Resized_Save)_\(self.selectedCellIndex)", value: data)
            Loaf("\(StaticKeys.Success.SaveImage)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            
            guard let imgData = AppUtils.shared.getObject(key: "\(StaticKeys.UserDefaults.PNG_Resized_Save)_\(self.selectedCellIndex)") as? Data else { return }
            guard let img = UIImage(data: imgData) else { return }
            debugPrint(img)
        }
        
        let cancelAction = UIAlertAction(title: StaticKeys.Texts.Cancel, style: .cancel)
        alert.addAction(pngSaveAction)
        alert.addAction(jpegSaveAction)
        alert.addAction(pngUserDefSaveAction)
        alert.addAction(jpegUserDefSaveAction)
        alert.addAction(pngSaveActionWithSizeReduce)
        alert.addAction(pngUserDefSaveActionWithSizeReduce)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
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
