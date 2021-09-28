//
//  Deactivation.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents service deactivation methods
public class Deactivation: Decodable {
    //Note:Известные значения поля `method`: `ussd`.
    
    ///Service deactivation method
    public let method: String
    ///Service deactivation manual
    public let instructions: String?
    
    public init(method: String, instructions: String?) {
        self.method = method
        self.instructions = instructions
    }
}
