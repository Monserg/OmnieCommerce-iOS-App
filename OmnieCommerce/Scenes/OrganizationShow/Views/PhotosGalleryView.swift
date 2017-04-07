//
//  PhotosGalleryView.swift
//  OmnieCommerce
//
//  Created by msm72 on 07.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import Foundation
import Kingfisher
import ImageSlideshow

class PhotosGalleryView: CustomView {
    // MARK: - Properties
    var isShow: Bool = false
    var photos: [UIImage]!
    var currentPage: Int = 0
    
    @IBOutlet var view: UIView!
    @IBOutlet var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var serviceButton: UbuntuLightVeryLightOrangeButton!
    
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        let newFrame = CGRect.init(origin: .zero, size: view.frame.size)
        super.init(frame: newFrame)
        
        createFromXIB()
        imagesDidLoad()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.serviceButton.setAttributedTitle(NSAttributedString.init(string: "Current page: 0"), for: .normal)

        view.addSubview(self)
        self.didShow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Class Functions
    override func draw(_ rect: CGRect) {
    }
    
    override func didHide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: { success in
            self.removeFromSuperview()
            self.handlerCancelButtonCompletion!()
        })
    }
    
    
    // MARK: - Custom Functions
    func createFromXIB() {
        UINib(nibName: String(describing: PhotosGalleryView.self), bundle: Bundle(for: PhotosGalleryView.self)).instantiate(withOwner: self, options: nil)
        view.frame = frame
        addSubview(view)
    }
    
    func imagesDidLoad() {
        imageSlideShow.backgroundColor = UIColor.clear
        imageSlideShow.draggingEnabled = false
        // slideshow.slideshowInterval = 0.10
        imageSlideShow.pageControlPosition = .hidden
        imageSlideShow.pageControl.currentPageIndicatorTintColor = UIColor.veryLightOrange
        imageSlideShow.pageControl.pageIndicatorTintColor = UIColor.veryDarkCyan
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        imageSlideShow.currentPageChanged = { page in
            self.serviceButton.setAttributedTitle(NSAttributedString.init(string: "Current page: \(page)"), for: .normal)
            self.serviceButton.isTitleUnderlined = true
        }
        
        // Load images
//        var images = [UIImage]()
//            
//        for imageURL in values! {
//            if let imagePath = imageURL as? String {
//                images.append(KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!)
//            }
//        }
            
            
        
        let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!,
                                KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!,
                                KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]

        imageSlideShow.setImageInputs(kingfisherSource)
    }
    
    
    // MARK: - Actions
    @IBAction func handlerCancelButtonTap(_ sender: UIButton) {
        self.didHide()
    }
    
    @IBAction func handlerServiceButtonTap(_ sender: UbuntuLightVeryLightOrangeButton) {
    }
    
    @IBAction func handlerLeftPageButtonTap(_ sender: UIButton) {
        if (currentPage == 0) {
            currentPage = imageSlideShow.pageControl.numberOfPages - 1
        } else {
            currentPage -= 1
        }
        
        imageSlideShow.setCurrentPage(currentPage, animated: true)
    }
    
    @IBAction func handlerRightPageButtonTap(_ sender: UIButton) {
        if (currentPage == imageSlideShow.pageControl.numberOfPages - 1) {
            currentPage = 0
        } else {
            currentPage += 1
        }
        
        imageSlideShow.setCurrentPage(currentPage, animated: true)
    }
}
