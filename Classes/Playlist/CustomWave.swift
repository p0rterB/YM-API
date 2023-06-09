//
//  CustomWave.swift
//  YM-API
//
//  Created by Developer on 09.06.2023.
//

///Represents playlist additional description
public class CustomWave: Decodable {
    
    ///Playlist title
    public let title: String
    ///Lottie JSON animation url
    public let animationUrl: String?
    ///TODO
    public let position: String?
    
    init(title: String, animationUrl: String?, position: String?) {
        self.title = title
        self.animationUrl = animationUrl
        self.position = position
    }
}
