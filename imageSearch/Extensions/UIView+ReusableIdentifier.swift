//
//  UIView+ReusableIdentifier.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation
import UIKit

public protocol ReusableIdentifier: class {}

/**
 Adds a convenience reusable identifier property
 */
extension ReusableIdentifier where Self: UIView {
    public static  var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableIdentifier {}
extension UICollectionViewCell: ReusableIdentifier {}
