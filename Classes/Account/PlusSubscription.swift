//
//  PlusSubscription.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents Yandex Plus subscription
public class PlusSubscription: Decodable {
    
    ///Plus subscription active marker
    public let hasPlus: Bool
    ///Tutorial completed marker
    public let isTutorialCompleted: Bool

    public init(hasPlus: Bool, isTutorialCompleted: Bool) {
        self.hasPlus = hasPlus
        self.isTutorialCompleted = isTutorialCompleted
    }
}
