//
//  MaterialTextInput.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 12.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import MaterialTextInputs

protocol MaterialTextInput: class {
    
    var reservePlaceForTitle: Bool { get set }
    var placeholderColor: UIColor { get set }
    var titleColor: UIColor { get set }
    var placeholder: String? { get set }
    var titleFontSize: CGFloat { get set }
    var titleBottomInset: CGFloat { get set }
    
}

extension MaterialTextInput {
    
    func property<T>(for keypath: WritableKeyPath<MaterialTextInput, T>) -> Property<T> {
        return PropertyWrapper(keyPath: keypath) { [weak self] in self }
    }
    
}

extension AutoResizeMaterialTextView: MaterialTextInput {}
extension MaterialTextField: MaterialTextInput {}

