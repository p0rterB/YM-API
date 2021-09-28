//
//  Properties.swift
//  Rave
//
//  Created by Developer on 21.05.2021.
//

import Foundation

class Properties: Codable
{
    fileprivate static let PLIST_FILENAME: String = Constants.PSEUDO_BUNDLE_ID
    
    fileprivate var _flags: BitBool8
    var uid: Int
    var locale: AvailableLocalizations
    
    var trafficEconomy: Bool {
        get { return _flags.getFlagPropertyValue(for: 0) }
        set { _flags.setFlagPropertyValue(for: 0, value: newValue) }
    }
    
    var isAuthed: Bool {
        get { return uid != -1 && AppService.getToken().compare("") != .orderedSame }
    }
    
    fileprivate init()
    {
        _flags = BitBool8(initVal: 0)
        uid = -1
        guard let preferred_locale = Locale.preferredLanguages.first else {locale = .english; return}
        self.locale = AvailableLocalizations.getLocalicationByLocaleIdentifier(preferred_locale) ?? AvailableLocalizations.english
    }
    
    fileprivate init(flags: BitBool8, uid: Int)
    {
        _flags = flags
        self.uid = uid
        guard let preferred_locale = Locale.preferredLanguages.first else {locale = .english; return}
        self.locale = AvailableLocalizations.getLocalicationByLocaleIdentifier(preferred_locale) ?? AvailableLocalizations.english
    }
    
    fileprivate init(flags: BitBool8, uid: Int, locale: AvailableLocalizations)
    {
        _flags = flags
        self.uid = uid
        self.locale = locale
    }
    
    ///Update application locale to preferred by device
    func refreshLocale() -> Void
    {
        let preferredLocales: [String] = Locale.preferredLanguages
        guard let preferred_locale = preferredLocales.first else {locale = .english; return}
        locale = AvailableLocalizations.getLocalicationByLocaleIdentifier(preferred_locale) ?? AvailableLocalizations.english
    }
    
    ///Save application properties with default filename (bundle id)
    func save()
    {
        save(plistFilename: Properties.PLIST_FILENAME)
    }
    
    ///Save application properties with specific filename
    func save(plistFilename: String)
    {
        if !PlistWrapper.savePropertyList(self, filename: Properties.PLIST_FILENAME)
        {
            #if DEBUG
                print("Application properties not saved")
            #endif
        }
    }
    
    ///Load application properties with default filename (bundle id)
    class func load() -> Properties
    {
        return load(plistFilename: Properties.PLIST_FILENAME)
    }
    
    ///Load application properties with specific filename
    class func load(plistFilename: String) -> Properties
    {
        if let loadedProperties: Properties = PlistWrapper.parsePropertyList(filename: plistFilename)
        {
            return loadedProperties
        }
        let properties: Properties = Properties()
        properties.save(plistFilename: plistFilename)
        return properties
    }
}
