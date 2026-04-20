//
//  XAuthenticateObj.swift
//  YM-API
//
//  Created by Developer on 20.10.2021.
//

import Foundation

///Represents response from passport.yandex system
public class XPassportObj: Decodable {
    
    ///Authorization process status
    public let status: String
    ///Autjorization errors
    public let errors: [String]?
    ///Access token life duration in seconds
    public let access_token_expires_in: Int?
    ///User public ID
    public let public_id: String?
    ///Autheticated user ID
    public let uid: Int?
    ///User first name
    public let firstname: String?
    ///User last name
    public let lastname: String?
    ///X Token life duration in seconds
    public let x_token_expires_in: Int?
    ///Cloud token
    public let cloud_token: String?
    ///User birthday
    public let birthday: String?
    ///TODO
    public let has_password: Bool?
    ///TODO
    public let primary_alias_type: Int?
    ///X Token data
    public let x_token: String?
    ///User display name
    public let display_name: String?
    ///Access token data
    public let access_token: String?
    ///user gender
    public let gender: String?
    ///User normalized login
    public let normalized_display_login: String?
    ///X Token access start timestamp
    public let x_token_issued_at: Int?
    ///User display login
    public let display_login: String?
    ///User public name
    public let public_name: String?
    ///User avatar URL
    public let avatar_url: String?
    ///User email
    public let native_default_email: String?
    
    public init(status: String, errors: [String]?, access_token_expires_in: Int?, public_id: String?, uid: Int?,
    firstname: String?, lastname: String?, x_token_expires_in: Int?, cloud_token: String?, birthday: String?,
    has_password: Bool?, primary_alias_type: Int?, x_token: String?, display_name: String?, access_token: String?,
    gender: String?, normalized_display_login: String?, x_token_issued_at: Int?, display_login: String?,
    public_name: String?, avatar_url: String?, native_default_email: String?) {
        self.status = status
        self.errors = errors
        self.access_token_expires_in = access_token_expires_in
        self.public_id = public_id
        self.uid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.x_token_expires_in = x_token_expires_in
        self.cloud_token = cloud_token
        self.birthday = birthday
        self.has_password = has_password
        self.primary_alias_type = primary_alias_type
        self.x_token = x_token
        self.display_name = display_name
        self.access_token = access_token
        self.gender = gender
        self.normalized_display_login = normalized_display_login
        self.x_token_issued_at = x_token_issued_at
        self.display_login = display_login
        self.public_name = public_name
        self.avatar_url = avatar_url
        self.native_default_email = native_default_email
    }
}
