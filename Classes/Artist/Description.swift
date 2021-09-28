//
//  Description.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Artist description from other source
public class Description: Decodable {
    //Note: Очень редкий объект, у минимального количества исполнителей. Обычно берётся информация из википедии.
    
    ///Artist description
    public let text: String
    ///Artist description url
    public let uri: String

    public init(text: String, uri: String) {
        self.text = text
        self.uri = uri
    }
}
