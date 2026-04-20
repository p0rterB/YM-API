//
//  ShotData.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///General info about Alisa's shot
public class ShotData: Decodable {
    
    ///Shot cover url (Alisa icon)
    public let coverUri: String
    ///Alisa shot audio url
    public let mdsUrl: String
    ///Shot lyrics
    public let shotText: String
    ///Shot type
    public let shotType: ShotType

    public init( coverUri: String, mdsUrl: String, shotTxt: String, shotType: ShotType) {
        self.coverUri = coverUri
        self.mdsUrl = mdsUrl
        self.shotText = shotTxt
        self.shotType = shotType
    }
    
    ///Download Alisa shot cover
    func downloadCover(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        let size = String(width) + "x" + String(height)
        let urlStr = "https://" + coverUri.replacingOccurrences(of: "%%", with: size)
        download(fullPath: urlStr, completion: completion)
    }
    
    ///Download Alisa's audio shot
    func downloadMds(completion: @escaping (Result<Data, YMError>) -> Void) {
        download(fullPath: mdsUrl, completion: completion)
    }
}
