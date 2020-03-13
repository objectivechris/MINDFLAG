//
//  FlagImageView.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit

@IBDesignable
class FlagImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }

}
