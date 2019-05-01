//
//  UIViewExtension.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func  set( attribute: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation = .equal, toItem: Any?, attributeSecond: NSLayoutConstraint.Attribute = .notAnAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0,viewMain:AnyObject){
        let any:NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attributeSecond, multiplier: multiplier, constant: constant)
        viewMain.addConstraint(any)
    }
    
    func  get( attribute: NSLayoutConstraint.Attribute, relatedBy: NSLayoutConstraint.Relation = .equal, toItem: Any?, attributeSecond: NSLayoutConstraint.Attribute = .notAnAttribute, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0,viewMain:AnyObject)->NSLayoutConstraint{
        let any:NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attributeSecond, multiplier: multiplier, constant: constant)
        viewMain.addConstraint(any)
        return any
    }
    
    public func pin(to view: UIView) {
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

