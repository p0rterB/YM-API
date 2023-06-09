//
//  CryptoUtil.swift
//  YM-API
//
//  Created by Developer on 08.06.2021.
//

import Foundation
import CommonCrypto

public class CryptoUtil {
    
    fileprivate init() {}
    
    public static func md5(string: String) -> [UInt8] {
        var digest: [UInt8] = [UInt8].init(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = string.data(using: .utf8) {
            data.withUnsafeBytes{ (unsafePointer) -> Void in
                let bufferPointer: UnsafePointer<UInt8> = unsafePointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
                let rawPtr = UnsafeRawPointer(bufferPointer)
                CC_MD5(rawPtr, CC_LONG(data.count), &digest)
            }
        }
        return digest
    }
    
    public static func md5String(string: String) -> String {
        let digest: [UInt8] = md5(string: string)
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }

        return digestHex
    }
    
    public static func hmacSha256(key: [UInt8], string: String) -> [UInt8] {
        var digest: [UInt8] = [UInt8].init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, string, string.count, &digest)
        return digest
    }
    
    public static func hmacSha256String(key: [UInt8], string: String, base64: Bool = true) -> String {
        let digest: [UInt8] = hmacSha256(key: key, string: string)
        if (base64) {
            let encodedDigest = Data(digest).base64EncodedString()
            return encodedDigest
        }
        var digestHex = ""
        for index in 0..<Int(CC_SHA256_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }

        return digestHex
    }
    
    static func generateSign(trackId: String, timestamp: String) -> String? {
        guard let hmacKeyData = YMConstants.signSecret.data(using: .utf8) else {return nil}
        let hmacKey = [UInt8](hmacKeyData)
        let id = String(trackId.split(separator: ":")[0])
        let sourceStr = id + timestamp
        let sign = CryptoUtil.hmacSha256String(key: hmacKey, string: sourceStr, base64: true)
        
        return sign
    }
}
