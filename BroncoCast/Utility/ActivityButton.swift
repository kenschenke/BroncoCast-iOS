//
//  ActivityButton.swift
//  BroncoCast
//
//  Created by Ken Schenke on 12/30/18.
//  Copyright © 2018 Ken Schenke. All rights reserved.
//

import UIKit

class ActivityButton : DesignableButton {
    var originalButtonText : String?
    var originalBackgroundColor : UIColor?
    var activityLabel : String?
    var activityIndicator : UIActivityIndicatorView!
    
    func showActivity() {
        originalButtonText = self.titleLabel?.text
        self.setTitle(activityLabel ?? "", for: .disabled)
        
        originalBackgroundColor = self.backgroundColor
        self.backgroundColor = .darkGray

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        self.isEnabled = false
        
        showSpinning()
    }
    
    func hideActivity() {
        self.backgroundColor = originalBackgroundColor
        activityIndicator.stopAnimating()
        self.isEnabled = true
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        constrainActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func constrainActivityIndicatorInButton() {
        let center = activityLabel == nil
        let xConstraint = NSLayoutConstraint(item: self, attribute: center ? .centerX : .trailingMargin, relatedBy: .equal, toItem: activityIndicator, attribute: center ? .centerX : .trailing, multiplier: 1, constant: center ? 0 : 8)
        self.addConstraint(xConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
