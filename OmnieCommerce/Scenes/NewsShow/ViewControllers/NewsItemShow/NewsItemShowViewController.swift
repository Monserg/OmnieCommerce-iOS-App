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
    var services: [Service]?
    var isRotate: Bool = false
    
    var router: NewsItemShowRouter!

    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    
    @IBOutlet weak var dateLabel: UbuntuLightItalicVeryDarkGrayishBlueLabel!
    @IBOutlet weak var organizationButton: BorderVeryDarkDesaturatedBlueButton!
    @IBOutlet weak var logoImageView: CustomImageView!
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.font = UIFont.ubuntuLight12
            textView.textColor = UIColor.veryLightGray
            textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            textView.linkTextAttributes = [ NSForegroundColorAttributeName: UIColor.lightGrayishCyan ]
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
        dateLabel.text = (newsItem.activeDate as Date).convertToString(withStyle: .DateDot)
        organizationButton.setTitle("          \(newsItem.organizationName)          ", for: .normal)

        if let imagePath = newsItem.imageID {
            logoImageView.kf.setImage(with: ImageResource(downloadURL: URL(string: imagePath)!, cacheKey: newsItem.codeID),
                                      placeholder: UIImage.init(named: "image-no-organization"),
                                      options: [.transition(ImageTransition.fade(1)),
                                                .processor(ResizingImageProcessor.init(referenceSize: logoImageView.frame.size,
                                                                                       mode: .aspectFill))],
                                      completionHandler: { image, error, cacheType, imageURL in
                                        self.logoImageView.kf.cancelDownloadTask()
            })
        } else {
            logoImageView.image = UIImage.init(named: "image-no-organization")
        }

        // Merge title + text + actions
        let combination = NSMutableAttributedString()
        let emptyString = NSMutableAttributedString.init(string: "\n")
        let commaString = NSMutableAttributedString.init(string: ", ",
                                                         attributes:    [
                                                                            NSFontAttributeName: UIFont.ubuntuLightItalic12,
                                                                            NSForegroundColorAttributeName: UIColor.lightGrayishCyan
                                                                        ])
        
        // News title
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let newsTitle = NSMutableAttributedString(string: newsItem.title,
                                                  attributes:   [
                                                                    NSFontAttributeName: UIFont.ubuntuLight16,
                                                                    NSForegroundColorAttributeName: UIColor.veryLightGray,
                                                                    NSTextEffectAttributeName: NSTextEffectLetterpressStyle,
                                                                    NSParagraphStyleAttributeName: paragraph
                                                                ])
        
        combination.append(newsTitle)

        // News text
        if let text = newsItem.text {
            let newsText = NSMutableAttributedString(string: text,
                                                     attributes:    [
                                                                        NSFontAttributeName: UIFont.ubuntuLight12,
                                                                        NSForegroundColorAttributeName: UIColor.veryLightGray
                                                                    ])
            
            combination.append(emptyString)
            combination.append(emptyString)
            combination.append(newsText)
        }
        
        // Action services title
        if (newsItem.isAction && newsItem.services != nil) {
            let actionServicesTitle = NSMutableAttributedString(string: "Action valid".localized(),
                                                                attributes: [
                                                                                NSFontAttributeName: UIFont.ubuntuLightItalic12,
                                                                                NSForegroundColorAttributeName: UIColor.lightGrayishCyan
                                                                            ])
            
            combination.append(emptyString)
            combination.append(actionServicesTitle)
            
            // Add action services targets
            for (index, service) in newsItem.services!.enumerated() {
                let serviceName = service.name
                
                let serviceTarget = NSMutableAttributedString(string: serviceName!)
                serviceTarget.addAttribute(NSLinkAttributeName,
                                           value: "promotionServiceID" + service.codeID,
                                           range: (serviceTarget.string as NSString).range(of: serviceName!))
                
                serviceTarget.addAttributes([ NSFontAttributeName: UIFont.ubuntuLightItalic12,
                                              NSForegroundColorAttributeName: UIColor.lightGrayishCyan,
                                              NSUnderlineStyleAttributeName: 1],
                                            range: (serviceTarget.string as NSString).range(of: serviceName!))
                
                combination.append(serviceTarget)
                
                if (index < newsItem.services!.count - 1) {
                    combination.append(commaString)
                }
            }
        }
    
        textView.attributedText = combination
        spinnerDidFinish()
        
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
        if (router == nil) {
            router = NewsItemShowRouter()
        }
        
        router.navigateToOrganizationShowScene(newsItem.organizationID, fromViewController: self)
    }
}


// MARK: - UITextViewDelegate
extension NewsItemShowViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString.hasPrefix("promotionServiceID")) {
            // Navigate to selected Service
            handlerOrganizationButtonTap(organizationButton)
            return false
        }
        
        return true
    }
}
