//
//  MixLink.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents url (clickable url) to chart
public class MixLink: YMBaseObject, Decodable {
    
    //Note: В цветах может как оказаться HEX (`#6c65a9`), так и какой-нибудь `transparent`. Ссылка со схемой отличается от просто ссылки наличием `yandexmusic://` в начале.
    
    ///Url text
    public let title: String
    ///Url payload
    public let url: String
    ///Scheme url
    public let urlScheme: String
    public let textColor: String
    public let backgroundColor: String
    ///Background image url
    public let backgroundImageUri: String
    ///Cover image url TODO
    public let coverWhite: String
    ///Cover image
    public let coverUri: String?

    public init(title: String, url: String, urlScheme: String, textColor: String, backgroundColor: String, backgroundImageUri: String, coverWhite: String, coverUri: String?) {
        self.title = title
        self.url = url
        self.urlScheme = urlScheme
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.backgroundImageUri = backgroundImageUri
        self.coverWhite = coverWhite

        self.coverUri = coverUri
    }
    
    public func downloadBackgroundImage(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        let size = String(width) + "x" + String(height)
        let urlStr = "https://" + backgroundImageUri.replacingOccurrences(of: "%%", with: size)
        download(fullPath: urlStr, completion: completion)
    }
    
    public func downloadCoverWhite(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        let size = String(width) + "x" + String(height)
        let urlStr = "https://" + coverWhite.replacingOccurrences(of: "%%", with: size)
        download(fullPath: urlStr, completion: completion)
    }
    
    public func downloadCoverUrl(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_coverUri = coverUri {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_coverUri.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }
}
