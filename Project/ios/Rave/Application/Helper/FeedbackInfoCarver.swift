import Foundation
import UIKit
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

class FeedbackInfoCarver
{
    static var osVer: String {
        get {return UIDevice.current.systemVersion}
    }
    
    static var model: String {
        get {return UIDevice.current.model}
    }
    
    static var deviceId: String {
        get {return UIDevice.current.identifierForVendor?.uuidString ?? "UNKNOWN"}
    }
    
    class func getData() -> String
    {
        var feedbackData: String = "--- Don't Edit Anything Below ---\n"
        feedbackData += "Language: "
        feedbackData += (NSLocale.current.languageCode ?? "en") + "-"
        feedbackData += (NSLocale.current.regionCode ?? "US") + "\n"
        
        if #available(iOS 12.0, *) {
            if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                var buf: String = "Carrier: "
                var buf2: String = "Mobile Country Code: "
                providers.forEach { (key, value) in
                    buf += (value.carrierName ?? "NONE") + " "
                    buf2 += (value.mobileCountryCode ?? "NONE") + " "
                }
                feedbackData += buf + "\n" + buf2 + "\n"
            }
        } else {
            let provider = CTTelephonyNetworkInfo().subscriberCellularProvider
            feedbackData += "Carrier: " + (provider?.carrierName ?? "NONE") + "\n"
            feedbackData += "Mobile Country Code: " + (provider?.mobileCountryCode ?? "NONE") + "\n"
        }
        var buffer = "NetworkType: Cell\n"
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String ?? ""
                        if (ssid != "")
                        {
                            buffer = "NetworkType: WiFi\n"
                        }
                }
            }
        }
        feedbackData += buffer
        feedbackData += "Country ISO: "
        if #available(iOS 12.0, *) {
            if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                    providers.forEach { (key, value) in
                        feedbackData += (value.isoCountryCode ?? "NONE") + " "
                    }
                feedbackData += "\n"
                }
            } else {
                let provider = CTTelephonyNetworkInfo().subscriberCellularProvider
                feedbackData += (provider?.isoCountryCode ?? "NONE") + "\n"
        }
        feedbackData += "Device: " + UIDevice.current.model + "\n"
        feedbackData += "Device ID: " + (UIDevice.current.identifierForVendor?.uuidString ?? "UNKNOWN") + "\n"
        feedbackData += "OS: iOS/" + UIDevice.current.systemVersion + "\n"
        feedbackData += "Username: " + UIDevice.current.name + "\n"
        feedbackData += "Version: " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "UNKNOWN VERSION")
        feedbackData += " (" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "UNKNOWN BUILD NUMBER") + ")"
        return feedbackData
    }
}
