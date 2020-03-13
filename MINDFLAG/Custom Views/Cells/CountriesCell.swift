//
//  CountriesCell.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit

class CountriesCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var flagImageView: FlagImageView!
	@IBOutlet weak var phoneCodeLabel: UILabel!
	
	func configure(with country: Country) {
		nameLabel.text = country.name.capitalized
		if let phoneCode = country.phoneCode {
			phoneCodeLabel.text = "+\(phoneCode)"
		}
		flagImageView.load(url: Endpoint.flag(country.code).url!, placeholder: UIImage(named: "placeholder"))
	}
}
