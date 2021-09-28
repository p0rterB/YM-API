//
//  Icon.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents icon
public class Icon: Decodable {
    
    ///background color in HEX
    public let backgroundColor: String
    ///Image url
    public let imageUrl: String

    public init(backgroundColor: String, imageUrl: String) {
        self.backgroundColor = backgroundColor
        self.imageUrl = imageUrl
    }
    
    ///Downloads image
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadIcon(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        let size = String(width) + "x" + String(height)
        let urlStr = "https://" + imageUrl.replacingOccurrences(of: "%%", with: size)
        download(fullPath: urlStr, completion: completion)
    }
}
