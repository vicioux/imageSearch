//
//  UIView+NibLoadableView.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation
import UIKit

public protocol NibLoadableView: class {}

/**
 Adds a convenience initializer for views
 */
extension NibLoadableView {
    public static var NibName: String {
        return String(describing: self)
    }
    
    public static func createView<T>(_: T.Type, inBundleWithName: String? = nil, withIndexInXib: Int = 0) -> T where T: NibLoadableView {
        if let customBundle = inBundleWithName {
            return Bundle(identifier: customBundle)!.loadNibNamed(T.NibName, owner: nil, options: nil)![withIndexInXib] as! T
        }
        return Bundle.main.loadNibNamed(T.NibName, owner: nil, options: nil)![withIndexInXib] as! T
    }
}

extension UIView: NibLoadableView {}
