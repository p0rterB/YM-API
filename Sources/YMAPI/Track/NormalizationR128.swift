//
//  NormalizationR128.swift
//  YM-API
//
//  Created by Developer on 20.07.2021.
//
///Represents track normalization data (R128 standard)
public class NormalizationR128: Decodable {
    
    //Volume integrated value
    public let i: Float
    ///True Peak Level
    public let tp: Float
    
    public init(i: Float, tp: Float) {
        self.i = i
        self.tp = tp
    }
}
