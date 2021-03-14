//
//  ViewController.swift
//  SMSCode
//
//  Created by Sergey Zalozniy on 12.01.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var smsCodeView: SMSCodeInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smsCodeView.delegate = self
//        smsCodeView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        smsCodeView.numberOfDigits = 4
    }
}

extension ViewController: SMSCodeInputViewDelegate {
    func smsCodeInputView(_ view: SMSCodeInputView, didChange code: String) {
        if code != "12345" && code.count == 5 {
            smsCodeView.highlightErrorState()
            smsCodeView.resignFirstResponder()
        }
    }
}
