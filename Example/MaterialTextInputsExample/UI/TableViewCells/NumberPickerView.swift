//
//  NumberPickerView.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 05.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class NumberPickerView: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let numberLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addBottomLine()
        //stackView
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        insertViewWithInsets(stackView)
        //titleLabel
        stackView.addArrangedSubview(titleLabel)
        let compression = UILayoutPriority(rawValue: titleLabel.contentCompressionResistancePriority(for: .horizontal).rawValue - 1)
        titleLabel.setContentCompressionResistancePriority(compression, for: .horizontal)
        let hugging = UILayoutPriority(rawValue: titleLabel.contentHuggingPriority(for: .horizontal).rawValue - 1)
        titleLabel.setContentHuggingPriority(hugging, for: .horizontal)
        //minusButton
        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        stackView.addArrangedSubview(minusButton)
        //numberLabel
        numberLabel.textAlignment = .center
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.widthAnchor.constraint(equalToConstant: 32).isActive = true
        stackView.addArrangedSubview(numberLabel)
        //plusButton
        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        stackView.addArrangedSubview(plusButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var property: Property<CGFloat>? {
        didSet { updateNumberLabel() }
    }
    
    // MARK: - Actions
    
    @objc private func plusTapped() {
        guard let value = property?.value, value < 30 else { return }
        property?.value = value + 1
        updateNumberLabel()
    }
    
    @objc private func minusTapped() {
        guard let value = property?.value, value > 4 else { return }
        property?.value = value - 1
        updateNumberLabel()
    }
    
    private func updateNumberLabel() {
        guard let value = property?.value else { return }
        numberLabel.text = Int(value).description
    }
    
}
