import Foundation

class PlistWrapper
{
    class func parsePropertyList<T:Codable>(filename plist_name: String) -> T?
    {
        let type = "plist"
        do
        {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(plist_name).appendingPathExtension(type)
            let plistData: Data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let decoded = try decoder.decode(T.self, from: plistData)
            return decoded
        }
        catch
        {
            print("Error reading plist: \(error)")
            return nil
        }
    }
    
    class func savePropertyList<T:Codable>(_ value: T, filename plist_name: String) -> Bool
    {
        let type = "plist"
        do
        {
            let encoder = PropertyListEncoder()
            let plistData: Data = try encoder.encode(value)
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(plist_name).appendingPathExtension(type)
            try plistData.write(to: url, options: .atomicWrite)
            return true
        }
        catch
        {
            print("Error saving plist: \(error)")
            return false
        }
    }
}
