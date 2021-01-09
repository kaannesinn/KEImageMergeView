//
//  ViewController.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import UIKit
import Kingfisher

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.overlays?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverlayCell", for: indexPath) as! OverlayCell
        cell.tag = indexPath.row
        
        cell.imgCell.layer.masksToBounds = true
        cell.imgCell.layer.cornerRadius = 10
        cell.imgCell.layer.borderWidth = 3
        
        if indexPath.row == 0 {
            cell.imgCell.image = #imageLiteral(resourceName: "noImage")
            cell.lblCell.text = StaticKeys.Texts.None
        }
        else {
            let item = self.overlays?[indexPath.row-1]
            cell.item = item
            if let overlayPreviewIconURL = item?.overlayPreviewIconURL {
                cell.lblCell.text = item?.overlayName
                cell.imgCell.kf.setImage(with: URL(string: overlayPreviewIconURL))
            }
        }
        
        if indexPath.row == self.selectedCellIndex {
            cell.imgCell.layer.borderColor = UIColor(named: "RGB_87_163_215")?.cgColor
            cell.lblCell.textColor = UIColor(named: "RGB_87_163_215")
        }
        else {
            cell.imgCell.layer.borderColor = UIColor.clear.cgColor
            cell.lblCell.textColor = UIColor(named: "RGB_81_80_80")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellIndex = indexPath.row
        let offset = collectionView.contentOffset
        self.collectionOverlay.reloadData()
        self.collectionOverlay.layoutIfNeeded()
        self.collectionOverlay.contentOffset = offset
    }

    @IBOutlet weak var viewForMerge: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var viewForOverlays: UIView!
    @IBOutlet weak var collectionOverlay: UICollectionView!
    var overlays: OverlayModel? = nil
    var selectedCellIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgBack.kf.setImage(with: URL(string: "https://images2.alphacoders.com/284/thumb-1920-284142.jpg"))
        
        APIManager.shared.fetchOverlays(sender: self) { (overlayModel) in
            guard let overlayModel = overlayModel else { return }
            debugPrint(overlayModel)
            self.overlays = overlayModel
            self.collectionOverlay.reloadData()
        }
    }

    @IBAction func saveTouched(_ sender: Any) {
    
    }

}
