//
//  BasePickerCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 05.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

protocol BasePickerCellDelegate: class {
    
    func cellHeightDidchange(cell: UITableViewCell)
    
}

class BasePickerCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    let itemsStackView = UIStackView()
    
    private var rgbSliders = [UISlider]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addBottomLine()
        //stackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        insertViewWithInsets(stackView)
        //arrowImageView
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        //titleStackView
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(arrowImageView)
        stackView.addArrangedSubview(titleStackView)
        //hide/show slider gesture recognizer
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        titleStackView.addGestureRecognizer(recognizer)
        //itemsStackView
        itemsStackView.axis = .vertical
        itemsStackView.spacing = 4
        itemsStackView.isHidden = true
        stackView.addArrangedSubview(itemsStackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        title = nil
        itemsStackView.isHidden = true
    }
    
    // MARK: - CellDelegate
    
    weak var delegate: BasePickerCellDelegate?
    
    // MARK: - Properties
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    // MARK: - Actions
    
    @objc private func titleTapped() {
        itemsStackView.isHidden = !itemsStackView.isHidden
        delegate?.cellHeightDidchange(cell: self)
    }
    
}
