//
//  APIManager.swift
//  KEImageMergeView
//
//  Created by Kaan Esin on 9.01.2021.
//

import UIKit
import Alamofire
import Loaf

class APIManager: NSObject {
    static let shared = APIManager()
    
    lazy var baseUrl = {
        return "https://lyrebirdstudio.s3-us-west-2.amazonaws.com/candidates/overlay.json"
    }()
    
    func fetchOverlays(sender: UIViewController, completion: @escaping(OverlayModel?)->()) {
        if let jsonObj = AppUtils.shared.getObject(key: StaticKeys.UserDefaults.OverlayImageModel) {
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed)
                let overlayModel = try JSONDecoder().decode(OverlayModel.self, from: data)
                completion(overlayModel)
            }
            catch {
                Loaf("\(StaticKeys.Error.Serialization)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
                completion(nil)
            }
        }
        else {
            AF.request(APIManager.shared.baseUrl).responseJSON { [weak self] (response) in
                guard let _ = self else { return }
                debugPrint(response)
                
                if let error = response.error {
                    Loaf("\(StaticKeys.Error.Fetching) \(error.localizedDescription)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
                    completion(nil)
                    return
                }
                
                guard let data = response.data else {
                    Loaf("\(StaticKeys.Error.Serialization)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
                    completion(nil)
                    return
                }
                do {
                    guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else { return }
                    AppUtils.shared.setObject(key: StaticKeys.UserDefaults.OverlayImageModel, value: jsonObj)
                    let overlayModel = try JSONDecoder().decode(OverlayModel.self, from: data)
                    completion(overlayModel)
                }
                catch {
                    Loaf("\(StaticKeys.Error.Serialization)", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: sender).show()
                    completion(nil)
                }
            }
        }
    }
    
}
