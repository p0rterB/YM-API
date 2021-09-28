//
//  User.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represents user account data
public class User: Decodable {
    
    ///User ID
    public let uid: Int
    ///User login
    public let login: String
    ///User name
    public let name: String?
    ///User display name
    public let displayName: String?
    ///User full name
    public let fullName: String?
    ///User sex
    public let sex: String?
    ///Verified marker: User participates in 'playlist of a day' generation etc
    public let verified: Bool?
    ///Regions list
    public let regions: [Int]?

    public init(uid: Int, login: String, name: String?, displayName: String?, fullName: String?, sex: String?, verified: Bool?, regions: [Int]?) {
        self.uid = uid
        self.login = login

        self.name = name
        self.displayName = displayName
        self.fullName = fullName
        self.sex = sex
        self.verified = verified
        self.regions = regions
    }
    
    ///Downloads user avatar image
    ///- Parameter format: Available avatar sizes: normal, orig, small, big
    ///- Parameter completion: User avatar image data response handler
    public func downloadAvatarImg(format: String = "normal", completion: @escaping (Result<Data, YMError>) -> Void) {
        var urlStr = "https://upics.yandex.net/" + String(uid)
        if (format.compare("") != .orderedSame) {
            urlStr += "/" + format
        }
        download(fullPath: urlStr, completion: completion)
    }
}
