//
//  UINavigationController+Styles.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/28/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func setupFullyTranslucentBar() {
        self.navigationBar.isUserInteractionEnabled = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        //self.navigationBar.tintColor = UIColor(red: 243, green: 243, blue: 243, alpha: 1)
    }
    
    public func resetElementsForTarget(_ target: UIViewController) {
        self.isNavigationBarHidden = false
        target.navigationItem.hidesBackButton = false
        
        if (target.navigationItem.leftBarButtonItem != nil) {
            target.navigationItem.leftBarButtonItem = nil
            target.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
        }
        
        if (target.navigationItem.rightBarButtonItem != nil) {
            target.navigationItem.rightBarButtonItem = nil
            target.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIView())
        }
        
        if (target.navigationItem.titleView != nil) {
            target.navigationItem.titleView = nil
            target.navigationItem.titleView = UIView()
        }
        
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
    }
    
    public func removeSpaceInTop() {
        self.navigationBar.isTranslucent = true
        self.navigationBar.isOpaque = true
    }
    
    func detailViewNavBar(inViewController vc: UIViewController, title: String, goBackSelector: Selector) {
        self.resetElementsForTarget(vc)
        self.setupFullyTranslucentBar()
        vc.navigationItem.addButton(inViewController: vc, buttonImageName: "cancel_icon", selector: goBackSelector, leftSide: false)
        vc.navigationItem.addTitle(title, font: UIFont.boldSystemFont(ofSize: 15), color: .black, inViewController: vc)
    }
}

