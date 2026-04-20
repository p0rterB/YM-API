//
//  QueuePlayerDelegate.swift
//  Rave
//
//  Created by Developer on 23.08.2021.
//

import Foundation
import YMAPI

protocol PlayerQueueDelegate {
    func radioStreamTracksUpdated(_ allTracks: [Track])
    func trackChanged(_ track: Track, queueIndex: Int)
    func playStateChanged(playing: Bool)
    func playbackPositionChanged(_ position: TimeInterval)
}
