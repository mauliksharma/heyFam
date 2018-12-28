//
//  Extensions.swift
//  heyFam
//
//  Created by Maulik Sharma on 07/12/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageUsingCache(fromURLString urlString: String) {
        self.image = UIImage(named: "defaultAvatar")
        guard !urlString.isEmpty else { return }
        if let cachedImage = imagesCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, let image = UIImage(data: imageData) {
                        self.image = image
                        imagesCache.setObject(image, forKey: urlString as NSString)
                    }
                }
            }
        }
    }
}
