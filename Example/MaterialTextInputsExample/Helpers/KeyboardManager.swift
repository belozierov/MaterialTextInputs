//
//  KeyboardManager.swift
//
//  Created by Beloizerov on 08.01.17.
//  Copyright © 2017 Beloizerov. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate: class {
    
    func keyboardStateWillChange(keyboardIsHidden: Bool, keyboardSize: CGSize)
    func keyboardStateDidChange(keyboardIsHidden: Bool, keyboardSize: CGSize)
    
}

extension KeyboardManagerDelegate {
    
    func keyboardStateWillChange(keyboardIsHidden: Bool, keyboardSize: CGSize) {}
    func keyboardStateDidChange(keyboardIsHidden: Bool, keyboardSize: CGSize) {}
    
}

final class KeyboardManager {
    
    static var keyboardSize: CGSize {
        return share.keyboardSize
    }
    
    private static let share = KeyboardManager()
    
    static weak var delegate: KeyboardManagerDelegate? {
        get { return share.delegate }
        set { share.delegate = newValue }
    }
    
    private var keyboardIsHidden = true
    private var keyboardSize = CGSize()
    
    private weak var delegate: KeyboardManagerDelegate? {
        didSet {
            delegate?.keyboardStateDidChange(keyboardIsHidden: keyboardIsHidden, keyboardSize: keyboardSize)
        }
    }
    
    static func delegateSafeRemove(for delegateToRemove: KeyboardManagerDelegate) {
        if delegate === delegateToRemove { delegate = nil }
    }
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let value = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] {
            keyboardSize = (value as AnyObject).cgRectValue.size
        }
        delegate?.keyboardStateWillChange(keyboardIsHidden: false, keyboardSize: keyboardSize)
    }
    
    @objc private func keyboardShown(notification: NSNotification) {
        keyboardIsHidden = false
        delegate?.keyboardStateDidChange(keyboardIsHidden: keyboardIsHidden, keyboardSize: keyboardSize)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        delegate?.keyboardStateWillChange(keyboardIsHidden: true, keyboardSize: keyboardSize)
    }
    
    @objc private func keyboardHidden(notification: NSNotification) {
        keyboardIsHidden = true
        delegate?.keyboardStateDidChange(keyboardIsHidden: keyboardIsHidden, keyboardSize: keyboardSize)
    }
    
}
