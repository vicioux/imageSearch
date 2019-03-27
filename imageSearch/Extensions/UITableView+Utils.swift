//
//  UITableView+Utils.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    public func register<T: UITableViewCell> (_: T.Type, fromBundleNamed bundleName:String? = nil) {
        var bundle: Bundle? = nil
        if let customBundle = bundleName {
            bundle = Bundle(identifier: customBundle)!
        }
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell> (forIndexPath indexPath: IndexPath) -> T  {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }
        
        return cell
    }
}
