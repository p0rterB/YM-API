//
//  DownloadInfo.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents variants of track downloading
public class DownloadInfo: Decodable {
    
    ///Audio file codec
    public let codec: String
    ///Audio file container type (for streaming)
    public let container: String?
    ///Audio file bitrate in kbps
    public let bitrateInKbps: Int
    ///Gain marker TODO
    public let gain: Bool
    ///Track preview marker TODO
    public let preview: Bool
    ///XML file url, which contains track donwload info
    public let downloadInfoUrl: String
    ///Audio file direct link. It is available after fetching link (library-purpose field)
    public var directLink: String?
    ///Audio direct link fetching timestamp (library-purpose field)
    var linkFetchTimestamp: TimeInterval?
    ///Audio direct link live marker. Link will be inactive in 1 hour after fetching
    public var linkAlive: Bool {
        get {return Date().timeIntervalSince1970 - (linkFetchTimestamp ?? 0) <= 3600}
    }
    ///Direct link marker
    public let direct: Bool

    public init(codec: String, container: String?, bitrateInKbps: Int, gain: Bool, preview: Bool, downloadInfoUrl: String, directLink: String?, linkFetchTimestamp: TimeInterval?, direct: Bool) {
        self.codec = codec
        self.container = container
        self.bitrateInKbps = bitrateInKbps
        self.gain = gain
        self.preview = preview
        self.downloadInfoUrl = downloadInfoUrl
        self.directLink = directLink
        self.direct = direct
    }
    
    ///Get direct link to download  from xml response. If exists alive fetched link, it returns local link data else downloads and parses new link.  Fetched link is available 60 minutes after fetching (after error 410)
    public func getDirectLink(completion: @escaping (_ result: Result<String, YMError>) -> Void) {
        if let g_directLink = directLink {
            if linkAlive {
                completion(.success(g_directLink))
            } else {
                completion(.failure(.trackDownloadLinkDead(description: "Download link " + g_directLink + " is inactive")))
            }
            return
        }
        getTrackDownloadLinkByApi(downloadInfoUrl: downloadInfoUrl) { result in
            do {
                let link = try result.get()
                if !link.isEmpty {
                    self.directLink = link
                    self.linkFetchTimestamp = Date().timeIntervalSince1970
                }
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            completion(result)
        }
    }
    
    ///Download track by direct link
    public func downloadTrack(completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_directLink = directLink, linkAlive {
            download(fullPath: g_directLink, completion: completion)
        } else {
            getDirectLink{ result in
                do {
                    let link = try result.get()
                    download(fullPath: link, completion: completion)
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                    let ymError = error as? YMError ?? YMError.badResponseData(errCode: -1, data: ["description": error])
                    completion(.failure(ymError))
                }
            }
        }
    }
}
