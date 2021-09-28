//
//  QueueItem.swift
//  YM-API
//
//  Created by Admin on 03.06.2021.
//

import Foundation

///Tracks queue in devices' queue list
public class QueueItem: Decodable {
    
    ///Queue UID
    public let id: String
    ///Queue object descriptor
    public let context: QueueContext?
    ///Date of last modification
    public let modified: String
    
    public var modifyDate: Date? {
        get {return DateUtil.fromIsoFormat(dateStr: modified)}
    }

    public init(id: String, context: QueueContext?, modified: String) {
        self.id = id
        self.context = context
        self.modified = modified
    }
    
    ///Gets queue info from API
    public func fetchQueue(completion: @escaping (_ result: Result<Queue, YMError>) -> Void) {
        getQueueDataByApi(token: accountSecret, queueId: id, completion: completion)
    }
}
