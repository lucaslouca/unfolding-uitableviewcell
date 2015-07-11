//
//  UnfoldingTableViewCell.swift
//  UnfoldingTableCell
//
//  Created by Lucas Louca on 11/07/15.
//  Copyright © 2015 Lucas Louca. All rights reserved.
//

import UIKit

class UnfoldingTableViewCell: UITableViewCell {
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var treeImageView: UIImageView!
    
    var bottom:UIView!
    var top:UIView!
    var curtainView:UIView!
    var viewSize: CGSize!
    var topGradientLayer: CAGradientLayer!
    var topOverlay:UIView!
    var bottomGradientLayer: CAGradientLayer!
    var bottomOverlay:UIView!
    var unfolding = false
    var folding = false
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layoutMargins = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
    Setup top and bottom views
    */
    func prepareFoldViews() {
        viewSize = CGSizeMake(detailView.frame.width, detailView.frame.height)
        
        curtainView = UIView(frame: CGRectMake(0, 0, viewSize.width, viewSize.height))
        curtainView.backgroundColor = UIColor.darkGrayColor()
        
        
        top = UIView(frame: CGRectMake(0, -viewSize.height/2.0, viewSize.width, viewSize.height))
        bottom = UIView(frame: CGRectMake(0, -viewSize.height/2.0, viewSize.width, viewSize.height))
        
        top.layer.anchorPoint = CGPointMake(0.5, 0.0)
        bottom.layer.anchorPoint = CGPointMake(0.5, 1.0)
        
        top.bounds = CGRectMake(0, 0, viewSize.width, viewSize.height/2.0)
        bottom.bounds = CGRectMake(0, 0, viewSize.width, viewSize.height/2.0)
        
        top.backgroundColor = UIColor.whiteColor()
        bottom.backgroundColor = UIColor.whiteColor()
        
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = -1.0 / 1000
        bottom.layer.transform = transform
        top.layer.transform = transform
        
        let splitViewFrame = CGRectMake(0, 0, viewSize.width, viewSize.height/2.0)
        topGradientLayer = CAGradientLayer()
        topGradientLayer.frame = splitViewFrame
        topGradientLayer.colors = [UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor, UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor]
        
        topOverlay = UIView(frame: splitViewFrame)
        topOverlay.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleHeight, .FlexibleWidth]
        topOverlay.userInteractionEnabled = false
        topOverlay.layer.insertSublayer(topGradientLayer, atIndex: 0)
        top.addSubview(topOverlay)
        
        
        bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.frame = splitViewFrame
        bottomGradientLayer.colors = [UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor, UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).CGColor]
        bottomGradientLayer.transform = CATransform3DRotate(bottomGradientLayer.transform, self.DegreesToRadians(180), 1.0, 0.0, 0.0)
        
        bottomOverlay = UIView(frame: splitViewFrame)
        bottomOverlay.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin, .FlexibleHeight, .FlexibleWidth]
        bottomOverlay.userInteractionEnabled = false
        bottomOverlay.layer.insertSublayer(bottomGradientLayer, atIndex: 0)
        bottom.addSubview(bottomOverlay)
        
        
        curtainView.addSubview(bottom)
        curtainView.addSubview(top)
    }
    
    /**
    Create a screenshot of the details view and set its upper and lower half as the top and bottom view's layer content respectively.
    */
    func createScreenshot() {
        // Create screenshot of detail view
        UIGraphicsBeginImageContext(detailView.frame.size)
        detailView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let viewSnapShot: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        if (viewSnapShot != nil) {
            let imgRef:CGImageRef = viewSnapShot.CGImage!
            bottom.layer.contents = imgRef
            top.layer.contents = imgRef
            bottom.layer.contentsRect = CGRectMake(0.0, 0.5, 1.0, 0.5)
            top.layer.contentsRect = CGRectMake(0.0, 0.0, 1.0, 0.5)
        }
    }
    
    
    /**
    Convert degrees (0-360) into radians.
    
    - parameter degrees: CGFloat degrees in the range of [0,360] to convert to radians
    - returns: CGFloat degrees in radians
    */
    func DegreesToRadians(degrees:CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180.0
    }
    
    /**
    Unfold the table view cell
    */
    func unfold(completion: ((Bool) -> Void)?) {
        if !unfolding && !folding {
            unfolding = true
            prepareFoldViews()
            createScreenshot()
            detailView.addSubview(curtainView)
            
            self.top.layer.transform = CATransform3DRotate(self.top.layer.transform, self.DegreesToRadians(-90), 1.0, 0.0, 0.0)
            self.bottom.layer.transform = CATransform3DRotate(self.bottom.layer.transform, self.DegreesToRadians(90), 1.0, 0.0, 0.0)
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.top.layer.transform = CATransform3DRotate(self.top.layer.transform, self.DegreesToRadians(90), 1.0, 0.0, 0.0)
                
                let rotateTransformBottom = CATransform3DRotate(self.bottom.layer.transform, self.DegreesToRadians(-90), 1.0, 0.0, 0.0)
                let translateTransformBottom = CATransform3DMakeTranslation(0.0, self.viewSize.height, 0.0)
                self.bottom.layer.transform = CATransform3DConcat(rotateTransformBottom, translateTransformBottom)
                
                self.topOverlay.alpha = 0.0
                self.bottomOverlay.alpha = 0.0
                }, completion: { success in
                    self.curtainView.removeFromSuperview()
                    self.unfolding = false
                    completion?(true)
            })
        }
    }
    
    /**
    Fold the table view cell
    */
    func fold(completion: ((Bool) -> Void)?) {
        if !unfolding && !folding {
            folding = true
            prepareFoldViews()
            createScreenshot()
            
            self.topOverlay.alpha = 0.0
            self.bottomOverlay.alpha = 0.0
            self.bottom.layer.transform = CATransform3DMakeTranslation(0.0, self.viewSize.height, 0.0)
            
            detailView.addSubview(curtainView)
            
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.top.layer.transform = CATransform3DRotate(self.top.layer.transform, self.DegreesToRadians(-90), 1.0, 0.0, 0.0)
                
                self.bottom.layer.transform.m34 = -1.0 / 1000
                let rotateTransformBottom = CATransform3DRotate(self.bottom.layer.transform, self.DegreesToRadians(90), 1.0, 0.0, 0.0)
                let translateTransformBottom = CATransform3DMakeTranslation(0.0, -self.viewSize.height, 0.0)
                self.bottom.layer.transform = CATransform3DConcat(rotateTransformBottom, translateTransformBottom)
                
                self.topOverlay.alpha = 1.0
                self.bottomOverlay.alpha = 1.0
                }, completion: { success in
                    self.curtainView.removeFromSuperview()
                    self.folding = false
                    completion?(true)
            })
        }
    }

    
}
