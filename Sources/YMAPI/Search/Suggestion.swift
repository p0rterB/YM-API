//
//  Suggestion.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Suggestions during searching
public class Suggestion: Decodable {
    
    ///Best suggestion for search
    public let best: Best?
    ///Possible advices for search reqeust
    public let suggestions: [String]
    
    public init(best: Best?, suggestions: [String]) {
        self.best = best
        self.suggestions = suggestions
    }  
}
