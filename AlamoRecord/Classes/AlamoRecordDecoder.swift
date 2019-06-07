//
//  AlamoRecordDecoder.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 6/6/19.
//

import Alamofire

class AlamoRecordDecoder: DataDecoder {
    
    private let keyPath: String?
    
    init(keyPath: String?) {
        self.keyPath = keyPath
    }
    
    func decode<D>(_ type: D.Type, from data: Data) throws -> D where D : Decodable {
        let decoder = JSONDecoder()
        guard let keyPath = keyPath,
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
            let keyPathJson = json[keyPath] else {
                return try decoder.decode(D.self, from: data)
        }
        let keyPathJsonData = try JSONSerialization.data(withJSONObject: keyPathJson, options: .prettyPrinted)
        return try decoder.decode(D.self, from: keyPathJsonData)
    }
    
    
}
