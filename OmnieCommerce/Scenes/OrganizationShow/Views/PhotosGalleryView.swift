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

            _ = (values as! [GalleryImage]).map { $0.cellHeight = 85.0 }
            serviceButtonTitleDidUpload(forPage: 0)
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
            self.serviceButtonTitleDidUpload(forPage: page)
        }
        
        // Load images
        var kingfisherSource = [KingfisherSource]()
        
        for galleryImage in (values as! [GalleryImage]) {
            kingfisherSource.append(KingfisherSource(urlString: galleryImage.imageID.convertToURL(withSize: .Small, inMode: .Get).absoluteString)!)
        }

        imageSlideShow.setImageInputs(kingfisherSource)
    }
    
    func serviceButtonTitleDidUpload(forPage currentPage: Int) {
        let item = self.values?[currentPage] as! GalleryImage
        
        self.serviceButton.setAttributedTitle(NSAttributedString.init(string: item.serviceName ?? ""), for: .normal)
        self.serviceButton.isTitleUnderlined = true
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
