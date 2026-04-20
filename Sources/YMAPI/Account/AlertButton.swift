//
//  AlertButton.swift
//  yandexMusic-iOS
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents alert button (subscription state)
public class AlertButton: Decodable {
    
    ///Button label
    public let text: String
    ///Button background
    public let bgColor: String
    ///Button label color
    public let textColor: String
    ///Button url
    public let uri: String

    public init(text: String, bgColor: String, textColor: String, uri: String) {
        self.text = text
        self.bgColor = bgColor
        self.textColor = textColor
        self.uri = uri
    }
}
