//
//  UITableViewCell.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 05.11.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func insertViewWithInsets(_ view: UIView) {
        let inset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset.left),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset.top),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset.right),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset.bottom)])
    }
    
    func addBottomLine() {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
}
