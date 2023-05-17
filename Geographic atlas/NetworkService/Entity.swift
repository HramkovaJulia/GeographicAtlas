
import Foundation

struct Continent {
    let name: String
    var countries: [Country]
}

struct Country: Decodable {
   
    let name: CountryName?
    let capital: [String]?
    let currencies: Currencies?
    let area: Int?
    let population: Int?
    let timezones: [String]?
    let continents: [String]?
    let flags: Flags?
    let capitalInfo: CapitalInfo?
    
    init(item: [String: Any]) {
        name = CountryName(item: item["name"] as? [String: Any])
        capital = item["capital"] as? [String]
        area = item["area"] as? Int
        population = item["population"] as? Int
        timezones = item["timezones"] as? [String]
        continents = item["continents"] as? [String]
        flags = Flags(item: item["flags"] as? [String: Any])
        capitalInfo = CapitalInfo(item: item["capitalInfo"] as? [String: Any])
        let currenciesDict = item["currencies"] as? [String: Any] ?? [:]
        var currencyObjects: [Currency] = []
        
        for (_, currencyData) in currenciesDict {
            if let currencyDict = currencyData as? [String: Any],
               let currencyData = try? JSONSerialization.data(withJSONObject: currencyDict),
               let currency = try? JSONDecoder().decode(Currency.self, from: currencyData) {
                currencyObjects.append(currency)
            }
        }
        
        currencies = Currencies(currencies: currencyObjects)
    }
}

struct Flags: Decodable {
    let png: String?
    let svg: String?
    
    init(item: [String: Any]?) {
        png = item?["png"] as? String
        svg = item?["svg"] as? String
    }
}

struct CountryName: Decodable {
    let common: String?
   
    init(item: [String: Any]?) {
        common = item?["common"] as? String
    }
}

struct Currencies: Decodable {
    let currencies: [Currency]?
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
}

struct CapitalInfo: Decodable {
    let latlng: [Double]?
    
    init(item: [String: Any]?) {
        latlng = item?["latlng"] as? [Double]
    }
}
