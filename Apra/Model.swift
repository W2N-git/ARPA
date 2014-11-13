//
//  Model.swift
//  Apra
//
//  Created by qw on 30.10.14.
//  Copyright (c) 2014 qw. All rights reserved.
//

import Foundation
import Alamofire
class Word: NSObject {
    
    var value : String?
    init(_ word: String!) {
    
        self.value = word
    }
}


/**

Строка типа: (при запросе слова "text")
 общ. 	текстовая надпись (Alexander Demidov); наименование (Например, часто встречается в счетах в таблице расшифровки счета Phyloneer)
*/


class ArticleLine: NSObject {

    var lexicType : String?
    var words: [Word]?
    
    init(lexicType: String) {
    
        self.lexicType = lexicType
    }
}



class VocabularyProcessor: NSObject {

    var targetWord: String = ""
    
    var articleLines: [ArticleLine]?
    
    init(targetWord: String) {
    
        self.targetWord = targetWord
    }
    
    func process(completion: ([ArticleLine]?) -> ()) {
        println("func : \(__FUNCTION__) line : \(__LINE__)")

        self.getHTMLpageForWord(self.targetWord){
//            [unowned self]
            (HTML) -> () in
            
            if HTML != nil {
                self.parseForArticle(HTML!, completion: completion)
            }
        }
    }
    
    func getHTMLpageForWord(word: String, completion: (String?) -> ()) {
        println("func: \(__FUNCTION__) line: \(__LINE__)")
//        var error : NSError?
        
        let r = Alamofire
        .request(.GET, "http://www.multitran.ru/c/m.exe", parameters: ["s" : word])
        .response { (_, _, responseObject, error) -> Void in
            
            println("response: \(responseObject)")
            
            if error != nil {
                println(error)
                completion(nil)
                return;
            }
            
            if let data = responseObject as? NSData {

                completion(NSString(data: data, encoding: NSWindowsCP1251StringEncoding))

            } else {

                print("func: \(__FUNCTION__) line: \(__LINE__) error: no HTML")
                completion(nil)
            }
        }
        
//        let request = AFHTTPRequestOperation(request:
//            AFHTTPRequestSerializer().requestWithMethod("GET",
//                URLString: "http://www.multitran.ru/c/m.exe",
//                parameters: ["s" : word],
//                error: &error))
        
//        println("ser:\(request.responseSerializer)")
        
//        request.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html"])
//        request.responseSerializer.acceptableStatusCodes  = NSIndexSet(index: 200)
//        
//        
//        request.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
//                
//                println("operation: \(operation)")
//                println("operation..allHeaderFields: \(operation.response.allHeaderFields)")
//
//                if let data = responseObject as? NSData {
//                    
//                    completion(NSString(data: data, encoding: NSWindowsCP1251StringEncoding))
//                    
//                } else {
//                    
//                    print("func: \(__FUNCTION__) line: \(__LINE__) error: no HTML")
//                    completion(nil)
//                }
//            },
//            
//            failure: { (operation, error) -> Void in
//                
//                print("func: \(__FUNCTION__) line: \(__LINE__) error: \(error)")
//                completion(nil)
//        })
//        
//        request.start()
    }
    

// MARK: Parsing

    let lexicTypePattern = "\\<a\\s*?title\\s*?=\\\"(.*?)\\\"(?>.|\\s)*?\\>\\s*?\\<i\\>(.*?)\\<\\/i\\>(?>(?>&nbsp;)|\\s*?)\\<\\/a\\>"
    let wordLinePattern  = "\\<a href=\\\"m\\.exe\\?t=(?>[0-9]|_)*?\\&s1=((?>[a-zA-Z]|[0-9])*?)\\\">(.*?)\\<\\/a\\>"
    
    func parseForArticle(HTML: String, completion: ([ArticleLine]?) -> ()) {
        println("func : \(__FUNCTION__) line : \(__LINE__)")

        let lexicTypes : [APRATextCheckingResult]? = RegExp()
                         .substringsFrom(HTML, pattern: lexicTypePattern)?
                         .map {
                            APRATextCheckingResult(id: "lexic", string: $0[1].0, range: $0[1].1)
                         }
        
        let actualWordPattern = wordLinePattern.stringByReplacingOccurrencesOfString("__TARGET_WORD__", withString: self.targetWord)
        
        let words : [APRATextCheckingResult]? = RegExp()
                    .substringsFrom(HTML, pattern: actualWordPattern)?
                    .map {
                        APRATextCheckingResult(id: "word", string: $0[1].0 + " - " + $0[2].0, range: $0[1].1)
                    }
        
        if lexicTypes == nil || lexicTypes?.count == 0 || words == nil || words?.count == 0 {
            println("lexicTypes : \(lexicTypes) words: \(words)")
            println("func : \(__FUNCTION__) line : \(__LINE__)")
            completion(nil)
            return
        }
        
        let allResults = (lexicTypes! + words!).sorted {
            $0.range.location < $1.range.location
        }

        let printable = "\n".join(allResults.map{ $0.description })
        println("\n\n\(printable)\n\n")
        
        completion(nil)
    }
}


class APRATextCheckingResult : NSObject, Printable {

    var identificator: String = ""
    var string : String = ""
    var range : NSRange = NSMakeRange(0, 0)
    
    init(id: String, string : String, range : NSRange) {
        self.identificator = id
        self.string = string
        self.range = range
    }
    
    override var description : String {
    
        return identificator + "\t" + string + "\t" + "range:\(range.location), \(range.length)"
    }
}

