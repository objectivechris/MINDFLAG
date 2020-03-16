//
//  CountryDetailViewController.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit
import MapKit

class CountryDetailViewController: UIViewController {
	
	private enum AlertAction {
		case retry
		case dismiss
		case done
        
        var title: String {
            switch self {
            case .retry: return "Retry"
            default: return "OK"
            }
        }
	}
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var tableView: UITableView!
	
	private var activityIndicator: UIActivityIndicatorView = {
		let view = UIActivityIndicatorView(style: .medium)
		view.hidesWhenStopped = true
		return view
	}()
	
	// Banged because this viewController should NOT be presented without a country
	var country: Country!
	
	// Local property used to store retrieved provinces
	// and populate tableview
	private var provinces = [Province]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = country.name.capitalized
		navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed)), animated: true)
		navigationController?.navigationBar.tintColor = .orange
		
		tableView.backgroundView = activityIndicator
		tableView.tableFooterView = UIView()
		
		// Focus map to country on view load and fetch provinces
		mapView.setFocusToLocation(withQuery: country.name, annotationTitle: country.name.capitalized)
		fetchProvinces()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		mapView.removeAnnotations(mapView.annotations)
	}
	
	private func fetchProvinces() {
		guard let id = country?.id else { return }
		activityIndicator.startAnimating()
		APIClient.shared.fetchProvinces(forId: id) { [weak self] (provinces, error) in
			if error != nil {
				self?.showAlert(message: "Failed to get provinces...", action: .retry)
                self?.activityIndicator.stopAnimating()
				return
			}
			
			if let provinces = provinces, provinces.count > 0 {
				self?.provinces = provinces
				self?.activityIndicator.stopAnimating()
			} else {
				self?.showAlert(message: "It looks like this country doesn't have any provinces.", action: .dismiss)
				self?.activityIndicator.stopAnimating()
			}
		}
	}
	
	@objc func doneButtonPressed() {
		dismiss(animated: true)
	}
	
	/// Present a reusable alert with an `action` type passed for handling different...actions
	private func showAlert(title: String = "Uh Oh 🙁", message: String, action: AlertAction) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action.title, style: .default, handler: { _ in
			switch action {
			case .retry:
				self.fetchProvinces()
			case .dismiss:
				self.dismiss(animated: true)
			case .done:
				break
			}
		}))
		self.present(alert, animated: true, completion: nil)
	}
}

// MARK: - Table view data source
extension CountryDetailViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return provinces.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath)
		let province = provinces[indexPath.row]
		cell.textLabel?.text = province.name
		cell.detailTextLabel?.text = province.code
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Provinces"
	}
}

// MARK: - Table view delegate
extension CountryDetailViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let province = provinces[indexPath.row]
		let query = "\(province.name), \(country.name)"
		let annotationTitle = province.name
        mapView.setFocusToLocation(withQuery: query, annotationTitle: annotationTitle, latitudeDelta: 0.2, longitudeDelta: 0.2) { (error) in
            if error != nil {
                self.showAlert(message: "Couldn't update map to the selected province.", action: .done)
            }
        }
	}
}
