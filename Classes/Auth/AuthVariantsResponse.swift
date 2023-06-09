//
//  AuthVariantsResponseswift.swift
//  YM-API
//
//  Created by Developer on 04.06.2023.
//

import Foundation

public class AuthVariantsResponse: Decodable {
    enum CodingKeys: CodingKey {
        case csrf_token
        case use_new_suggest_by_phone
        case is_rfc_2fa_enabled
        case track_id
        case can_authorize
        case preferred_auth_method
        case auth_methods
    }
    
    ///Token for authorization session
    public let csrfToken: String
    ///Track ID for authorization session
    public let trackId: String
    ///TODO
    public let useNewSuggestByPhone: Bool
    ///TODO
    public let rfc2fa: Bool
    ///Can continue authorization. Also marker for 'not found' or 'banned' user
    public let canAuthorize: Bool
    ///Defauit auth method
    public let preferredAuthMedtod: AuthMethod
    ///Available auth methods for account
    public let authMethods: [AuthMethod]
    
    init(csrfToken: String, trackId: String, useNewSuggestByPhone: Bool, rfc2fa: Bool, canAuthorize: Bool, preferredAuthMedtod: AuthMethod, authMethods: [AuthMethod]) {
        self.csrfToken = csrfToken
        self.trackId = trackId
        self.useNewSuggestByPhone = useNewSuggestByPhone
        self.rfc2fa = rfc2fa
        self.canAuthorize = canAuthorize
        self.preferredAuthMedtod = preferredAuthMedtod
        self.authMethods = authMethods
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.csrfToken = try container.decode(String.self, forKey: .csrf_token)
        self.trackId = try container.decode(String.self, forKey: .track_id)
        self.useNewSuggestByPhone = (try? container.decodeIfPresent(Bool.self, forKey: .use_new_suggest_by_phone)) ?? false
        self.rfc2fa = (try? container.decodeIfPresent(Bool.self, forKey: .is_rfc_2fa_enabled)) ?? false
        self.canAuthorize = (try? container.decodeIfPresent(Bool.self, forKey: .can_authorize)) ?? false
        let preferredMethod = (try? container.decodeIfPresent(String.self, forKey: .preferred_auth_method)) ?? AuthMethod.password.rawValue
        self.preferredAuthMedtod = AuthMethod(rawValue: preferredMethod) ?? AuthMethod.password
        let allAuthMethods: [String] = (try? container.decodeIfPresent([String].self, forKey: .auth_methods)) ?? []
        var methods: [AuthMethod] = []
        for method in allAuthMethods {
            guard let parsed = AuthMethod(rawValue: method) else {continue}
            methods.append(parsed)
        }
        if (methods.isEmpty) {
            methods = [self.preferredAuthMedtod]
        }
        self.authMethods = methods
    }
}
