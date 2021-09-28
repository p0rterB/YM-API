//
//  StationResult.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Represents radio station object
public class StationResult: Decodable {
    
    ///Radio station info
    public let station: Station?
    ///Radio station title (russian)
    public let rupTitle: String?
    ///Radio station description (russian)
    public let rupDescription: String?
    ///Radio station settings set
    public let settings: RotorSettings?
    ///Radio station settings set
    public let settings2: RotorSettings?
    ///Advertisement settings
    public let adParams: AdParams?
    ///TODO
    public let explanation: String?
    ///Prerolls TODO
    public let prerolls: [String]?
    
    public init(station: Station?, rupTitle: String?, rupDescription: String?, settings: RotorSettings?, settings2: RotorSettings?, adParams: AdParams?, explanation: String?, prerolls: [String]?) {
        self.station = station
        self.rupTitle = rupTitle
        self.rupDescription = rupDescription
        self.settings = settings
        self.settings2 = settings2
        self.adParams = adParams
        self.explanation = explanation
        self.prerolls = prerolls
    }
}
