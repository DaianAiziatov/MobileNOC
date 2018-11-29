//
//  UIView.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 29/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeCircleBorders() {
        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = frame.size.height/2
    }
    
    func makeBordersWith(color: CGColor, width: CGFloat) {
        layer.borderColor = color;
        layer.borderWidth = width;
    }
    
    func makeRoundBorder(with radius: CGFloat) {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

}
