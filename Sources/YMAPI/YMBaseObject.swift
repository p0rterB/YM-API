//
//  source.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

public class YMBaseObject {
    
    ///Object type name
    public var objType: String
    {
        get {return String(describing: type(of: self.self))}
    }
}
