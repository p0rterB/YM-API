//
//  PoetryLovelMatch.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Track lyrics TODO
public class PoetryLoverMatch: Decodable {
    //Некая разметка для обучения чего-нибудь для написания романтических стихотворений.
    
    ///Begin index
    public let begin: Int
    ///End index
    public let end: Int
    ///Line index
    public let line: Int

    public init(begin: Int, end: Int, line: Int) {
        self.begin = begin
        self.end = end
        self.line = line
    }
}
