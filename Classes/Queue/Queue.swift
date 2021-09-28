//
//  Queue.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Tracks queue
public class Queue: Codable {
    
    ///Queue ID
    public var id: String?
    ///Queue context data (about playlist, album or others)
    public let context: QueueContext?
    ///Tracks IDs list
    public let tracks: [TrackId]
    ///Current track index
    fileprivate var currentIndex: Int
    public var currIndex: Int {
        get {return currentIndex}
    }
    public var currentTrack: TrackId {
        get {return tracks[currentIndex]}
    }
    ///Date of last modification (ISO 8601)
    public var modified: String
    ///Queue source
    public let from: String?
    
    public var modifyDate: Date? {
        get {return DateUtil.fromIsoFormat(dateStr: modified)}
    }
    
    init(context: QueueContext?, tracks: [TrackId], currentIndex: Int, modified: String, id: String?, from: String?) {
        self.context = context
        self.tracks = tracks
        self.currentIndex = currentIndex
        self.modified = modified

        self.id = id
        self.from = from
    }
    
    ///Creates new queue with defined tracks and start index for uploading data to back-end
    public static func initializeNewQueue(context: QueueContext, tracks: [TrackId], currentIndex: Int = 0) -> Queue {
        return Queue(context: context, tracks: tracks, currentIndex: currentIndex, modified: DateUtil.isoFormat(), id: nil, from: "player-default")
    }
    
    ///Updates queue index at back-end
    public func updateCurrentIndex(newIndex: Int, device: YMDevice, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_id = id {
            setQueueCurrentIndexByApi(token: accountSecret, queueId: g_id, newIndex: newIndex, device: device.deviceHeader) {
                result in
                if let g_success = try? result.get(), g_success {
                    self.currentIndex = newIndex
                }
                completion(result)
            }
        } else {
            completion(.failure(.invalidObject(objType: "Queue", description: "Queue ID is nil")))
        }
    }
}
