//
//  InvocationInfo.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents back-end response info
public class YMInvocationInfo: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case hostname
        case reqId = "req-id"
        case execDurationMillis = "exec-duration-millis"
    }
    
    ///Back-end server name
    public let hostname: String
    ///Reqeust number (ID)
    public let reqId: String
    ///Execution duration in miliseconds
    public let execDurationMillis: String?
    
    public init(hostname: String, reqId: String, execDurationMillis: String?) {
        self.hostname = hostname
        self.reqId = reqId

        self.execDurationMillis = execDurationMillis
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.hostname = try container.decode(String.self, forKey: .hostname)
        self.reqId = try container.decode(String.self, forKey: .reqId)
        var duration: String = ""
        do {
            duration = try container.decode(String.self, forKey: .execDurationMillis)
            self.execDurationMillis = duration
        } catch {
            let durationInt = try? container.decodeIfPresent(Int.self, forKey: .execDurationMillis)
            if let g_duration = durationInt {
                self.execDurationMillis = String(g_duration)
            } else {
                self.execDurationMillis = nil
            }
        }
    }
}
