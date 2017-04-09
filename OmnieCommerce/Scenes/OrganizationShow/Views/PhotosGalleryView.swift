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
    var currentPage: Int = 0
    
    override var values: [Any]? {
        didSet {
            imagesDidLoad()

            imagesCollectionView.collectionViewControllerManager!.dataSource = values as! [GalleryImage]
            imagesCollectionView.reloadData()
        }
    }
    
    @IBOutlet var view: UIView!
    @IBOutlet var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var serviceButton: UbuntuLightVeryLightOrangeButton!
    @IBOutlet weak var imagesCollectionView: MSMCollectionView!
    
    // MARK: - Class Initialization
    init(inView view: UIView) {
        let newFrame = CGRect.init(origin: .zero, size: view.frame.size)
        super.init(frame: newFrame)
        
        createFromXIB()
        
        self.alpha = 0
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.serviceButton.setAttributedTitle(NSAttributedString.init(string: "Current page: 0"), for: .normal)

        view.addSubview(self)
        
        // Set scroll images collection view
        imagesCollectionView.collectionViewControllerManager = MSMCollectionViewControllerManager(withCollectionView: self.imagesCollectionView)
        imagesCollectionView.collectionViewControllerManager!.sectionsCount = 1
        
        // Handler Image select
        imagesCollectionView.collectionViewControllerManager!.handlerCellSelectCompletion = { item in
            if let galleryImage = item as? GalleryImage {
                // Show selected image
                self.currentPage = (self.values as! [GalleryImage]).index(where: { $0 == galleryImage })!
                self.imageSlideShow.setCurrentPage(self.currentPage, animated: true)
            }
        }

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
        var kingfisherSource = [KingfisherSource]()
        
        for galleryImage in (values as! [GalleryImage]) {
            if let imagePath = galleryImage.imagePath {
                kingfisherSource.append(KingfisherSource(urlString: imagePath)!)
            }
        }

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
