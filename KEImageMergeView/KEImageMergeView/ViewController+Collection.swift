//
//  ViewController+Collection.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import Foundation
import UIKit
import Loaf

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
        if indexPath.row == 0 {
            self.imgFront.image = nil
        }
        else {
            self.imgFront.transform = .identity
            self.imgFront.frame = CGRect(x: 0, y: 0, width: self.imgFront.frame.width, height: self.imgFront.frame.height)
            
            let item = self.overlays?[indexPath.row-1]
            guard let overlayURL = item?.overlayURL else { return }
            
            self.imgFront.kf.setImage(with: URL(string: overlayURL)) { result in
                switch result {
                case .success(let value):
                    self.imgFront.image = value.image
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    Loaf("\(StaticKeys.Error.NoFrontImage)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                }
            }
        }
    }
    
}
