//
//  OverlayCell.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit

class OverlayCell: UICollectionViewCell {
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblCell: UILabel!
    var item: OverlayModelElement? = nil
}
