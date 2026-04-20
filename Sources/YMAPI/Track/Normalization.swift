//
//  Normalization.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//
///Track normalization data
public class Normalization: Decodable {
    
    //Gain value for audio signal applying
    public let gain: Float
    ///Peak audio signal wave point
    public let peak: Int
    
    public init(gain: Float, peak: Int) {
        self.gain = gain
        self.peak = peak
    }
}
