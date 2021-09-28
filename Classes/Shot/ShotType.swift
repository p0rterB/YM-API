//
//  ShotType.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

public class ShotType: Decodable {
    
    ///Shot type UID
    public let id: String
    ///Shot headline
    public let title: String

    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
