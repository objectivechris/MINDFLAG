//
//  Country.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import Foundation

struct Country: Codable {
	let id: Int
	let name: String
	let code: String
	let phoneCode: String?
	
	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case name = "Name"
		case code = "Code"
		case phoneCode = "PhoneCode"
	}
}

extension Country: Comparable {
	static func < (lhs: Country, rhs: Country) -> Bool {
		if lhs.name != rhs.name {
            return lhs.name < rhs.name
        } else if lhs.id != rhs.id {
            return lhs.id < rhs.id
        } else {
            return lhs.code < rhs.code
        }
	}
	
	static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
            && lhs.code == rhs.code
    }
}
