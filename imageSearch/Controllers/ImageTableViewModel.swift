//
//  ImageTableViewModel.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/27/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

public protocol ImageTableViewModelType: class {
    var image: UIImage? {get set}
    var identifier: String? { get set }
    var galleryItem: GalleryItem? { get set }
    var refreshUICallback: (() -> Void)? {get set}
    func getTitle() -> String?
    func getDescription() -> String?
    func getUrl() -> URL?
    func isVideo() -> Bool
    func getBaseImage() -> ImageBase?
}


class ImageTableViewModel: NSObject, ImageTableViewModelType {
    var refreshUICallback: (() -> Void)? = nil
    
    var identifier: String?
    var image: UIImage?
    var galleryItem: GalleryItem?
    
    required public init(withGalleryItem gallery: GalleryItem?) {
        self.galleryItem = gallery
        super.init()
        
        guard let url = self.getUrl() else { return }
        var imageView: UIImageView? = UIImageView()
        
        imageView?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) {[weak self] (image, error, cacheType, imageURL) in
            guard let strongSelf = self else { return }
            
            strongSelf.image = image
            
            if let callback = strongSelf.refreshUICallback {
                callback()
            }
        }
        imageView = nil
    }
    
    func getTitle() -> String? {
        return galleryItem?.title
    }
    
    func getDescription() -> String? {
        return galleryItem?.description
    }
    
    func getUrl() -> URL? {
        guard let imageBase = getBaseImage() else {
            return nil
        }
        
        if isVideo(), let urlString = imageBase.link?.absoluteString {
            let newUrl = urlString.replacingOccurrences(of: ".mp4", with: ".gif", options: .literal, range: nil)
            return URL(string: newUrl)
        }
        
        return imageBase.link
    }
    
    func isVideo() -> Bool {
        guard let imageBase = getBaseImage(), let url = imageBase.link else {
            return false
        }
        
        return url.absoluteString.hasSuffix("mp4")
    }
    
    func getBaseImage() -> ImageBase? {
        guard let images = galleryItem?.images, images.count > 0 else {
            return nil
        }
        
        return images.first
    }
    
}
