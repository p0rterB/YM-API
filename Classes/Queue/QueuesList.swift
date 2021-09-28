//
//  QueuesList.swift
//  YM-API
//
//  Created by Developer on 02.09.2021.
//

///Represents active queses array for device
public class QueueList: Decodable {
    
    ///Active queues for device
    public let queues: [QueueItem]
    
    public init(queues: [QueueItem]) {
        self.queues = queues
    }
}
