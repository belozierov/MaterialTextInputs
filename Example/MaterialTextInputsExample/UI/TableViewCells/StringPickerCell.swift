//
//  StringPickerCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 05.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class StringPickerCell: BasePickerCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        strings = []
        property = nil
    }
    
    // MARK: - Properties
    
    var property: Property<String?>? {
        didSet { setString() }
    }
    
    var strings = [String?]() {
        didSet { updateViews() }
    }
    
    // MARK: - Actions
    
    @objc private func itemDidTap(_ recognizer: UIGestureRecognizer) {
        guard let label = recognizer.view,
            let index = itemsStackView.arrangedSubviews.index(of: label),
            index < strings.count else { return }
        property?.value = strings[index]
        setString()
    }
    
    // MARK: - Manage string views
    
    private func updateViews() {
        syncItemViews()
        setString()
    }
    
    private func syncItemViews() {
        let differ = itemsStackView.arrangedSubviews.count - strings.count
        if differ > 0 {
            itemsStackView.arrangedSubviews.reversed()[0..<differ].forEach { view in
                itemsStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        } else if differ < 0 {
            let existNumber = itemsStackView.arrangedSubviews.count
            (existNumber..<(existNumber + abs(differ))).forEach { index in
                let label = UILabel()
                label.isUserInteractionEnabled = true
                itemsStackView.addArrangedSubview(label)
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(itemDidTap(_:)))
                label.addGestureRecognizer(recognizer)
            }
        }
    }
    
    private func setString() {
        zip(itemsStackView.arrangedSubviews, strings).forEach { view, string in
            guard let label = view as? UILabel else { return }
            label.text = string ?? "Nil"
            if let value = property?.value, string == value {
                label.textColor = label.tintColor
                return
            }
            label.textColor = .lightGray
        }
    }
    
}
