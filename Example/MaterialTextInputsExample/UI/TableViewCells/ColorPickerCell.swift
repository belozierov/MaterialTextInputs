//
//  ColorPickerCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 04.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class ColorPickerCell: BasePickerCell {
    
    private var rgbSliders = [UISlider]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let colors: [UIColor] = [.red, .green, .blue]
        rgbSliders = colors.enumerated().map { index, color in
            let slider = UISlider()
            slider.tag = index
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.tintColor = color
            slider.addTarget(self, action: #selector(valueDidChange(_:)), for: .valueChanged)
            itemsStackView.addArrangedSubview(slider)
            return slider
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        property = nil
        rgbSliders.forEach { slider in slider.value = 0 }
    }
    
    // MARK: - Properties
    
    var property: Property<UIColor>? {
        didSet {
            guard let components = rgbComponents else { return }
            rgbSliders.enumerated().forEach { index, slider in
                slider.value = Float(components[index])
            }
        }
    }
    
    private var rgbComponents: [CGFloat]? {
        guard let components = property?.value?.cgColor.components,
            components.count >= 3 else { return nil }
        return Array(components[0..<3])
    }
    
    // MARK: - Actions
    
    @objc private func valueDidChange(_ slider: UISlider) {
        guard var components = rgbComponents, slider.tag < components.count else { return }
        components[slider.tag] = CGFloat(slider.value)
        property?.value = UIColor(red: components[0], green: components[1], blue: components[2], alpha: 1)
    }
    
}
