import Foundation

class Constants
{
    public static let APP_STORE_ID = "1234567890"
    public static let PSEUDO_BUNDLE_ID = Bundle.main.bundleIdentifier ?? "Unknown identifier"
    public static let PSEUDO_BUNDLE_NAME = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown name"
    public static let PSEUDO_BUNDLE_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    public static let PSEUDO_BUNDLE_BUILD_NUMBER = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
}
