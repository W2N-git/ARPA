//
//  Project_defines.swift
//  Apra
//
//  Created by qw on 30.10.14.
//  Copyright (c) 2014 qw. All rights reserved.
//

import Foundation

let application_doc_path : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as String

func application_doc_path(filename: String) -> String {

    return application_doc_path.stringByAppendingPathComponent(filename)
}

extension String {
    
    subscript(range:Range<Int>) -> String {
//        let start = advance(self.startIndex, range.startIndex)
//        let end = advance(self.startIndex, range.endIndex)
//        return self[start..<end]
        
        return (self as NSString).substringWithRange(NSMakeRange(range.startIndex, range.startIndex + range.endIndex))
    }
    
    subscript(location: Int, length: Int) -> String {
        
        return self[Range(start:location, end:location + length)]
    }
    
    subscript(range:NSRange) -> String {
        
        return self[Range(start: range.location, end: range.location + range.length)];
    }
}
