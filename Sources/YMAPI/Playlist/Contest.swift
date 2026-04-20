//
//  Contest.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Contest TODO
public class Contest: Decodable {
    
    ///Contest UID
    public let contestId: String
    ///Contest status
    public let status: String
    ///Edit allowed marker
    public let canEdit: Bool
    ///Sent date
    public let sent: String?
    ///output date (ending date)
    public let withdrawn: String?

    public init(contestId: String, status: String, canEdit: Bool, sent: String?, withdrawn: String?) {
        self.contestId = contestId
        self.status = status
        self.canEdit = canEdit
        self.sent = sent
        self.withdrawn = withdrawn

        
    }
}
