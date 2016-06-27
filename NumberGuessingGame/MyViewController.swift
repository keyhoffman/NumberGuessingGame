//
//  MyViewController.swift
//  FunctionalVC
//
//  Created by Key Hoffman on 10/27/15.
//  Copyright © 2015 Key Hoffman. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITextFieldDelegate {
    
    var onComplete: Int -> () = { _ in }
    let configureSelf: MyViewController -> ()
    
    init(configureSelf: MyViewController -> ()) {
        self.configureSelf = configureSelf
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            guard let number = Int(textField.text ?? "") else { textField.error(); return false }
            onComplete(number)
            textField.clear()
        }
        return true
    }
}

extension UITextField {
    func error() {
        self.placeholder = "Please enter a valid number"
        self.clear()
    }
    
    func clear() {
        self.text = ""
    }
}