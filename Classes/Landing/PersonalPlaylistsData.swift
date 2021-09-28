//
//  PersonalPlaylistsData.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Personal playlist additional info provider
public class PersonalPlaylistsData: YMBaseObject, Decodable {
    
    ///TODO
    public let isWizardPassed: Bool

    public init(isWizardPassed: Bool) {
        self.isWizardPassed = isWizardPassed
    }
}
