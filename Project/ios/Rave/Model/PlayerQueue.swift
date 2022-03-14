//
//  PlayerQueue.swift
//  Rave
//
//  Created by Developer on 23.08.2021.
//

import MediaPlayer
import YmuzApi

class PlayerQueue: NSObject, AVAudioPlayerDelegate {
    
    fileprivate var _queueKey: Int
    var queueKey: Int {get {return _queueKey}}
    fileprivate var _playFlags: BitBool8
    fileprivate var _currIndex: Int = -1
    fileprivate var _tracks: [Track] = []
    var tracks: [Track]
    {
        get {
            return _tracks
        }
    }
    var currIndex: Int {
        return _currIndex
    }
    var currTrack: Track? {
        get {
            if (_tracks.count == 0 || _currIndex < 0 || _currIndex >= _tracks.count ) {
                return nil
            }
            return tracks[_currIndex]
        }
    }
    var playing: Bool {
        get {
            #if DEBUG
            print("Player: time control status", _player.timeControlStatus.rawValue, "; rate", _player.rate)
            if let g_err = _player.error {
                print("Player error", g_err)
            }
            if let g_currItem = _player.currentItem, let g_err = g_currItem.error {
                print("Player current item: error", g_err)
            }
            #endif
            
            return _player.timeControlStatus == .playing || (_player.rate != 0 && _player.error == nil && _player.currentItem?.error == nil)
        }
        
    }
    
    fileprivate var _delegate: PlayerQueueDelegate?
    var playerDelegate: PlayerQueueDelegate? {get {return _delegate}}
    fileprivate var _playerWidgetDelegate: PlayerQueueDelegate?
    fileprivate var _player: AVPlayer
    var trackPlaybackPosition: TimeInterval {
        get {
            let position = _player.currentTime().seconds
            return position.isFinite ? position : 0
        }
    }
    var trackPlaybackPositionFormatted: String {
        get {
            return DateUtil.formattedTrackTime(trackPlaybackPosition)
        }
    }
    var trackDuration: TimeInterval {
        get
        {
            if let g_currTrack = currTrack {
                return TimeInterval(g_currTrack.durationMs) / 1000
            }
            return TimeInterval(_player.currentItem?.duration.seconds ?? 0)
            
        }
    }
    var trackDurationFormatted: String {
        get {
            return DateUtil.formattedTrackTime(trackDuration)
        }
    }
    
    var shuffleTracks: Bool {
        get { return _playFlags.getFlagPropertyValue(for: 0) }
        set {
            _playFlags.setFlagPropertyValue(for: 0, value: newValue)
        }
    }
    
    var repeatTracks: Bool {
        get { return _playFlags.getFlagPropertyValue(for: 1) }
    }
    
    var repeatSingleTrack: Bool {
        get { return _playFlags.getFlagPropertyValue(for: 2) }
    }
    
    init(queueKey: Int, tracks: [Track], playIndex: Int, playNow: Bool, playerWidgetDelegate: PlayerQueueDelegate?, delegate: PlayerQueueDelegate?) {
        _playFlags = BitBool8(initVal: 0)
        _queueKey = queueKey
        _tracks = tracks
        _currIndex = playIndex
        _player = AVPlayer()
        _player.automaticallyWaitsToMinimizeStalling = false
        _player.allowsExternalPlayback = true
        super.init()        
        setupRemoteTransportControls()
        _delegate = delegate
        _playerWidgetDelegate = playerWidgetDelegate
        if (playNow) {
            initPlay()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let g_avItem = object as? AVPlayerItem {
            if keyPath == "status", g_avItem.status == .failed {
                if let g_statusErr = g_avItem.error {
    #if DEBUG
                    print(g_statusErr)
    #endif
                    _ = pauseTrack(force: true)
                }
            }
            else if keyPath == "isPlaybackLikelyToKeepUp" && !playing {
                #if DEBUG
                print("Observe value for player item 'isPlaybackLikelyToKeepUp' and track isn't playing -> resuming...")
                #endif
                _ = playTrack()
            }
        }
    }
    
    
    func toggleShuffleTracks() {
        shuffleTracks = !shuffleTracks
    }
    
    func toggleRepeatMode() {
        if (!repeatTracks && !repeatSingleTrack) {
            _playFlags.setFlagPropertyValue(for: 1, value: true)
        }
        else if (repeatTracks && !repeatSingleTrack) {
            _playFlags.setFlagPropertyValue(for: 1, value: false)
            _playFlags.setFlagPropertyValue(for: 2, value: true)
        }
        else if (!repeatTracks && repeatSingleTrack) {
            _playFlags.setFlagPropertyValue(for: 1, value: false)
            _playFlags.setFlagPropertyValue(for: 2, value: false)
        }
        else {
            _playFlags.setFlagPropertyValue(for: 1, value: false)
            _playFlags.setFlagPropertyValue(for: 2, value: false)
        }
    }
    
    func dislikeTrack(_ track: Track) -> Bool {
        for i in 0 ... _tracks.count {
            let queueTrack = _tracks[i]
            if (track.id.compare(queueTrack.id) == .orderedSame) {
                if (currIndex == i && playing) {
                    //current playing track
                    let result = playNextTrack()
                    #if DEBUG
                    print("Next track after dislike procedure:", result)
                    #endif
                    return result
                }
                return true
            }
        }
        return false
    }
    
    func setPlayingTrackByIndex(_ index: Int, playNow: Bool = true) {
        if (index >= 0 && index < _tracks.count) {
            _currIndex = index
            if (playing)
            {
                _player.pause()
                let seekTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC))
                _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                _delegate?.playStateChanged(playing: false)
                _playerWidgetDelegate?.playStateChanged(playing: false)
            }
            if let g_track = currTrack {
                _delegate?.trackChanged(g_track, queueIndex: _currIndex)
                _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
            }
            setupNowPlaying()
            if (playNow) {
                initPlay()
            }
        }
    }
    
    func setNewTracks(_ tracks: [Track], queueKey: Int, playIndex: Int = 0, playNow: Bool = true) {
        if (playing) {
            _player.pause()
            let seekTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC))
            _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            _delegate?.playStateChanged(playing: false)
            _playerWidgetDelegate?.playStateChanged(playing: false)
        } else {
            do {
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print(error)
            }
        }
        _tracks = tracks
        _queueKey = queueKey
        _currIndex = playIndex
        if let g_track = currTrack {
            _delegate?.trackChanged(g_track, queueIndex: _currIndex)
            _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
        }
        setupNowPlaying()
        if (playNow) {
            initPlay()
        }
    }
    
    func setDelegateHandler(_ delegate: PlayerQueueDelegate?) {
        _delegate = delegate
    }
    
    func setPlayerWidgetDelegateHandler(_ delegate: PlayerQueueDelegate) {
        _playerWidgetDelegate = delegate
    }
    
    func playPreviousTrack(play: Bool = true) -> Bool {
        if (trackPlaybackPosition > 5) {
            let seekTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC))
            _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
            return true
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: _player.currentItem)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemPlaybackStalled, object: _player.currentItem)
        _player.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
        _player.currentItem?.removeObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp", context: nil)
        if (_currIndex - 1 >= 0 && _currIndex < _tracks.count) {
            _currIndex -= 1
            if (playing) {
                _player.pause()
                let seekTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC))
                _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _player.currentTime().seconds
                _delegate?.playStateChanged(playing: false)
                _playerWidgetDelegate?.playStateChanged(playing: false)
            }
            while _currIndex >= 0 && tracks[_currIndex].available == false {
                _currIndex -= 1
            }
            if let g_track = currTrack, g_track.available == true {
                _delegate?.trackChanged(g_track, queueIndex: _currIndex)
                _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
            } else {
                clearNowPlaying()
                _player.replaceCurrentItem(with: nil)
                return true
            }
            setupNowPlaying()
            if (play) {
                initPlay()
            }
            return true
        }
        return false
    }
    
    @objc fileprivate func previous(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return playPreviousTrack() ? .success : .commandFailed
    }
    
    func playNextTrack(play: Bool = true) -> Bool {
        if (_currIndex < _tracks.count) {
            if (playing) {
                _player.pause()
                let seekTime: CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC))
                _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _player.currentTime().seconds
                _delegate?.playStateChanged(playing: false)
                _playerWidgetDelegate?.playStateChanged(playing: false)
            }
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: _player.currentItem)
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemPlaybackStalled, object: _player.currentItem)
            _player.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
            _player.currentItem?.removeObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp", context: nil)
            if (_currIndex + 1 < tracks.count) {
                _currIndex += 1
                while _currIndex < tracks.count && tracks[_currIndex].available == false {
                    _currIndex += 1
                }
                
                if let g_track = currTrack, g_track.available == true {
                    _delegate?.trackChanged(g_track, queueIndex: _currIndex)
                    _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
                    setupNowPlaying()
                    if (play) {
                        initPlay()
                    }
                    return true
                }
            } else {
#if DEBUG
                print("Last track. Can't move forward")
#endif
                
                clearNowPlaying()
                _player.replaceCurrentItem(with: nil)
                return true
            }
        }
        return false
    }
    
    @objc fileprivate func forward(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return playNextTrack() ? .success : .commandFailed
    }
    
    func setPlaybackPosition(position: TimeInterval) -> Bool {
        if (position < 0 || trackDuration < position) {
            return false
        }
        let seekTime: CMTime = CMTimeMakeWithSeconds(position, preferredTimescale: Int32(NSEC_PER_SEC))
        _player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTime.seconds
        return true
    }
    
    @objc fileprivate func changePlaybackPosition(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        if let g_event = event as? MPChangePlaybackPositionCommandEvent {
            let seconds = g_event.positionTime
            let seekTime: CMTime = CMTimeMakeWithSeconds(seconds, preferredTimescale: Int32(NSEC_PER_SEC))
            self._player.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            _delegate?.playbackPositionChanged(seconds)
            return .success
        }
        return .commandFailed
    }
    
    
    func initPlay() {
        if (_currIndex >= 0 || _currIndex < _tracks.count) {
            let currTrack = _tracks[_currIndex]
            let bitrate = appService.properties.trafficEconomy ? TrackBitrate.kbps_64 : TrackBitrate.kbps_192
            let codec = appService.properties.trafficEconomy ? TrackCodec.aac : TrackCodec.mp3
            if let g_link = currTrack.getDownloadLinkSync(codec: codec, bitrate: bitrate), let g_url = URL(string: g_link) {
                let item = AVPlayerItem(url: g_url)
                _player.replaceCurrentItem(with: item)
                setupNowPlaying()
                //End play handler
                NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
                //Track buffering error
                NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerStalledError(_:)), name: .AVPlayerItemPlaybackStalled, object: item)
                //Track load properties
                item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
                item.addObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp", options: .new, context: nil)
                _player.play()
                if let g_track = self.currTrack {
                    self._playerWidgetDelegate?.trackChanged(g_track, queueIndex: self._currIndex)
                    self._playerWidgetDelegate?.playStateChanged(playing: true)
                    self._delegate?.trackChanged(g_track, queueIndex: self.currIndex)
                    self._delegate?.playStateChanged(playing: true)
                }
            } else {
                self.setupNowPlaying()
                DispatchQueue.global(qos: .background).async {
                    currTrack.getDownloadLink(codec: codec, bitrate: bitrate) { result in
                        currTrack.fetchAllDownloadlinks()
                        do {
                            let link = try result.get()
                            DispatchQueue.main.async {
                                if let g_url = URL(string: link) {
                                    let item = AVPlayerItem(url: g_url)
                                    self._player.replaceCurrentItem(with: item)
                                    self.setupNowPlaying()
                                    //End play handler
                                    NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerDidFinishPlaying(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: item)
                                    //Track buffering error
                                    NotificationCenter.default.addObserver(self, selector: #selector(self.audioPlayerStalledError(_:)), name: .AVPlayerItemPlaybackStalled, object: item)
                                    //Track load properties
                                    item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
                                    item.addObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp", options: .new, context: nil)
                                    self._player.play()
                                    if let g_track = self.currTrack {
                                        self._playerWidgetDelegate?.trackChanged(g_track, queueIndex: self._currIndex)
                                        self._playerWidgetDelegate?.playStateChanged(playing: true)
                                        self._delegate?.trackChanged(g_track, queueIndex: self.currIndex)
                                        self._delegate?.playStateChanged(playing: true)
                                    }
                                }
                            }
                        } catch {
                            #if DEBUG
                            print(error)
                            #endif
                        }
                    }
                }
            }
        }
    }
    
    func pauseTrack(force: Bool = false) -> Bool {
        if (playing || force) {
            _player.pause()
            _delegate?.playStateChanged(playing: false)
            _playerWidgetDelegate?.playStateChanged(playing: false)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _player.currentTime().seconds
            return true
        }
        return false
    }
    
    @objc fileprivate func pause(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return pauseTrack() ? .success : .noActionableNowPlayingItem
    }
    
    func playTrack() -> Bool {
        if let g_currItem = _player.currentItem {
            if (!playing) {
                _player.play()
                MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = g_currItem.currentTime().seconds
                _delegate?.playStateChanged(playing: true)
                _playerWidgetDelegate?.playStateChanged(playing: true)
            }
            return true
        }
        return false
    }
    
    @objc fileprivate func play(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return playTrack() ? .success : .noSuchContent
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.seekForwardCommand.isEnabled = false
        commandCenter.seekBackwardCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPosition))
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(play))
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(pause))
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(forward))
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(previous))
    }
    
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = AppService.localizedString(.player_unknown_track_title)
        nowPlayingInfo[MPMediaItemPropertyArtist] = AppService.localizedString(.player_unknown_track_artists)
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 256, height: 256), requestHandler: { size in
            return UIImage(named: "playlist_template") ?? UIImage()
        })
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _player.currentTime().seconds
        
        if let g_track = currTrack {
            nowPlayingInfo[MPMediaItemPropertyTitle] = g_track.title ?? AppService.localizedString(.player_unknown_track_title)
            nowPlayingInfo[MPMediaItemPropertyArtist] = g_track.artistsName.joined(separator: ",")
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = g_track.durationMs / 1000
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    
    @objc func audioPlayerStalledError(_ notification: Notification) {
#if DEBUG
        print("Playback stalled pause. Waiting for buffering track 1 sec")
#endif
        //TODO check for internet connection: false -> pauseTrack
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            _ = self.pauseTrack(force: true)
            _ = self.playTrack()
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(_ notification: Notification) {
        if (repeatSingleTrack) {
            clearNowPlaying()
            let result = setPlaybackPosition(position: TimeInterval(0.0))
    #if DEBUG
            print("Current track repeat play: " + String(result))
    #endif            
            setupNowPlaying()
            _player.play()
            return
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: _player.currentItem)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemPlaybackStalled, object: _player.currentItem)
        _player.currentItem?.removeObserver(self, forKeyPath: "status", context: nil)
        _player.currentItem?.removeObserver(self, forKeyPath: "isPlaybackLikelyToKeepUp", context: nil)
        if (_currIndex + 1 < _tracks.count) {
            _currIndex += 1
            if let g_track = currTrack {
                _delegate?.trackChanged(g_track, queueIndex: _currIndex)
                _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
            }
            initPlay()
        } else {
            if (repeatTracks) {
                _currIndex = 0
#if DEBUG
        print("Tracks play repeat")
#endif
                if let g_track = currTrack {
                    _delegate?.trackChanged(g_track, queueIndex: _currIndex)
                    _playerWidgetDelegate?.trackChanged(g_track, queueIndex: _currIndex)
                }
                initPlay()
                return
            }
            clearNowPlaying()
            _player.replaceCurrentItem(with: nil)
        }
    }
}
