//
//  UITableViewCell+Extension.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit

extension UITableViewCell {
	
	class var identifier: String {
		return String(describing: self)
	}
	
	class var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
}
