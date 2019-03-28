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
    
    
    var viewModel: ImageTableViewModelType!
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpScrollView()
    }
    
    public init(withViewModel vm: ImageTableViewModelType, customXib: String? = nil) {
        self.viewModel = vm
        super.init(nibName: customXib ?? "DetailViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewModifiers()
        
        //view.backgroundColor = .clear
        visualEffectContainer.backgroundColor = .clear
        visualEffectContainer.addSubview(visualEffectView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(gr:))))
    }
    
    func addViewModifiers() {
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .none
        
        self.cardView.hero.id = viewModel.identifier
        self.imageView.image = viewModel.image
        self.cardView.hero.modifiers = [.useNoSnapshot, .spring(stiffness: 250, damping: 25)]
        
        guard let identifier = viewModel.identifier else { return }
        view.hero.modifiers = [.source(heroID: identifier), .spring(stiffness: 250, damping: 25)]
        self.visualEffectView.hero.modifiers = [.fade, .useNoSnapshot]
    }
    
    @objc func handlePan(gr: UIPanGestureRecognizer) {
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
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    /** Setup scroll view config */
    private func setUpScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
    }
}


//class CardView: UIView {
//    let titleLabel = UILabel()
//    let imageView = UIImageView(image: UIImage(named: "placeholder_cover"))
//    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//
//    required init?(coder aDecoder: NSCoder) { fatalError() }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        clipsToBounds = true
//
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        imageView.contentMode = .scaleAspectFill
//
//        addSubview(imageView)
//        addSubview(visualEffectView)
//        addSubview(titleLabel)
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.frame = bounds
//        visualEffectView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 90)
//        titleLabel.frame = CGRect(x: 20, y: 20, width: bounds.width - 40, height: 30)
//    }
//}
