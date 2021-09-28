//
//  Block.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents landing block
public class Block: Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case type
        case typeForFrom
        case title
        case entities
        case description
        case data
    }
    
    ///Block UID
    public let id: String
    ///Block type
    public let type: String
    ///Block source
    public let typeForFrom: String
    ///Block head title
    public let title: String
    ///Block entities data
    public let entities: [BlockEntity]
    ///Block description
    public let description: String?
    ///Additional data
    public let data: YMBaseObject?// Optional[Union['PersonalPlaylistsData', 'PlayContextsData']] = None
    
    public init(id: String, type: String, typeForFrom: String, title: String, entities: [BlockEntity], description: String?, data: PersonalPlaylistsData?) {
        self.id = id
        self.type = type
        self.typeForFrom = typeForFrom
        self.title = title
        self.entities = entities

        self.description = description
        self.data = data
    }
    
    public init(id: String, type: String, typeForFrom: String, title: String, entities: [BlockEntity], description: String?, data: PlayContextData?) {
        self.id = id
        self.type = type
        self.typeForFrom = typeForFrom
        self.title = title
        self.entities = entities

        self.description = description
        self.data = data
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.typeForFrom = try container.decode(String.self, forKey: .typeForFrom)
        self.title = try container.decode(String.self, forKey: .title)
        self.entities = try container.decode([BlockEntity].self, forKey: .entities)

        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
        var data: YMBaseObject? = nil
        data = try? container.decodeIfPresent(PersonalPlaylistsData.self, forKey: .data)
        if (data == nil) {
            data = try? container.decodeIfPresent(PlayContextData.self, forKey: .data)
        }
        self.data = data
    }
    
    func getItemEntity(index: Int) -> BlockEntity {
        return entities[index]
    }
}
