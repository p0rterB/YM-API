//
//  XmlUtil.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

class XmlUtil: NSObject, XMLParserDelegate {
    
    fileprivate var _parser: XMLParser
    fileprivate var _parsed: [String: Any]
    fileprivate var _handler: ([String: Any]) -> ()
    
    fileprivate var _elementName: String
    fileprivate var _elementData: String
    
    public init (xml_data: Data, handler: @escaping ([String: Any]) -> ()) {
        _parser = XMLParser(data: xml_data)
        _handler = handler
        _parsed = [:]
        _elementName = ""
        _elementData = ""
        super.init()
        _parser.delegate = self
    }
    
    public init(xml_stream: InputStream, handler: @escaping ([String: Any]) -> ()) {
        _parser = XMLParser(stream: xml_stream)
        _handler = handler
        _parsed = [:]
        _elementName = ""
        _elementData = ""
        super.init()
        _parser.delegate = self
    }
    
    public func parse() {
        _parser.parse()
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        _handler(_parsed)
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        _elementName = elementName
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        _elementData = string
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (_elementName.contains(elementName)) {
            _parsed[_elementName] = _elementData
            _elementName = ""
            _elementData = ""
        }
    }
}
