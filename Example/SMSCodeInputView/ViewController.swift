//
//  ViewController.swift
//  SMSCodeInputView
//
//  Created by Sergey Zalozniy on 03/14/2021.
//  Copyright (c) 2021 Sergey Zalozniy. All rights reserved.
//

import UIKit
import SMSCodeInputView

private let digitCount: Int = 5

class ViewController: UIViewController {

    @IBOutlet weak var smsCodeView: SMSCodeInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smsCodeView.delegate = self
        smsCodeView.becomeFirstResponder()
        smsCodeView.numberOfDigits = digitCount
    }
}

extension ViewController: SMSCodeInputViewDelegate {
    func smsCodeInputView(_ view: SMSCodeInputView, didChange code: String) {
        if code != "12345" && code.count == digitCount {
            smsCodeView.highlightErrorState()
            smsCodeView.resignFirstResponder()
        }
    }
}
