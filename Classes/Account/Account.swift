//
//  Account.swift
//  yandexMusic-iOS
//
//  Created by Developer on 11.06.2021.
//

import Foundation

public class Account: Decodable {
    
    ///Date and time now
    public let now: String
    ///Service availability marker
    public let serviceAvailable: Bool
    ///Region ID
    public let region: Int?
    ///User UID
    public let uid: Int?
    ///Virtual name (usually e-mail)
    public let login: String?
    ///Full name (first name and last name)
    public let fullName: String?
    ///Last name
    public let secondName: String?
    ///First name
    public let firstName: String?
    ///Display name
    public let displayName: String?
    ///Является ли пользователем чьим-то другим.
    public let hostedUser: Bool?
    ///User birthday date
    public let birthday: String?
    ///Account mobile numbers
    public let passportPhones: [PassportPhone]?
    ///Account creation date
    public let registeredAt: String?
    ///App metrica info marker
    public let hasInfoForAppMetrica: Bool?
    
    public init(now: String,
                serviceAvailable: Bool,
                region: Int?,
                uid: Int?,
                login: String?,
                fullName: String?,
                secondName: String?,
                firstName: String?,
                displayName: String?,
                hostedUser: Bool?,
                birthday: String?,
                passportPhones: [PassportPhone]?,
                registeredAt: String?,
                hasInfoForAppMetrica: Bool? = false) {
        self.now = now
        self.serviceAvailable = serviceAvailable

        self.region = region
        self.uid = uid
        self.login = login
        self.fullName = fullName
        self.secondName = secondName
        self.firstName = firstName
        self.displayName = displayName
        self.hostedUser = hostedUser
        self.passportPhones = passportPhones
        self.birthday = birthday
        self.registeredAt = registeredAt
        self.hasInfoForAppMetrica = hasInfoForAppMetrica
    }
    
    ///Downloads user avatar image
    ///- Parameter format: Available avatar sizes: normal, orig, small, big
    ///- Parameter completion: User avatar image data response handler
    public func downloadAvatar(format: String = "normal", completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        let url = "https://upics.yandex.net/" + String(accountUidStr) + "/" + format
        download(fullPath: url, completion: completion)
    }
}
