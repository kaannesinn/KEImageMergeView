//
//  ViewController.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.shared.fetchOverlays(sender: self) { (overlayModel) in
            guard let overlayModel = overlayModel else { return }
            debugPrint(overlayModel)
        }
    }

}

