//
//  OverlayModel.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 8.01.2021.
//

import Foundation

// MARK: - OverlayModelElement
struct OverlayModelElement: Codable {
    let overlayID: Int?
    let overlayName: String?
    let overlayPreviewIconURL, overlayURL: String?
    
    enum CodingKeys: String, CodingKey {
        case overlayID = "overlayId"
        case overlayName
        case overlayPreviewIconURL = "overlayPreviewIconUrl"
        case overlayURL = "overlayUrl"
    }
}

typealias OverlayModel = [OverlayModelElement]
