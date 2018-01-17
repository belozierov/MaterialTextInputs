//
//  TableViewCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 14.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

protocol TableViewCell: class {
    
    associatedtype PropertyType
    
    weak var delegate: BasePickerCellDelegate? { get set }
    var title: String? { get set }
    var property: Property<PropertyType>? { get set }
    var list: [PropertyType] { get set }
    
}

extension TableViewCell {
    
    weak var delegate: BasePickerCellDelegate? {
        get { return nil } set {}
    }
    
    var list: [PropertyType] {
        get { return [] } set {}
    }
    
}
