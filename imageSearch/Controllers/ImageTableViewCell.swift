//
//  ImageTableViewCell.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit
import Kingfisher

class ImageTableViewCell: UITableViewCell, AdjustableImageHeight {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ImageTableViewModelType!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.pictureImageView.image = nil
        self.imageViewHeightConstraint?.constant = 0
    }
    
    open func load(withViewModel vm: ImageTableViewModelType) {
        viewModel = vm
        setImage()
        descriptionLabel.text = viewModel.getTitle() ?? viewModel.getDescription()
        viewModel.refreshUICallback = self.getRefreshUIClosure()
    }
    
    open func setImage() {
        if let vm = self.viewModel, let base = vm.getBaseImage() {
           self.adjustImageProportions(forImage: base, baseWidth: self.pictureImageView.bounds.width, adjustableHeightConstraint: &self.imageViewHeightConstraint!)
        }
        
        if let cachedImage = self.viewModel?.image {
            self.pictureImageView.image = cachedImage
            //check what can i do to handle an image or video ...
            
        } else {
            self.pictureImageView.image = UIImage(named: "placeholder_cover")
        }
        
        self.pictureImageView.backgroundColor = .white
    }
    
    open func getRefreshUIClosure() -> (() -> Void)? {
        return {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let theImage = strongSelf.viewModel.image {
                strongSelf.pictureImageView.image = theImage
            }
        }
    }
}
