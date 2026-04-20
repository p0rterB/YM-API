//
//  AdParams.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Advertisement parameters
public class AdParams: Decodable {
    
    /*partner_id (:obj:`str` | :obj:`int`): Уникальный идентификатор заказчика рекламы.
    category_id (:obj:`str` | :obj:`int`): Уникальный идентификатор категории рекламы.
    page_ref (:obj:`str`): Ссылка на ссылающуюся страницу.
    target_ref (:obj:`str`): Ссылка на целевую страницу.
    other_params (:obj:`str`): Другие параметры.
    ad_volume (:obj:`int`): Громкость воспроизводимой рекламы.
    genre_id (:obj:`str`): Уникальный идентификатор жанра.
    genre_name (:obj:`str`): Название жанра.
    client (:obj:`yandex_music.Client`): Клиент Yandex Music.*/
    
    enum CodingKeys: CodingKey {
        case partnerId
        case categoryId
        case pageRef
        case targetRef
        case otherParams
        case adVolume
        case genreId
        case genreName
    }
    
    public let partnerId: String
    public let categoryId: String
    public let pageRef: String
    public let targetRef: String
    public let otherParams: String
    public let adVolume: Int
    public let genreId: String?
    public let genreName: String?

    public init(partnerId: String, categoryId: String, pageRef: String, targetRef: String, otherParams: String, adVolume: Int, genreId: String?, genreName: String?) {
        self.partnerId = partnerId
        self.categoryId = categoryId
        self.pageRef = pageRef
        self.targetRef = targetRef
        self.otherParams = otherParams
        self.adVolume = adVolume

        self.genreId = genreId
        self.genreName = genreName
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var buff: String = ""
        do {
            buff = try container.decode(String.self, forKey: .partnerId)
        } catch {
            let valueInt = (try? container.decodeIfPresent(Int.self, forKey: .partnerId)) ?? 0
            buff = String(valueInt)
        }
        self.partnerId = buff
        
        buff = ""
        do {
            buff = try container.decode(String.self, forKey: .categoryId)
        } catch {
            let valueInt = (try? container.decodeIfPresent(Int.self, forKey: .categoryId)) ?? 0
            buff = String(valueInt)
        }
        self.categoryId = buff

        self.pageRef = try container.decode(String.self, forKey: .pageRef)
        self.targetRef = try container.decode(String.self, forKey: .targetRef)
        self.otherParams = try container.decode(String.self, forKey: .otherParams)
        self.adVolume = try container.decode(Int.self, forKey: .adVolume)
        
        buff = ""
        do {
            buff = try container.decode(String.self, forKey: .genreId)
        } catch {
            let valueInt = (try? container.decodeIfPresent(Int.self, forKey: .genreId)) ?? 0
            buff = String(valueInt)
        }
        self.genreId = buff
        self.genreName = try? container.decodeIfPresent(String.self, forKey: .genreName)
    }
}
