//
//  AuthSentPasswordResponse.swift
//  YM-API
//
//  Created by Developer on 04.06.2023.
//

import Foundation

///Represents response for commited account password
public class AuthSentPasswordResponse: Decodable {
    enum CodingKeys: CodingKey {
        case state
        case avatarId
        case redirect_url
    }
    
    ///Current authorization session state
    public let state: String//Tested with 'auth_challenge'
    ///Account ava ID
    public let avatarId: String
    ///TODO
    public let redirectUrl: String
    
    init(state: String, avatarId: String, redirectUrl: String) {
        self.state = state
        self.avatarId = avatarId
        self.redirectUrl = redirectUrl
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = try container.decode(String.self, forKey: .state)
        self.avatarId = (try? container.decodeIfPresent(String.self, forKey: .avatarId)) ?? ""
        self.redirectUrl = (try? container.decodeIfPresent(String.self, forKey: .redirect_url)) ?? ""
    }
}
