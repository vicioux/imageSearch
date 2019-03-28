//
//  AdjustableImageHeight.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit

/**
 Calculate the proportion of the widths between the real image and the uiimageview containing it so we can
 set a proportional height to it.
 */

public protocol AdjustableImageHeight {
    func adjustImageProportions(forImage base: ImageBase, baseWidth: CGFloat, adjustableHeightConstraint: inout NSLayoutConstraint)
    func adjustImageProportions(forImage baseSize: CGSize, baseWidth: CGFloat, adjustableHeightConstraint: inout NSLayoutConstraint)
}

extension AdjustableImageHeight {
    public func adjustImageProportions(forImage base: ImageBase, baseWidth: CGFloat, adjustableHeightConstraint: inout NSLayoutConstraint) {
        if let imageRatio = base.aspectRatio {
            adjustableHeightConstraint.constant = baseWidth / CGFloat(imageRatio)
        }
    }
    
    public func adjustImageProportions(forImage baseSize: CGSize, baseWidth: CGFloat, adjustableHeightConstraint: inout NSLayoutConstraint) {
        let originalAspectRatio = baseSize.width / baseSize.height
        adjustableHeightConstraint.constant = ceil(baseWidth / (originalAspectRatio))
    }
}

