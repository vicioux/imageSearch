//
//  DetailViewController.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/27/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import UIKit
import Hero

class DetailViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var visualEffectContainer: UIView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ImageTableViewModelType!
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = nil
        self.imageViewHeightConstraint?.constant = 0
    }
    
    public init(withViewModel vm: ImageTableViewModelType, customXib: String? = nil) {
        self.viewModel = vm
        super.init(nibName: customXib ?? "DetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewModifiers()
        visualEffectContainer.backgroundColor = .clear
        visualEffectContainer.addSubview(visualEffectView)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let title = viewModel.getTitle() ?? viewModel.getDescription() else { return }
        self.navigationController?.detailViewNavBar(inViewController: self, title: title, goBackSelector: #selector(dissmissView))
        self.navigationController?.removeSpaceInTop()
    }
    
    private func addViewModifiers() {
        hero.isEnabled = true
        hero.modalAnimationType = .none
        
        cardView.hero.id = viewModel.identifier
        setImage()
        cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
        
        guard let identifier = viewModel.identifier else { return }
        view.hero.modifiers = [.source(heroID: identifier), .spring(stiffness: 250, damping: 25)]
        visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
    }
    
    @objc private func dissmissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePan(gr: UIPanGestureRecognizer) {
        let translation = gr.translation(in: view)
        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(translation.y / view.bounds.height)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds = view.bounds
        visualEffectView.frame = bounds
        setImage()
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: AdjustableImageHeight {
    open func setImage() {
        if let vm = self.viewModel, let base = vm.getBaseImage() {
            self.adjustImageProportions(forImage: base, baseWidth: self.view.bounds.width, adjustableHeightConstraint: &self.imageViewHeightConstraint!)
        }
        
        if let cachedImage = self.viewModel?.image {
            self.imageView.image = cachedImage
        } else {
            self.imageView.image = UIImage(named: "placeholder_cover")
        }
        
        self.imageView.backgroundColor = .white
    }
}
