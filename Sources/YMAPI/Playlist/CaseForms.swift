//
//  CasesForm.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Cases of name
public class CaseForms: Decodable {
    
    ///Именительный падеж
    public let nominative: String
    ///Родительный падеж
    public let genitive: String
    ///Дательный падеж
    public let dative: String
    ///Винительный падеж
    public let accusative: String
    ///Творительный падеж
    public let instrumental: String
    ///Предложный падеж
    public let prepositional: String

    public init(nominative: String, genitive: String, dative: String, accusative: String, instrumental: String, prepositional: String) {
        self.nominative = nominative
        self.genitive = genitive
        self.dative = dative
        self.accusative = accusative
        self.instrumental = instrumental
        self.prepositional = prepositional
    }      
}
