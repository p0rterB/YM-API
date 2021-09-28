//
//  Images.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents genre image
public class GenreImage: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case img_208x208 = "208x208"
        case img_300x300 = "300x300"
    }
    
    ///Image 208x208 px url
    public let img_208x208: String?
    ///Image 300x300 px url
    public let img_300x300: String?

    public init(img_208: String?, img_300: String?) {
        self.img_208x208 = img_208
        self.img_300x300 = img_300
    }
    
    public func download_208(completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_img = img_208x208 {
            download(fullPath: g_img, completion: completion)
        }
    }
    
    public func download_300(completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_img = img_300x300 {
            download(fullPath: g_img, completion: completion)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.img_208x208 = try? container.decodeIfPresent(String.self, forKey: .img_208x208)
        self.img_300x300 = try? container.decodeIfPresent(String.self, forKey: .img_300x300)
    }
}
