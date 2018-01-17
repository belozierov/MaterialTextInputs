//
//  ViewController.swift
//  MaterialTextInputsExample
//
//  Created by Beloizerov on 27.10.2017.
//  Copyright © 2017 Home. All rights reserved.
//

import MaterialTextInputs

class ViewController: UIViewController, UITableViewDataSource, BasePickerCellDelegate, KeyboardManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        //segmentedControl
        segmentedControl.selectedSegmentIndex = 0
        segmenteDidChange()
        //KeyboardManager
        KeyboardManager.delegate = self
    }
    
    // MARK: - SegmentedControl
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["TextView", "TextField"])
        control.addTarget(self, action: #selector(segmenteDidChange), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(control)
        NSLayoutConstraint.activate([
            control.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            control.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)])
        return control
    }()
    
    @objc private func segmenteDidChange() {
        showTextInput(textInput)
        tableView.reloadData()
    }
    
    private var textInput: MaterialTextInput {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return textView
        default: return textField
        }
    }
    
    // MARK: - TextInput Constrains
    
    private func showTextInput(_ textInput: MaterialTextInput) {
        switch textInput {
        case let input where input === textView :
            textField.resignFirstResponder()
            textField.isHidden = true
            textView.isHidden = false
            NSLayoutConstraint.deactivate(textFieldConstrains)
            NSLayoutConstraint.activate(textViewConstrains)
        case let input where input === textField:
            textView.resignFirstResponder()
            textView.isHidden = true
            textField.isHidden = false
            NSLayoutConstraint.deactivate(textViewConstrains)
            NSLayoutConstraint.activate(textFieldConstrains)
        default: break
        }
    }
    
    private lazy var textViewConstrains: [NSLayoutConstraint] = {
        return constrainsForTextInputs(textView)
    }()
    
    private lazy var textFieldConstrains: [NSLayoutConstraint] = {
        return constrainsForTextInputs(textField)
    }()
    
    private func constrainsForTextInputs(_ textInput: UIView) -> [NSLayoutConstraint] {
        return [textInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                textInput.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
                textInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                textInput.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -16)]
    }
    
    // MARK: - TextInputs
    
    private lazy var textView: AutoResizeMaterialTextView = {
        let textView = AutoResizeMaterialTextView()
        textView.font = .systemFont(ofSize: 14)
        textView.placeholder = "Placeholder"
        textView.maxHeight = 100
        configTextInputView(textView)
        return textView
    }()
    
    private lazy var textField: MaterialTextField = {
        let textField = MaterialTextField()
        textField.font = .systemFont(ofSize: 14)
        textField.placeholder = "Placeholder"
        configTextInputView(textField)
        return textField
    }()
    
    private func configTextInputView(_ inputView: UIView) {
        inputView.backgroundColor = .white
        inputView.isHidden = true
        inputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputView)
    }
    
    // MARK: - Cells DataSource
    
    private typealias Cell = (title: String?, value: Value)
    private typealias Path<T> = WritableKeyPath<MaterialTextInput, T>
    
    private enum Value {
        case bool(Path<Bool>)
        case color(Path<UIColor>)
        case strings(Path<String?>, list: [String?])
        case number(Path<CGFloat>)
    }
    
    private let cells: [Cell] = [
        (title: "Reserve place for title",
         value: .bool(\.reservePlaceForTitle)),
        (title: "Placeholder color",
         value: .color(\.placeholderColor)),
        (title: "Title color",
         value: .color(\.titleColor)),
        (title: "Placeholder",
         value: .strings(\.placeholder,
                         list: ["Placeholder", "Some text", nil])),
        (title: "Title font size",
         value: .number(\.titleFontSize)),
        (title: "Title bottom inset",
         value: .number(\.titleBottomInset))]
    
    // MARK: - UITableView
    
    private enum CellType: String {
        case switcher, color, string, number
        
        var cellClass: UITableViewCell.Type {
            switch self {
            case .switcher: return SwitcherCell.self
            case .color: return ColorPickerCell.self
            case .string: return StringPickerCell.self
            case .number: return NumberPickerView.self
            }
        }
        
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        let a = SwitcherCell.self
        tableView.register(SwitcherCell.self, forCellReuseIdentifier: "switcher")
        tableView.register(ColorPickerCell.self, forCellReuseIdentifier: "color")
        tableView.register(StringPickerCell.self, forCellReuseIdentifier: "string")
        tableView.register(NumberPickerView.self, forCellReuseIdentifier: "number")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        //top line
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        line.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: tableView.topAnchor)])
        return tableView
    }()
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case (let title, .bool(let path)):
            let cell = tableView.dequeueReusableCell(withIdentifier: "switcher") as! SwitcherCell
            cell.title = title
            cell.property = textInput.property(for: path)
            return cell
        case (let title, .color(let path)):
            let cell = tableView.dequeueReusableCell(withIdentifier: "color") as! ColorPickerCell
            cell.delegate = self
            cell.title = title
            cell.property = textInput.property(for: path)
            return cell
        case (let title, .strings(let path, let list)):
            let cell = tableView.dequeueReusableCell(withIdentifier: "string") as! StringPickerCell
            cell.delegate = self
            cell.title = title
            cell.strings = list
            cell.property = textInput.property(for: path)
            return cell
        case (let title, .number(let path)):
            let cell = tableView.dequeueReusableCell(withIdentifier: "number") as! NumberPickerView
            cell.title = title
            cell.property = textInput.property(for: path)
            return cell
        }
    }
    
    
    
    // MARK: - CellDelegate
    
    func cellHeightDidchange(cell: UITableViewCell) {
        CATransaction.setDisableActions(true)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - KeyboardManager
    
    func keyboardStateWillChange(keyboardIsHidden: Bool, keyboardSize: CGSize) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tableView.contentInset.bottom =
                keyboardIsHidden ? 0 : KeyboardManager.keyboardSize.height
            self?.view.layoutIfNeeded()
        }
    }
    
}
