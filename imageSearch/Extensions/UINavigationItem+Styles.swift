//
//  UINavigationItem+Styles.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/28/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    public func addButton(inViewController inVC: UIViewController, buttonImageName: String, selector: Selector, leftSide: Bool = true) {
        self.hidesBackButton = true
        
        if let img = UIImage(named: buttonImageName)?.withRenderingMode(.alwaysOriginal) {
            let btn = UIBarButtonItem(image: img, style: .plain, target: inVC, action: selector)
            
            if leftSide {
                inVC.navigationItem.leftItemsSupplementBackButton = false
                inVC.navigationItem.leftBarButtonItem = btn;
            }
            else {
                inVC.navigationItem.rightBarButtonItem = btn;
            }
        }
    }
    
    public func addTitle(_ text: String, font: UIFont, color: UIColor, inViewController inVC: UIViewController) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 42))
        titleLabel.font = font
        titleLabel.textColor = color
        titleLabel.text = text
        titleLabel.textAlignment = .center

        inVC.navigationItem.titleView = titleLabel
    }
}

