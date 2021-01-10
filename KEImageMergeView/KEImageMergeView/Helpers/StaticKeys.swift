//
//  StaticKeys.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit

struct StaticKeys {
    struct Error {
        static let Fetching = "There is an error on fetching overlay images:"
        static let Serialization = "There is an error on serialization"
        static let NoFrontImage = "Front image cant be downloaded or showned"
        static let SaveImage = "There is an error on saving overlayed image"
    }
    
    struct UserDefaults {
        static let OverlayImageModel = "OverlayImageModel"
        static let PNG_Save = "PNG_Save"
        static let JPEG_Save = "JPEG_Save"
        static let PNG_Resized_Save = "PNG_Resized_Save"
    }
    
    struct Texts {
        static let None = "None"
        static let WhereToSaveImage = "How to save overlayed image?"
        static let PNG_Disk = "as PNG to disk"
        static let JPEG_Disk = "as JPEG to disk"
        static let PNG_User_Def = "as PNG to user defaults"
        static let JPEG_User_Def = "as JPEG to user defaults"
        static let Cancel = "Cancel"
        static let PNG_Resized_User_Def = "as Resized PNG to user defaults"
        static let PNG_Resized_Disk = "as Resized PNG to disk"
    }
    
    struct Success {
        static let SaveImage = "Overlayed image is saved as:"
    }
}
