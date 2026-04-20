//
//  Subscription.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///User account subscriptions info
public class Subscription: Decodable {
    
    ///Subscription existance marker
    public let hadAnySubscription: Bool?
    ///Renew reminder
    public let nonAutoRenewableRemainder: RenewableReminder?
    ///Subscription auto renew
    public let autoRenewable: [Autorenewable]?
    ///Family subscription auto renew
    public let familyAutoRenewable: [Autorenewable]?
    ///Cell provider services
    public let `operator`: [Operator]?
    ///Subscriptions with disabled auto renew
    public let nonAutoRenewable: [NonRenewable]?
    ///Trial period available marker
    public let canStartTrial: Bool?
    ///Mcdonalds TODO
    public let mcdonalds: Bool?
    ///End date
    public let end: String?

    public init(hadAnySubscription: Bool?,
                non_auto_renewable_remainder: RenewableReminder?,
                auto_renewable: [Autorenewable],
                family_auto_renewable: [Autorenewable],
                oper: [Operator],
                nonAutoRenewable: [NonRenewable],
                canStartTrial: Bool?,
                mcdonalds: Bool?, end: String?) {
        self.hadAnySubscription = hadAnySubscription
        self.nonAutoRenewableRemainder = non_auto_renewable_remainder
        self.autoRenewable = auto_renewable
        self.familyAutoRenewable = family_auto_renewable

        self.operator = oper
        self.nonAutoRenewable = nonAutoRenewable
        self.canStartTrial = canStartTrial
        self.mcdonalds = mcdonalds
        self.end = end
    }
}
