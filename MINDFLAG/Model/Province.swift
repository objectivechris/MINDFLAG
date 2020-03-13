//
//  Province.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import Foundation

struct Province: Codable {
	let id: Int
	let name: String
	let code: String
	let countryCode: String
	
	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case name = "Name"
		case code = "Code"
		case countryCode = "CountryCode"
	}
}
