//
//  Promotion.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents promotion (ads)
public class Promotion: YMBaseObject, Decodable {
    
    //Note: В цвете может как оказаться HEX (`#6c65a9`), так и какой-нибудь `transparent`. Ссылка со схемой отличается от просто ссылки наличием `yandexmusic://` в начале.
    
    ///Ads UID
    public let promoId: String
    ///Ads title
    public let title: String
    ///Ads subtitle
    public let subtitle: String
    ///Ads head title
    public let heading: String
    ///Ads url
    public let url: String
    ///Ads url with scheme
    public let urlScheme: String
    ///Text color
    public let textColor: String
    ///Gradient TODO
    public let gradient: String
    ///Ads image source url
    public let image: String

    public init(promoId: String, title: String, subtitle: String, heading: String, url: String, urlScheme: String, textColor: String, gradient: String, image: String) {
        self.promoId = promoId
        self.title = title
        self.subtitle = subtitle
        self.heading = heading
        self.url = url
        self.urlScheme = urlScheme
        self.textColor = textColor
        self.gradient = gradient
        self.image = image
    }
    
    public func downloadImg(width: Int = 300, height: Int = 300, completion: @escaping (Result<Data, YMError>) -> Void) {
        let size = String(width) + "x" + String(height)
        let urlStr = "https://" + image.replacingOccurrences(of: "%%", with: size)
        download(fullPath: urlStr, completion: completion)
    }
}
