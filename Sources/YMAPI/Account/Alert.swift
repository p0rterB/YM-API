//
//  Alert.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Presents alert block
public class Alert: Decodable {
    
    //Note: Данные предупреждения, скорее всего, только обкатываются. У них нет ID, вместо этого `xxx`, а еще присутствуют слова "тест" в тексте. Используют как предупреждение о конце подписки, так и о раздаче подарков.
    
    ///Alert UID
    public let alertId: String
    ///Alert text
    public let text: String
    ///Alert backgroudn color
    public let bgColor: String
    ///Alert text color
    public let textColor: String
    ///Alert type
    public let alertType: String
    ///Button with url
    public let button: AlertButton
    ///Close button marker
    public let closeButton: Bool
    
    public init(alertId: String, text: String, bgColor: String, textColor: String, alertType: String, button: AlertButton, closeButton: Bool) {
        self.alertId = alertId
        self.text = text
        self.bgColor = bgColor
        self.textColor = textColor
        self.alertType = alertType
        self.button = button
        self.closeButton = closeButton
    }
}
