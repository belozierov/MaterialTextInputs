//
//  SwitcherCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 04.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class SwitcherCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let switcher = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addBottomLine()
        //stackView
        let stackView = UIStackView()
        stackView.axis = .horizontal
        insertViewWithInsets(stackView)
        //label
        stackView.addArrangedSubview(titleLabel)
        //label
        switcher.addTarget(self, action: #selector(switcherValueDidChange), for: .valueChanged)
        let compressionPrioirity = titleLabel.contentHuggingPriority(for: .horizontal).rawValue + 1
        switcher.setContentCompressionResistancePriority(UILayoutPriority(rawValue: compressionPrioirity), for: .horizontal)
        stackView.addArrangedSubview(switcher)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        property = nil
    }
    
    // MARK: - Properties
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var property: Property<Bool>? {
        didSet {
            switcher.isOn = property?.value ?? false
        }
    }
    
    // MARK: - Actions
    
    @objc private func switcherValueDidChange() {
        property?.value = switcher.isOn
    }
    
}
