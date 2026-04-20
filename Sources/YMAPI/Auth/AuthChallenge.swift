//
//  Auth2FaChallenge.swift
//  YM-API
//
//  Created by Developer on 04.06.2023.
//

import Foundation

public class AuthChallenge: Decodable {
    public let challengeType: String
    public var challenge: ChallengeType? {
        get {
            let parsed = ChallengeType(rawValue: challengeType)
            return parsed
        }
    }
    public let hint: String
    public let fieldValue: String
    public let errorText: String
    public let isSms2faChallenge: Bool?
    public let phoneId: UInt32?
    
    init(challengeType: String, hint: String, fieldValue: String, errorText: String, isSms2faChallenge: Bool?, phoneId: UInt32?) {
        self.challengeType = challengeType
        self.hint = hint
        self.fieldValue = fieldValue
        self.errorText = errorText
        self.isSms2faChallenge = isSms2faChallenge
        self.phoneId = phoneId
    }
}
