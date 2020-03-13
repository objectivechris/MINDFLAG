//
//  APIError.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import Foundation

enum APIError: Error {
	case requestFailed
	case parsingFailure
	case invalidURL
}
