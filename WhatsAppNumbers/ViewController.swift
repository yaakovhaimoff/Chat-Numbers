//
//  ViewController.swift
//  WhatsAppNumbers
//
//  Created by Yaakov Haimoff on 16/01/2022.
//

import UIKit

class ViewController:UIViewController  {
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var openInWhatsappCTA: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardByTappingOutside))
        
        self.view.addGestureRecognizer(tap)
        checkClipboard()
        openInWhatsappCTA.isEnabled = !inputTextField.text!.isEmpty
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
    }
    
    //MARK: - Selectors
    @objc func applicationDidBecomeActive() {
        checkClipboard()
    }
    
    //MARK: - Service
    func checkClipboard() {
        let pasteboardString: String? = UIPasteboard.general.string
        if let str = pasteboardString, str.isNumber {
            inputTextField.text = str
            openInWhatsappCTA.isEnabled = !inputTextField.text!.isEmpty
        }
    }
    
//    func copyText(from text: String) {
//        weak var pb: UIPasteboard? = .general
//        pb?.string = text
//    }
//
//    func pasteText() -> String? {
//        weak var pb: UIPasteboard? = .general
//
//        guard let text = pb?.string else { return nil}
//
//        return text
//    }
    
    
    @objc func hideKeyboardByTappingOutside() {
        self.view.endEditing(true)
    }
    

    //MARK: - IBAction
    @IBAction func openInWhatsappCTA(_ sender: Any) {
        let urlWhats = "whatsapp://send?phone=+972\(inputTextField.text!)"
        
        guard let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        
        guard let whatsappURL = URL(string: urlString),
              UIApplication.shared.canOpenURL(whatsappURL),
              UIApplication.shared.canOpenURL(whatsappURL) else { return }
        
        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        openInWhatsappCTA.isEnabled = !inputTextField.text!.isEmpty
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        textField.resignFirstResponder()
        openInWhatsappCTA.isEnabled = !inputTextField.text!.isEmpty
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
