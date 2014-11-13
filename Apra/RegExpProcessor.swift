//
//  RegExpProcessor.swift
//  Apra
//
//  Created by qw on 07.11.14.
//  Copyright (c) 2014 qw. All rights reserved.
//

import Foundation

class RegExp: NSObject {
    
    var error : NSError?
    
    func substringsFrom(
        string:String,
        pattern: String,
        regExpOptions : NSRegularExpressionOptions = NSRegularExpressionOptions(0),
        matchingOptions : NSMatchingOptions = NSMatchingOptions(0),
        range: NSRange? = nil) -> ([[(String, NSRange)]])? {
        
            let actualRange = range == nil ? NSMakeRange(0, countElements(string)) : range!
            
        if let regExp = NSRegularExpression(pattern: pattern, options: regExpOptions, error: &self.error) {
            
            let matches = regExp.matchesInString((string as NSString), options: matchingOptions, range: actualRange)
            
            var matchStrings = [[(String, NSRange)]]()
            
            for _match in matches {
                
                if let match = _match as? NSTextCheckingResult {
                    
                    var matchGroupStrings = [(String, NSRange)]()
                    
                    for index in 0..<match.numberOfRanges {
                        
                        let range = match.rangeAtIndex(index)
                    
                        let substring = string[range]//(string as NSString).substringWithRange(range)
                        println(substring)
                        matchGroupStrings.append((substring, range))
                        
//                        matchGroupStrings.append(string[range])
                    }
                    
                    matchStrings.append(matchGroupStrings)
                    
                } else {
                    
                    // вряд ли возможна эта ситуация
                    self.error = NSError(domain: "EasyRegExp", code: -1, userInfo: [NSLocalizedDescriptionKey : "match value is not NSTextCheckingResult", "match" : _match])
                    return nil
                }
            }
            
            return matchStrings
            
        } else {
            
            return nil
        }
    }
}
