//
//  AddBookViewController.swift
//  lab-1.1
//
//  Created by Kirill on 05.05.2021.
//

import UIKit

class AddBookViewController: UIViewController {
    
    weak var delegate: AddBookDelegate?
    var addedBook: Book?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var subTitleTextField: UITextField!
    @IBOutlet var titleTexField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTexField.becomeFirstResponder()
        registerForKeyboardNotifications()
    }
    
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func buttonTaped() {
        
        priceTextField.resignFirstResponder()
        guard let titleTex = titleTexField.text,
              !titleTex.isEmpty,
              let subTitleText = subTitleTextField.text,
              !subTitleText.isEmpty,
              let price = Float(priceTextField.text!),
              price > 0 else {
            let errorController = ErrorAddViewController()
            
            navigationController?.pushViewController(errorController, animated: false)
            print("Incorrect input")
            return
        }
        
        addedBook = Book(title: titleTex, subtitle: subTitleText, price: "$\(price)", isbn13: "", image: "")
        print(addedBook!)
        self.delegate?.transferAddedBook(book: addedBook!)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func kbWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
        
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    @objc func kbWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

protocol AddBookDelegate: AnyObject {
    func transferAddedBook(book: Book)
}
