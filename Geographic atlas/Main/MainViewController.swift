import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var countries: [Country] = []
    
    var continents: [Continent] = []
    
    private var expandedIndexPaths: [IndexPath] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "World countries"
        
        NetworkService.shared.loadCountries { countries in
            self.countries = countries
            self.sortCountriesByContinent()
            self.collectionView.reloadData()
        }
        
        setupViews()
    }
    
    private func sortCountriesByContinent() {
        let continentsSet = Set(countries.compactMap { $0.continents?.first })
        continents = continentsSet.map { continentName in
            let continentCountries = countries.filter { $0.continents?.contains(continentName) ?? false }
            return Continent(name: continentName, countries: continentCountries)
        }
        continents.sort { $0.name < $1.name }
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return continents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let continent = continents[section]
        return continent.countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let country = continents[indexPath.section].countries[indexPath.item]
        cell.configure(with: country)
        cell.didExpandButtonTapped = { [weak self] in
            self?.toggleCellExpansion(at: indexPath)
            cell.isExpanded = self?.shouldExpandCell(at: indexPath) ?? false
            collectionView.performBatchUpdates(nil, completion: nil)
        }
        cell.isExpanded = shouldExpandCell(at: indexPath)
        cell.viewContainer.didMoreButtonTapped = {
            let vc = DetailViewController()
            let county = self.continents[indexPath.section].countries[indexPath.row]
            vc.country = county
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else {
            return UICollectionReusableView()
        }
        headerView.titleLabel.text = continents[indexPath.section].name.uppercased()
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isExpanded = shouldExpandCell(at: indexPath)
        let height: CGFloat = isExpanded ? 202 : 72
        return CGSize(width: collectionView.bounds.width - 32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 42)
    }
    
    // MARK: - Cell Expansion
    
    private func shouldExpandCell(at indexPath: IndexPath) -> Bool {
        return expandedIndexPaths.contains(indexPath)
    }
    
    private func toggleCellExpansion(at indexPath: IndexPath) {
        if shouldExpandCell(at: indexPath) {
            expandedIndexPaths.removeAll(where: { $0 == indexPath })
        } else {
            expandedIndexPaths.append(indexPath)
        }
        
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}
