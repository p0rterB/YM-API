//
//  Product.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents buyable product
public class Product: Decodable {
    
    ///Product UID
    public let productId: String
    ///Product type
    public let type: String
    ///Product general duration
    public let commonPeriodDuration: String
    ///Product duration in days
    public let duration: Int
    ///Product trial duration in days
    public let trialDuration: Int
    ///Product price
    public let price: Price?
    ///Product feature
    public let feature: String
    ///Product debug marker
    public let debug: Bool
    ///Product contains Plus subscription marker
    public let plus: Bool
    ///Best price marker
    public let cheapest: Bool?
    ///Product title
    public let title: String?
    ///Propduct family (multy user) subscription marker
    public let familySub: Bool?
    ///Facebook button image url
    public let fbImage: String?
    ///Facebook button label
    public let fbName: String?
    ///Product family availability marker
    public let family: Bool?
    ///Product features
    public let features: [String]
    ///Product description
    public let description: String?
    ///Product availability marker
    public let available: Bool?
    ///Product trial period availability marker
    public let trialAvailable: Bool?
    ///Product trial period duration
    public let trialPeriodDuration: String?
    ///Product intro period duration
    public let introPeriodDuration: String?
    ///Product intro price
    public let introPrice: Price?
    ///Product start period duration (for smaller price)
    public let startPeriodDuration: String?
    ///Product start period price
    public let startPrice: Price?
    ///Trial period duration
    public let licenceTextParts: [Price]?
    ///Vendor trial period availability marker
    public let vendorTrialAvailable: Bool?
    ///Button label text
    public let buttonText: String?
    ///Button additional text
    public let buttonAdditionalText: String?
    ///Product available payment methods
    public let paymentMethodTypes: [String]

    public init(productId: String,
                type: String,
                commonPeriodDuration: String,
                duration: Int,
                trialDuration: Int,
                price: Price?,
                feature: String,
                debug: Bool,
                plus: Bool,
                cheapest: Bool?,
                title: String?,
                familySub: Bool?,
                fbImage: String?,
                fbName: String?,
                family: Bool?,
                features: [String],
                description: String?,
                available: Bool?,
                trialAvailable: Bool?,
                trialPeriodDuration: String?,
                introPeriodDuration: String?,
                introPrice: Price?,
                startPeriodDuration: String?,
                startPrice: Price?,
                licenceTextParts: [Price]?,
                vendorTrialAvailable: Bool?,
                buttonText: String?,
                buttonAdditionalText: String?,
                paymentMethodTypes: [String]) {
        self.productId = productId
        self.type = type
        self.commonPeriodDuration = commonPeriodDuration
        self.duration = duration
        self.trialDuration = trialDuration
        self.price = price
        self.feature = feature
        self.debug = debug
        self.plus = plus

        self.cheapest = cheapest
        self.title = title
        self.familySub = familySub
        self.fbImage = fbImage
        self.fbName = fbName
        self.family = family
        self.features = features
        self.description = description
        self.available = available
        self.trialAvailable = trialAvailable
        self.trialPeriodDuration = trialPeriodDuration
        self.introPeriodDuration = introPeriodDuration
        self.introPrice = introPrice
        self.startPeriodDuration = startPeriodDuration
        self.startPrice = startPrice
        self.licenceTextParts = licenceTextParts
        self.vendorTrialAvailable = vendorTrialAvailable
        self.buttonText = buttonText
        self.buttonAdditionalText = buttonAdditionalText
        self.paymentMethodTypes = paymentMethodTypes
    }
}
