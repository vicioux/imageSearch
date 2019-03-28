//
//  DetailViewController.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/27/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: ImageTableViewModelType!
    var navigationBarSnapshot: UIView!
    var navigationBarHeight: CGFloat = 0
    let transition = ExpandingCellTransition()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(withViewModel vm: ImageTableViewModelType, customXib: String? = nil) {
        self.viewModel = vm
        super.init(nibName: customXib ?? "DetailViewController", bundle: nil)
        title = viewModel.getTitle()
        navigationController?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height*2);
        self.transitioningDelegate = transition
        setImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationBarSnapshot != nil {
            navigationBarSnapshot.frame.origin.y = -navigationBarHeight
            scrollView.addSubview(navigationBarSnapshot)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if scrollView.contentOffset.y < -navigationBarHeight/2 {
            return .lightContent
        }
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    open func setImage() {
        if let vm = self.viewModel, let base = vm.getBaseImage() {
            self.adjustImageProportions(forImage: base, baseWidth: self.pictureImageView.bounds.width, adjustableHeightConstraint: &self.imageViewConstraint!)
        }
        
        if let cachedImage = self.viewModel?.image {
            self.pictureImageView.image = cachedImage
            //check what can i do to handle an image or video ...
            
        } else {
            self.pictureImageView.image = UIImage(named: "placeholder_cover")
        }
        
        self.pictureImageView.backgroundColor = .white
    }
    
}

// MARK: AdjustableImageHeight
extension DetailViewController: AdjustableImageHeight { }

// MARK: ExpandingTransitionPresentedViewController
extension DetailViewController: ExpandingTransitionPresentedViewController {
    
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
        self.navigationBarSnapshot = navigationBarSnapshot
        self.navigationBarHeight = navigationBarSnapshot.frame.height
    }
}

// MARK: UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isBeingDismissed {
            navigationBarSnapshot?.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: view.bounds.width, height: -scrollView.contentOffset.y)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -navigationBarHeight/2 {
            dismiss(animated: true, completion: nil)
        }
    }
}
