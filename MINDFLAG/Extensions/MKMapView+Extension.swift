//
//  MKMapView+Extension.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
	
	/**
	Call this method on an instance of MKMapView to focus to the specified location given the specific parameters below.
	- parameters:
		- query: The search term
		- annotationTitle: An optional title for the annotation
		- latitudeDelta: A delta latitude level (defaults to 10)
		- longitudeDelta: A delta longitude level (defaults to 10)
	
	This method also drops an annotation to the specified location.
	*/
	func setFocusToLocation(withQuery query: String, annotationTitle: String? = nil, latitudeDelta: CLLocationDegrees = 10.0, longitudeDelta: CLLocationDegrees = 10.0) {
		
		// Create a search request with passed in query
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = query
		
		let localSearch = MKLocalSearch(request: request)
		
		// Cancel any ongoing search before starting a new one
		localSearch.cancel()
		localSearch.start { (response, error) in
			
			if let error = error {
				return print(error.localizedDescription)
			}
			
			// Remove any annotations currently displayed
			let annotations = self.annotations
			self.removeAnnotations(annotations)
			
			// Set the latitude & longitude of the from the returned POI (query) in the response
			let latitude = response?.boundingRegion.center.latitude
			let longitude = response?.boundingRegion.center.longitude
			
			// Create the annotation
			let annotation  = MKPointAnnotation()
			annotation.title = annotationTitle
			
			// Set the coordinates to the annotiation and then add to map
			if let latitude = latitude, let longitude = longitude {
				annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
				self.addAnnotation(annotation)
				
				// Span and set region to the coordinations (animated)
				let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
				let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
				let region = MKCoordinateRegion(center: coordinate, span: span)
				self.setRegion(region, animated: true)
			}
		}
	}
}
