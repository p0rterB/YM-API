//
//  Context.swift
//  yandexMusic-iOS
//
//  Created by Developer on 26.05.2021.
//

///Queue description
public class QueueContext: Codable {
    
    ///Content type UID (of album, playlist...)
    public let id: String?
    ///Content type ('album', 'playlist'...)
    public let type: String
    ///Content description
    public let description: String?
 
    public init(type: String, id: String?, description: String?) {
        self.type = type
        self.id = id
        self.description = description
    }
}
