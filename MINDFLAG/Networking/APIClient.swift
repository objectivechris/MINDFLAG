//
//  APIClient.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import Foundation

enum Endpoint {
	
	static let baseURL = "https://connect.mindbodyonline.com/rest/worldregions/country"
	static let flagsURL = "https://www.countryflags.io/"
	
	case countries
	case province(String)
	case flag(String)
	
	var stringValue: String {
		switch self {
		case .countries: return Endpoint.baseURL
		case .province(let id):
			return Endpoint.baseURL + "/\(id)/province"
		case .flag(let code): return Endpoint.flagsURL + "\(code)/flat/64.png"
		}
	}
	
	var url: URL? {
		return URL(string: stringValue)
	}
}

class APIClient {
	
	private let decoder = JSONDecoder()
	private let session: URLSession
	
	private init(configuration: URLSessionConfiguration) {
		self.session = URLSession(configuration: configuration)
	}
	
	convenience init() {
		self.init(configuration: .default)
	}
	
	typealias CountriesCompletionHandler = ([Country]?, APIError?) -> Void
	typealias ProvincesCompletionHandler = ([Province]?, APIError?) -> Void
	
	func getCountries(completionHandler completion: @escaping CountriesCompletionHandler) {
		request(url: Endpoint.countries.url, responseType: [Country].self) { (response, error) in
			if error != nil {
				completion(nil, APIError.requestFailed)
				return
			}
			
			if let response = response {
				completion(response, nil)
			}
		}
	}
	
	func getProvinces(forId id: String, completionHandler completion: @escaping CountriesCompletionHandler) {
		
	}
}

extension APIClient {
	
	private func request<ResponseType: Decodable>(url: URL?, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> ()) {
		
		guard let url = url else {
			completion(nil, APIError.invalidURL)
			return
		}
		
		let urlRequest = URLRequest(url: url)
		
		let task = session.dataTask(with: urlRequest) { (data, response, error) in
			guard let data = data else {
				DispatchQueue.main.async {
					completion(nil, error)
				}
				return
			}
			
			let decoder = JSONDecoder()
			do {
				let responseObject = try decoder.decode(ResponseType.self, from: data)
				DispatchQueue.main.async {
					completion(responseObject, nil)
				}
			} catch {
				DispatchQueue.main.async {
					completion(nil, APIError.parsingFailure)
				}
			}
		}
		task.resume()
	}
}
