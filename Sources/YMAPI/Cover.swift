//
//  Cover.swift
//  YM-API
//
//  Created by Developer on 08.06.2021.
//

import Foundation

///Represents cover
public class Cover: Decodable {
    
    ///Cover type
    public let type: String?
    ///Cover image url
    public let uri: String?
    ///Cover items images url
    public let itemsUri: [String]?
    ///Cover image directory source
    public let dir: String?
    ///Version of the cover
    public let version: String?
    ///User-defined cover marker
    public let custom: Bool?
    ///User-defined cover marker
    public let isCustom: Bool?
    ///Author copyright
    public let copyrightName: String?
    ///Music owner copyright
    public let copyrightCline: String?
    ///Cover url prefix
    public let prefix: String?
    ///Error message
    public let error: String?
    
    public init(type: String?,
                uri: String?,
                itemsUri: [String]?,
                dir: String?,
                version: String?,
                custom: Bool?,
                isCustom: Bool?,
                copyrightName: String?,
                copyrightCline: String?,
                prefix: String?,
                error: String?) {
        self.type = type
        self.uri = uri
        self.itemsUri = itemsUri
        self.prefix = prefix
        self.dir = dir
        self.version = version
        self.custom = custom
        self.isCustom = isCustom
        self.copyrightName = copyrightName
        self.copyrightCline = copyrightCline
        self.error = error
    }
    
    ///Downloads image
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadImg(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_uri = uri {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_uri.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
            return
        }
        completion(.failure(.badRequest(errCode: -1, description: "Image url is nil")))
    }
    
    ///Downloads image for the defined item index
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter index: Image item uri index
    ///- Parameter completion: image data response handler
    public func donwloadImg(width: Int = 200, height: Int = 200, index: Int = -1, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_itemsUri = itemsUri, g_itemsUri.count > 0 {
            let size = String(width) + "x" + String(height)
            var urlStr = "https://"
            if (index >= 0) {
                urlStr += g_itemsUri[index].replacingOccurrences(of: "%%", with: size)
            } else {
                urlStr += urlStr.replacingOccurrences(of: "%%", with: size)
            }
            download(fullPath: urlStr, completion: completion)
        } else {downloadImg(width: width, height: height, completion: completion)}
    }
}
