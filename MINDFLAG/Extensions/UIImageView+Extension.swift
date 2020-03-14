//
//  UIImageView+Extension.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit

extension UIImageView {
	
	/**
	Call this method on an instance of UIImageView to asynchonously fetch an image and set its `image` property
	- parameters:
		- url: The url for the specified image
		- placeholder: An optional placeholder image to use
	
	This method also uses a cache system to store retrieved images
	*/
    func load(url: URL, placeholder: UIImage?) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
        } else {
            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data, let response = response, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        self.image = image
                    }
                }
            }).resume()
        }
    }
}
