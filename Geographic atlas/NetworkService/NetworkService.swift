//
//  NetworkService.swift
//  Geographic atlas
//
//  Created by Julia on 14.05.2023.
//

import UIKit
import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    private let session: Session
    private let baseURL = "https://restcountries.com/v3.1/all?fields=name,capital,currencies,population,area,timezones,continents,flags,capitalInfo"
    
    private init() {
        session = Session()
    }
    
    func loadCountries(completion: @escaping ([Country]) -> Void) {
        let url = baseURL
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [[String: Any]] {
                    let countries = json.map { Country(item: $0) }
                    completion(countries)
                } else {
                    print("Invalid JSON format")
                    completion([])
                }
            case .failure(let error):
                print("Error: \(error)")
                completion([])
            }
        }
    }
}
