//
//  Promotion.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents promotion (differrent objects). NOT ALL 'promotionType's ADDED!!!
public class Promotion: YMBaseObject, Decodable {
    
    //Note: В цвете может как оказаться HEX (`#6c65a9`), так и какой-нибудь `transparent`. Ссылка со схемой отличается от просто ссылки наличием `yandexmusic://` в начале.
    
    ///Promotion UID
    public let promoId: String
    ///Promotion title
    public let title: String
    ///subtitle
    public let subtitle: String
    ///head title
    public let heading: String
    ///Title url
    public let titleUrl: String?
    ///Title url with scheme
    public let titleUrlScheme: String?
    ///Subtitle url
    public let subtitleUrl: String?
    ///Subtitle url with scheme
    public let subtitleUrlScheme: String?
    ///Promotion type
    public let category: String?
    ///Promotion description
    public let description: String?
    ///Promotion content url
    public let url: String?
    ///Promotion url with scheme
    public let urlScheme: String?
    ///Text color
    public let textColor: String?
    ///Background color
    public let background: String?
    ///Gradient TODO
    public let gradient: String?
    ///Image source url
    public let image: String?
    //Image alignment
    public let imagePosition: String?
    ///Promotion content type
    public let promotionType: String?
    ///TODO
    public let startDate: String?
    ///TODO
    public let pager: Pager?
    ///Promotion playlist (if exists only one)
    public let playlist: PromotionPlaylist?
    ///Promotion playlists (If exists 2 or more)
    public let playlists: [PromotionPlaylist]?
    ///Promotion album (if exists only one)
    public let album: Album?
    ///Promotion albums (If exists 2 or more)
    public let albums: [Album]?
    ///Promotion tags
    public let tags: [Tag]?

    public init(promoId: String, title: String, subtitle: String, heading: String, titleUrl: String?, titleUrlScheme: String?, subtitleUrl: String?, subtitleUrlScheme: String?, category: String?, description: String?, url: String?, urlScheme: String?, textColor: String?, background: String?, gradient: String?, image: String?, imagePosition: String?, promotionType: String?, startDate: String?, pager: Pager?, playlist: PromotionPlaylist?, playlists: [PromotionPlaylist]?, album: Album?, albums: [Album]?, tags: [Tag]?) {
        self.promoId = promoId
        self.title = title
        self.subtitle = subtitle
        self.heading = heading
        self.titleUrl = titleUrl
        self.titleUrlScheme = titleUrlScheme
        self.subtitleUrl = subtitleUrl
        self.subtitleUrlScheme = subtitleUrlScheme
        self.category = category
        self.description = description
        self.url = url
        self.urlScheme = urlScheme
        self.textColor = textColor
        self.background = background
        self.gradient = gradient
        self.image = image
        self.imagePosition = imagePosition
        self.promotionType = promotionType
        self.startDate = startDate
        self.pager = pager
        self.playlist = playlist
        self.playlists = playlists
        self.album = album
        self.albums = albums
        self.tags = tags
    }
    
    public func downloadImg(width: Int = 300, height: Int = 300, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_img = image {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_img.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        } else {
            completion(.failure(.general(errCode: -1, data: ["description": "Image url is nil"])))
        }
        
    }
}
