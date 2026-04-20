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
    ///Account not only user type marker
    public let hostedUser: Bool?
    ///Child account marker. Possibly allows to restricts content to children
    public let child: Bool
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
                child: Bool,
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
        self.child = child
        self.passportPhones = passportPhones
        self.birthday = birthday
        self.registeredAt = registeredAt
        self.hasInfoForAppMetrica = hasInfoForAppMetrica
    }
    
    ///Downloads user avatar image. Returns data only if user authorized by new system (passport.yandex)
    ///- Parameter size: Size of user avatar rect in pixels
    ///- Parameter completion: User avatar image data response handler
    public func downloadAvatar(size: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if (passportSecret.isEmpty) {
            completion(.failure(.invalidInputParameter(name: "xToken", description: "X Token is empty")))
            return
        }
        downloadAccountAvatarByApi(xToken: passportSecret, size: size) { result in
            do {
                let responseStatus = try result.get()
                if let g_avatarUrl = responseStatus.avatar_url {
                    download(fullPath: g_avatarUrl, completion: completion)
                    return
                }
                var message = "Unable to retrieve account avatar"
                if (responseStatus.errors != nil && responseStatus.errors!.count > 0) {
                    message += ": " + responseStatus.errors!.joined(separator: ";")
                }
                completion(.failure(.badResponseData(errCode: -1, data: ["description": message])))
            } catch {
                #if DEBUG
                print(error)
                #endif
                completion(.failure(.badResponseData(errCode: -1, data: ["description": "Unable to retrieve account avatar", "error": error])))
            }
        }
    }
}
