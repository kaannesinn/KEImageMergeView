//
//  MergingView.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 10.01.2021.
//

import UIKit

class MergingView: UIView {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var imgFront: UIImageView!
    
    func showHistogram(image: UIImage) -> UIImage? {
        guard let dataImage = TTMHistogramHelper.computeHistogram(for: image, count: 64) else { return nil }
        guard let outImage = TTMHistogramHelper.generateHistogramImage(fromDataImage: dataImage) else { return nil }
        let resized = TTMHistogramHelper.resize(outImage, with: .none, rate: 2.5)
        return resized
    }
}
