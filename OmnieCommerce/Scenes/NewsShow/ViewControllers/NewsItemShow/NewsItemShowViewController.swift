//
//  NewsItemShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 05.04.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit
import Kingfisher

class NewsItemShowViewController: BaseViewController {
    // MARK: - Properties
    var newsItem: NewsData!
    var isRotate: Bool = false
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    
    @IBOutlet weak var dateLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    @IBOutlet weak var organizationButton: BorderVeryDarkDesaturatedBlueButton!
    @IBOutlet weak var logoImageView: CustomImageView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.font = UIFont.ubuntuLight12
            textView.textColor = UIColor.veryLightGray
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            textView.delegate = self
        }
    }

    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSettingsDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.indicatorDidChange(UIColor.veryLightOrange)
        print(object: "scroll = \(scrollView.contentOffset.y)")
        
        if (isRotate == true && scrollView.contentOffset.y != 0) {
            isRotate = false
            scrollView.contentOffset.y = 0
        }
    }

    
    // MARK: - Custom Functions
    func viewSettingsDidLoad() {
        // Config smallTopBarView
        navigationBarView = smallTopBarView
        smallTopBarView.type = "Child"
        smallTopBarView.titleText = (newsItem.isAction) ? "ActionItem".localized() : "NewsItem".localized()
        haveMenuItem = false
        
        // Setting News values
        dateLabel.text = newsItem.activeDate.convertToString(withStyle: .Date)
        organizationButton.setTitle("          \(newsItem.name!)          ", for: .normal)

        if let imagePath = newsItem.logoStringURL {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: newsItem.codeID),
                                      placeholder: UIImage.init(named: "image-no-organization"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor(targetSize: logoImageView.frame.size))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        }

        // Handler Back button tap
        smallTopBarView.handlerSendButtonCompletion = { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isRotate = true
        smallTopBarView.setNeedsDisplay()
    }
    
    
    // MARK: - Actions
    @IBAction func handlerOrganizationButtonTap(_ sender: BorderVeryDarkDesaturatedBlueButton) {
    }
}


// MARK: - UITextViewDelegate
extension NewsItemShowViewController: UITextViewDelegate {
    
}
