//
//  unit_testPlaylistApiTests.swift
//  YM-macTests
//
//  Created by Developer on 20.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_PlaylistApiTests: XCTestCase {

    let trackShortJson =  "{\"id\":33943347,\"track\":{\"id\":\"33943347\",\"realId\":\"33943347\",\"title\":\"Couple Pills\",\"version\":\"feat. Jez Dior\",\"contentWarning\":\"explicit\",\"major\":{\"id\":146,\"name\":\"EMPIRE\"},\"available\":true,\"availableForPremiumUsers\":true,\"availableFullWithoutPermission\":false,\"durationMs\":224490,\"storageDir\":\"51327_109b74ca.36526310.1.609676\",\"fileSize\":0,\"normalization\":{\"gain\":-9.21,\"peak\":30579},\"r128\":{\"i\":-7.47,\"tp\":1.43},\"previewDurationMs\":30000,\"artists\":[{\"id\":4172223,\"name\":\"12AM\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"prefix\":\"8ded7e54.a.9680694-1\",\"uri\":\"avatars.yandex.net/get-music-content/175191/8ded7e54.a.9680694-1/%%\"},\"genres\":[]},{\"id\":3151600,\"name\":\"Jez Dior\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"prefix\":\"a5221dab.a.12034511-1\",\"uri\":\"avatars.yandex.net/get-music-content/2386207/a5221dab.a.12034511-1/%%\"},\"genres\":[]}],\"albums\":[{\"id\":4158732,\"title\":\"Afterparty\",\"metaType\":\"music\",\"contentWarning\":\"explicit\",\"year\":2017,\"releaseDate\":\"2017-03-17T00:00:00+03:00\",\"coverUri\":\"avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%\",\"genre\":\"foreignrap\",\"buy\":[],\"trackCount\":8,\"likesCount\":19,\"recent\":false,\"veryImportant\":false,\"artists\":[{\"id\":4172223,\"name\":\"12AM\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"prefix\":\"8ded7e54.a.9680694-1\",\"uri\":\"avatars.yandex.net/get-music-content/175191/8ded7e54.a.9680694-1/%%\"},\"genres\":[]}],\"labels\":[{\"id\":942045,\"name\":\"Funeral Crew\"},{\"id\":5758,\"name\":\"EMPIRE\"}],\"available\":true,\"availableForPremiumUsers\":true,\"availableForMobile\":true,\"availablePartially\":false,\"bests\":[33943349,33943347],\"trackPosition\":{\"volume\":1,\"index\":2}}],\"coverUri\":\"avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%\",\"lyricsAvailable\":true,\"type\":\"music\",\"rememberPosition\":false,\"trackSharingFlag\":\"COVER_ONLY\"},\"timestamp\":\"2021-07-20T03:00:00+00:00\",\"originalIndex\":0,\"recent\":false}"
    
    var client: YMClient!
    var device: YMDevice {get {return TestConstants.device}}
    var apiLang: ApiLanguage {get {return TestConstants.apiLang}}
    var token: String {get {return TestConstants.token}}
    var xToken: String {get {return TestConstants.xToken}}
    var uid: Int {get {return TestConstants.uid}}
    
    override func setUp() {
        client = YMClient.initialize(device: device, lang: apiLang, uid: uid, token: token, xToken: xToken)
    }
    
    override func tearDown() {
        client = nil
    }
    
    func testDailyPlaylistResponse() {
        let uid = "503646255"//yamusic-daily
        let playlistId = "133005399"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getPlaylists(userId: uid, playlistsId: [playlistId]) { result in
            do {
                let playlist = try result.get()
                XCTAssertNotNil(playlist, "Playlist is nil")
                XCTAssert(playlist.count == 1, "Playlist must be single")
                if let g_playlistId = playlist[0].kind {
                    XCTAssert(playlistId.compare(String(g_playlistId)) == .orderedSame, "Incorrect playlist parsing object")
                } else {XCTAssert(false, "Playlist doesn't have kind ID")}
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testUserPlaylistsResponse() {
        let uid = String(accountUid)
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: uid) { result in
            do {
                let playlists = try result.get()
                XCTAssert(playlists.count > 0, "Playlists' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testTagPlaylistsResponse() {
        let tagId = "беларусь"//yamusic-daily
        let exp = self.expectation(description: "Request time-out expectation")
        client.getPlaylistsByTag(tagId: tagId) { result in
            do {
                let tagRes = try result.get()
                XCTAssertTrue(tagId.lowercased().compare(tagRes.tag.value.lowercased()) == .orderedSame, "Expected and actual tags don't match")
                XCTAssertTrue(tagRes.ids.count > 0, "Playlists' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Tag result object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testNewPlaylistsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getNewPlaylists { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.type.compare("new-playlists") == .orderedSame, "Response doesn't contain new playlists")
                XCTAssertTrue(playlists.newPlaylists?.count != 0, "New playlists' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty new albums array object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistRecommendationsResponse() {
        let uid = String(accountUid)
        let playlistId = "1003"//Your playlist id
        let exp = self.expectation(description: "Request time-out expectation")
        client.getPlaylistRecommendations(userId: uid, playlistId: playlistId) { result in
            do {
                let playlistRecommends = try result.get()
                XCTAssert(playlistRecommends.tracks.count > 0, "Playlist track recommendations' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistContextTrackShort() {
        guard let data = trackShortJson.data(using: .utf8) else {
            XCTAssert(false, "Unable convert String to Data")
            return
        }
        do {
            let trackShort = try JSONDecoder().decode(TrackShort.self, from: data)
            let trackShortExpected = TrackShort(id: 33943347, timestamp: "2021-07-20T03:00:00+00:00", originalIndex: 0, albumId: nil, playCount: nil, recent: false, chart: nil, track: nil)
            
            XCTAssert(trackShort.id == trackShortExpected.id && trackShort.timestamp.compare(trackShortExpected.timestamp) == .orderedSame && trackShort.recent == trackShortExpected.recent && trackShort.originalIndex == trackShortExpected.originalIndex, "Incorrect parsing track short object")
        } catch {
            print(error)
            XCTAssert(false, "Error parsing track short object from JSON: " + error.localizedDescription)
        }
    }
    
    func testPlaylistContextTrack() {
        guard let data = trackShortJson.data(using: .utf8) else {
            XCTAssert(false, "Unable convert String to Data")
            return
        }
        do {
            let trackShort = try JSONDecoder().decode(TrackShort.self, from: data)
            let artists = [
                Artist(id: 4172223, error: nil, reason: nil, name: "12AM",
                cover: Cover(type: "from-album-cover", uri: "avatars.yandex.net/get-music-content/175191/8ded7e54.a.9680694-1/%%", itemsUri: nil, dir: nil, version: nil, custom: nil, isCustom: nil, copyrightName: nil, copyrightCline: nil, prefix: "8ded7e54.a.9680694-1", error: nil),
                various: false, composer: false, genres: [], ogImage: nil, opImage: nil, noPicturesFromSearch: nil, counts: nil, available: nil, ratings: nil, links: nil, ticketsAvailable: nil, likesCount: nil, popularTracks: nil, regions: nil, decomposed: nil, fullNames: nil, handMadeDescription: nil, description: nil, countries: nil, enWikipediaLink: nil, dbAliases: nil, aliases: nil, initDate: nil, endDate: nil, yaMoneyId: nil),
                Artist(id: 3151600, error: nil, reason: nil, name: "Jez Dior",
                cover: Cover(type: "from-album-cover", uri: "avatars.yandex.net/get-music-content/2386207/a5221dab.a.12034511-1/%%", itemsUri: nil, dir: nil, version: nil, custom: nil, isCustom: nil, copyrightName: nil, copyrightCline: nil, prefix: "a5221dab.a.12034511-1", error: nil),
                various: false, composer: false, genres: [], ogImage: nil, opImage: nil, noPicturesFromSearch: nil, counts: nil, available: nil, ratings: nil, links: nil, ticketsAvailable: nil, likesCount: nil, popularTracks: nil, regions: nil, decomposed: nil, fullNames: nil, handMadeDescription: nil, description: nil, countries: nil, enWikipediaLink: nil, dbAliases: nil, aliases: nil, initDate: nil, endDate: nil, yaMoneyId: nil),
            ]
            let albums = [
                Album(id: 4158732, error: nil, title: "Afterparty", trackCount: 8, artists: [artists[0]], labels: [Label(id: 942045, name: "Funeral Crew"), Label(id: 5758, name: "EMIPRE")], available: true, availableForPremiumUsers: true, version: nil, coverUri: "avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%", contentWarning: "explicit", originalReleaseYear: nil, genre: "foreignrap", textColor: nil, shortDescription: nil, description: nil, isPremiere: nil, isBanner: nil, metaType: "music", storageDir: nil, ogImage: "avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%", buy: [], recent: false, veryImportant: nil, availableForMobile: true, availablePartially: false, bests: [33943349,33943347], duplicates: nil, prerolls: nil, volumes: nil, year: 2017, releaseDate: "2017-03-17T00:00:00+03:00", type: nil, trackPosition: TrackPosition(volume: 1, index: 2), regions: nil, availableAsRbt: nil, lyricsAvailable: nil, rememberPosition: nil, albums: nil, durationMs: nil, explicit: nil, startDate: nil, likesCount: 19, deprecation: nil, availableRegions: nil)
            ]
            let trackExpected = Track(id: "33943347", title: "Couple Pills", available: true, artists: artists, albums: albums, availableForPremiumUsers: true, lyricsAvailable: true, poetryLoverMatches: nil, best: nil, realId: "33943347", ogImg: "avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%", type: "music", coverUri: "avatars.yandex.net/get-music-content/117546/1cca8c9a.a.4158732-1/%%", major: Major(id: 146, name: "EMPIRE"), durationMs: 224490, storageDir: "1327_109b74ca.36526310.1.609676", fileSize: 0, substituted: nil, matchedTrack: nil, normalization: Normalization(gain: -9.21, peak: 30579), r128: NormalizationR128(i: -7.47, tp: 1.43), error: nil, canPublish: nil, state: nil, desiredVisibility: nil, filename: nil, userInfo: nil, metaData: nil, regions: nil, availableAsRbt: nil, contentWarning: "explicit", explicit: nil, previewDurationMs: 30000, availableFullWithoutPermission: false, version: "feat. Jez Dior", rememberPosition: false, trackSharingFlag: "COVER_ONLY", backgroundVideoUri: nil, shortDescription: nil, forChildren: nil)

            XCTAssert(trackExpected.id == String(trackShort.id), "Track id parse error")
        } catch {
            print(error)
            XCTAssert(false, "Error parsing track short object from JSON: " + error.localizedDescription)
        }
    }
    
    func testCreatePlaylistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.createPlaylist(title: "somePlaylist") { result in
            do {
                let playlist = try result.get()
                XCTAssert(playlist.title.compare("somePlaylist") == .orderedSame, "Playlist has another actual title")
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistRenameResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: String(accountUid), completion: { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.count > 0, "Empty user playlists' array. Unable to test rename feature")
                let playlist = playlists[0]
                playlist.rename("newName") { result in
                    do {
                        let editedPlaylist = try result.get()
                        XCTAssertTrue(editedPlaylist.title.compare("newName") == .orderedSame, "Playlist title wasn't changed")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistSetVisibilityResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: String(accountUid), completion: { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.count > 0, "Empty user playlists' array. Unable to test edit visibility feature")
                let playlist = playlists[0]
                playlist.setVisibility(.private){ result in
                    do {
                        let editedPlaylist = try result.get()
                        XCTAssertTrue(editedPlaylist.visibility?.compare("private") == .orderedSame, "Playlist visbility wasn't changed")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistInsertTrackResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: String(accountUid), completion: { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.count > 0, "Empty user playlists' array. Unable to test insert track feature")
                let playlist = playlists[0]
                //51965869:7956489
                let ownerId = String(playlist.uid ?? -1)
                let playlistId = String(playlist.kind ?? -1)
                self.client.playlistInsertTrack(ownerId: ownerId, playlistId: playlistId, trackId: 51965869, albumId: 7956489, index: 0, revision: playlist.revision ?? 0) { result in
                    do {
                        let editedPlaylist = try result.get()
                        XCTAssertTrue(editedPlaylist.revision != playlist.revision, "Playlist revision mismatch (new one is equal old)")
                        XCTAssertTrue(editedPlaylist.trackCount != playlist.trackCount, "Playlist tracks count mismatch (new one is equal old)")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty edited playlist object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testPlaylistRemoveTrackResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: String(accountUid), completion: { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.count > 0, "Empty user playlists' array. Unable to test remove track feature")
                let playlist = playlists[0]
                let ownerId = String(playlist.uid ?? -1)
                let playlistId = String(playlist.kind ?? -1)
                XCTAssertTrue(playlist.trackCount != 0, "Playlist without tracks. Unable to test remove track feature")
                let from: Int = 0
                let to: Int = 1
                self.client.playlistDeleteTracks(ownerId: ownerId, playlistId: playlistId, from: from, to: to, revision: playlist.revision ?? 0) { result in
                    do {
                        let editedPlaylist = try result.get()
                        XCTAssertTrue(editedPlaylist.revision != playlist.revision, "Playlist revision mismatch (new one is equal old)")
                        XCTAssertTrue(editedPlaylist.trackCount != playlist.trackCount, "Playlist tracks count mismatch (new one is equal old)")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty edited playlist object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testRemovePlaylistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getUserPlaylists(userId: String(accountUid), completion: { result in
            do {
                let playlists = try result.get()
                XCTAssertTrue(playlists.count > 0, "Empty user playlists' array. Unable to test remove feature")
                let playlist = playlists[0]
                self.client.removeUserPlaylist(playlistId: String(playlist.kind ?? 0)) { result in
                    do {
                        let status = try result.get()
                        XCTAssertTrue(status, "Playlist wasn't removed")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty delete status object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
            }
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
