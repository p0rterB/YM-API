//
//  JsonUtil.swift
//  YM-API
//
//  Created by Developer on 20.07.2021.
//

import Foundation

public class JsonUtil
{
    fileprivate init() {}
    
    ///Extracts key-value pair complex object from defined JSON data object with output format "{key}":{[data]}
    public static func extractData(from json: Data, key: String) -> Data?
    {
        guard let buff = String(data: json, encoding: .utf8) else { return nil }
        guard let extracted = extractData(from: buff, key: key) else { return nil }
        return extracted.data(using: .utf8)
    }
    
    ///Extracts key-value pair complex object from defined JSON string with output format "{key}":{[data]}
    public static func extractData(from json: String, key: String) -> String? {
        var result = ""
        if let g_beginIndex = json.range(of: "\"" + key + "\":")?.upperBound {
            let buff = String(json[g_beginIndex..<json.endIndex])
            if (buff.count > 0)
            {
                let charPatternBegin = String(buff[buff.startIndex])
                var charPatternEnd = "]"
                if (charPatternBegin.compare("{") == .orderedSame) {
                    charPatternEnd = "}"
                }
                var objectsCount = 0
                for ch in buff
                {
                    let charStr = String(ch)
                    result += charStr
                    if (charStr.compare(charPatternBegin) == .orderedSame) {
                        objectsCount += 1
                        continue
                    }
                    if (charStr.compare(charPatternEnd) == .orderedSame) {
                        objectsCount -= 1
                    }
                    if (objectsCount == 0)
                    {
                        break
                    }
                }
                if (result.compare("") == .orderedSame) { return nil }
                return result
            }
        }
        return nil
    }
}
