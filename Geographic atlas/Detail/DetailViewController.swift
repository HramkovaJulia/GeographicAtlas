//
//  DetailViewController.swift
//  Geographic atlas
//
//  Created by Julia on 16.05.2023.
//

import UIKit

class DetailViewController: UIViewController {
  
    var country: Country?
    
    let texts = ["Region:", "Capital:", "Capital coordinates:", "Population:", "Area:", "Currencies:", "Timezones:"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = country?.name?.common
        setup()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(DetailHeaderView.self, forHeaderFooterViewReuseIdentifier: DetailHeaderView.identifier)
        return tableView
    }()
    
    private func setup() {
        setupViews()
        setupColors()
        makeConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupColors() {
        view.backgroundColor = .white
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailHeaderView.identifier) as? DetailHeaderView else { return UITableViewHeaderFooterView() }
            if let country = country {
                header.configure(with: country)
            }
            return header
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 209
        } else {
            return 0.001
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        46
    }
}

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        configureCell(for: indexPath, cell: cell)
        
        return cell
    }
    
}

extension DetailViewController {
    
    func configureCell(for indexPath: IndexPath, cell: DetailTableViewCell) {
        switch indexPath.section {
        case 0:
            configureContinentCell(cell: cell)
        case 1:
            configureCapitalCell(cell: cell)
        case 2:
            configureCoordinatesCell(cell: cell)
        case 3:
            configurePopulationCell(cell: cell)
        case 4:
            configureAreaCell(cell: cell)
        case 5:
            configureCurrencyCell(cell: cell)
        case 6:
            configureTimezoneCell(cell: cell)
        default:
            print("Something went wrong")
        }
    }
    
    func configureContinentCell(cell: DetailTableViewCell) {
        if let continent = country?.continents?.first {
            cell.configure(with: continent, title: texts[0])
        }
    }
    
    func configureCapitalCell(cell: DetailTableViewCell) {
        if let capital = country?.capital?.first {
            cell.configure(with: capital, title: texts[1])
        }
    }
    
    func configureCoordinatesCell(cell: DetailTableViewCell) {
        if let latlng = country?.capitalInfo?.latlng, latlng.count == 2 {
            let formattedCoordinates = formatCoordinates(lat: latlng[0], lon: latlng[1])
            cell.configure(with: formattedCoordinates, title: texts[2])
        }
    }
    
    func configurePopulationCell(cell: DetailTableViewCell) {
        if let population = country?.population {
            let formattedPopulation = formatPopulation(population)
            cell.configure(with: formattedPopulation, title: texts[3])
        }
    }
    
    func configureAreaCell(cell: DetailTableViewCell) {
        if let area = country?.area {
            let formattedArea = formatArea(Double(area))
            cell.configure(with: formattedArea, title: texts[4])
        }
    }
    
    func configureCurrencyCell(cell: DetailTableViewCell) {
        if let currencies = country?.currencies?.currencies, let currency = currencies.first {
            let formattedCurrency = formatCurrency(currency)
            cell.configure(with: formattedCurrency, title: texts[5])
        }
    }
    
    func configureTimezoneCell(cell: DetailTableViewCell) {
        if let timezone = country?.timezones?.first {
            cell.configure(with: timezone, title: texts[6])
        }
    }
    
    func formatCoordinates(lat: Double, lon: Double) -> String {
        let latitudeString = String(format: "%.2f°", lat)
        let longitudeString = String(format: "%.2f°", lon)
        return "\(latitudeString), \(longitudeString)"
    }
    
    func formatPopulation(_ population: Int) -> String {
        let populationInMillions = Double(population) / 1_000_000
        return String(format: "%.0f mln", populationInMillions)
    }
    
    func formatArea(_ area: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = 0
        
        if let formattedArea = numberFormatter.string(from: NSNumber(value: area)) {
            return formattedArea + " km²"
        }
        
        return ""
    }
    
    func formatCurrency(_ currency: Currency) -> String {
        return "\(currency.name ?? "") (\(currency.symbol ?? ""))"
    }
}
