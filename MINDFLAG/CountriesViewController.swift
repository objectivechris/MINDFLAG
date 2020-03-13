//
//  CountriesViewController.swift
//  MINDFLAG
//
//  Created by Christopher Rene on 3/13/20.
//  Copyright © 2020 Christopher Rene. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	private let client = APIClient()
	private var countries = [Country]() {
		didSet {
			tableView.reloadData()
		}
	}
	
	private var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
	
	private lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.tintColor = .orange
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return refreshControl
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.register(CountriesCell.nib, forCellReuseIdentifier: CountriesCell.identifier)
		tableView.backgroundView = activityIndicator
		tableView.refreshControl = refreshControl
		
		fetchCountries()
    }
	
	func fetchCountries() {
		activityIndicator.startAnimating()
		self.client.getCountries { [unowned self] (countries, error) in
			if error != nil {
				self.showAlert(message: "Failed to get list of countries")
				self.activityIndicator.stopAnimating()
				return
			}
			
			if let countries = countries {
				self.countries = countries
				self.activityIndicator.stopAnimating()
			}
		}
	}
	
	@objc private func refresh() {
		countries.removeAll()
		fetchCountries()
		self.activityIndicator.isHidden = self.refreshControl.isRefreshing
		self.refreshControl.endRefreshing()
	}
	
	private func showAlert(title: String = "Oops", message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
			self.fetchCountries()
		}))
		self.present(alert, animated: true, completion: nil)
	}
}

extension CountriesViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
    }

	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CountriesCell.identifier, for: indexPath) as! CountriesCell
		
		let country = countries[indexPath.row]
		cell.configure(with: country)

        return cell
    }
}
