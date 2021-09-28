//
//  Value.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

///Represents some value or variable with key-name
public class KeyValueObj: Decodable {
    
    enum CodingKeys: CodingKey {
        case name
        case value
    }
    
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.value = value
        self.name = name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var value: String = ""
        do {
            value = try container.decode(String.self, forKey: .value)
        } catch {
            let valueInt = (try? container.decodeIfPresent(Int.self, forKey: .value)) ?? 0
            value = String(valueInt)
        }
        self.value = value
        self.name = try container.decode(String.self, forKey: .name)
    }
}
