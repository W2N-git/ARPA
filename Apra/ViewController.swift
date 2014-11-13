//
//  ViewController.swift
//  Apra
//
//  Created by qw on 30.10.14.
//  Copyright (c) 2014 qw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func processSearch(word: String) {
        println("func: \(__FUNCTION__) line: \(__LINE__)")
        VocabularyProcessor(targetWord: word).process {_ in
            
            println("at last : THE END! ")
        }
    }
    

    // MARK: UITextField
    
    @IBOutlet weak var targetWordTextField: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        println("func: \(__FUNCTION__) line: \(__LINE__)")
        
        self.processSearch(textField.text)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: visualization
    
    @IBOutlet weak var testTextView: UITextView!
    
}

