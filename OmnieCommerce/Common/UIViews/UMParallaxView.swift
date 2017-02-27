//
//  UMParallaxView.swift
//
//  Created by Ramon Vicente on 4/7/16.
//  Copyright © 2016 Umobi. All rights reserved.
//

import UIKit

class UMParallaxView: UIView {
    
    fileprivate var heightLayoutConstraint: NSLayoutConstraint?
    fileprivate var bottomLayoutConstraint: NSLayoutConstraint?
    fileprivate var containerLayoutConstraint: NSLayoutConstraint?
    
    fileprivate var containerView = UIView()
    
    fileprivate var imageView = UIImageView()
    
    fileprivate var scrollView: UIScrollView? = nil {
        didSet {
            reloadPosition()
        }
    }
    
    var height: CGFloat = 0 {
        didSet {
            self.frame.size.height = height
            if scrollView != nil {
                scrollView!.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
            }
            reloadPosition()
        }
    }
    
    var minHeight: CGFloat = 64 {
        didSet {
            reloadPosition()
        }
    }
    
    fileprivate var _maxHeight: CGFloat = 0
    
    var maxHeight: CGFloat {
        get {
            return _maxHeight <= height ? height*1.5 : _maxHeight
        }
        set {
            _maxHeight = newValue
        }
    }
    
    var fixed: Bool = true {
        didSet {
            reloadPosition()
        }
    }
    
    var zoomFactor: CGFloat = 2 {
        didSet {
            reloadPosition()
        }
    }
    
    var image:UIImage? {
        didSet{
            imageView.image = image
        }
    }
    
    convenience init?(height: CGFloat, fixed: Bool = true) {
        self.init(frame: CGRect.zero)
        self.height = height
        self.fixed = fixed
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attachTo(_ scrollView: UIScrollView!) {
        scrollView.addSubview(self)
        self.scrollView = scrollView
        
        self.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: self.height)
        scrollView!.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
        
        reloadPosition()
    }
    
    fileprivate func prepareView() {
        
        self.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.clear
        containerView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        containerView.addSubview(imageView)
        self.addSubview(containerView)
        
        let containerHorizontalLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView])
        let containerVerticalLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["containerView" : containerView])
        containerLayoutConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        let imageViewHorizontalLayoutConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["imageView" : imageView])
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        heightLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        
        containerView.addConstraints(imageViewHorizontalLayoutConstraint)
        containerView.addConstraint(bottomLayoutConstraint!)
        containerView.addConstraint(heightLayoutConstraint!)
        
        addConstraints(containerHorizontalLayoutConstraint)
        addConstraints(containerVerticalLayoutConstraint)
        addConstraint(containerLayoutConstraint!)
    }
    
    fileprivate func reloadPosition() {
        
        if scrollView != nil {
            let offsetY: CGFloat = (scrollView!.contentOffset.y + height);
            let offsetYInverse = -offsetY;
            
            var newheight = height - offsetY
            newheight = newheight > minHeight ? newheight : minHeight;
            if fixed {
                newheight = newheight < maxHeight ? newheight : maxHeight;
            }
            
            var bottonConstant = offsetY >= 0 ? 0 : offsetYInverse
            if fixed {
                bottonConstant = bottonConstant > (maxHeight-height) ? (maxHeight-height) : bottonConstant
            }
            
            var heightConstant = newheight - (newheight * (zoomFactor > 3 ? 3 : zoomFactor) / 3)
            if !fixed {
                heightConstant = heightConstant > offsetYInverse ? heightConstant : offsetYInverse
            }
            
            
            containerLayoutConstraint!.constant = heightConstant
            heightLayoutConstraint!.constant = heightConstant
            bottomLayoutConstraint!.constant = bottonConstant/3
            
            if fixed {
                self.frame.size.height = newheight;
                self.frame.origin.y = offsetY - height
            } else {
                containerView.clipsToBounds = offsetY <= 0
                self.frame.origin.y = -height
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        reloadPosition()
    }
}
