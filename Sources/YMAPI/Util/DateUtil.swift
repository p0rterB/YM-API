//
//  DateUtil.swift
//  YM-API
//
//  Created by Developer on 14.07.2021.
//

import Foundation

public class DateUtil
{
    fileprivate init() {}
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ string representation of defined date
    public static func isoFormat(date: Date) -> String
    {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter.string(from: date)
    }
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ string representation of 'now' date
    public static func isoFormat() -> String
    {
        return isoFormat(date: Date())
    }
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ string representation of defined date
    public static func fromIsoFormat(dateStr: String) -> Date?
    {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter.date(from: dateStr)
    }
    
    ///Converts the time interval (hours, minutes, seconds) to formats:  H:mm:ss if hours > 0 or m:ss if hours = 0
    public static func formattedTrackTime(_ timeInS: TimeInterval) -> String {
        var intVal = Int(timeInS.rounded())
        var res = ""
        if (intVal >= 3600) {
            res += String(intVal / 60) + ":"
        }
        intVal = intVal % 3600
        
        if (intVal >= 60) {
            res += String(intVal / 60) + ":"
        } else {
            if (res.isEmpty)
            {
                res += "0:"
            } else {
                res += "00:"
            }
        }
        intVal = intVal % 60
        
        if (intVal >= 10) {
            res += String(intVal)
        } else {
            res += "0" + String(intVal)
        }
        return res
    }
}
