//
//  AutoResizeMaterialTextView.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 12.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import MaterialTextInputs

class AutoResizeMaterialTextView: MaterialTextView {
    
    override var intrinsicContentSize: CGSize {
        return isScrollEnabled ? contentSize : super.intrinsicContentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            guard isScrollEnabled else { return }
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - Max height constraint
    
    var maxHeight: CGFloat? {
        didSet {
            maxHeightConstraint.constant = maxHeight ?? 0
            maxHeightConstraint.isActive = maxHeight != nil
        }
    }
    
    private lazy var maxHeightConstraint: NSLayoutConstraint = {
        return heightAnchor.constraint(lessThanOrEqualToConstant: 0)
    }()
    
}
