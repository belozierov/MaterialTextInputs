//
//  MaterialTextField.swift
//  MaterialTextInputs
//
//  Created by Beloizerov on 16.01.2018.
//  Copyright © 2018 Home. All rights reserved.
//

@IBDesignable
open class MaterialTextField: UITextField {
    
    // MARK: - Initialize
    
    private func baseInit() {
        updatePlaceholder()
        addTextDidChangeObserver()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
    
    // MARK: - UIView
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutPlaceholder()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        placeholder = "Placeholder"
    }
    
    // MARK: - UITextField
    
    open override var text: String! {
        didSet {
            guard isTitle == text.isEmpty else { return }
            updatePlaceholder(animated: false)
        }
    }
    
    open override var font: UIFont? {
        didSet { setPlaceholderFont() }
    }
    
    open override var textAlignment: NSTextAlignment {
        didSet { placeholderLayer.alignmentMode = placeholderAlignment }
    }
    
    private var placeholderAlignment: String {
        switch textAlignment {
        case .center: return kCAAlignmentCenter
        case .justified: return kCAAlignmentJustified
        case .left: return kCAAlignmentLeft
        case .natural: return kCAAlignmentNatural
        case .right: return kCAAlignmentRight
        }
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard havePlaceholder, reservePlaceForTitle || !text.isEmpty else {
            return super.textRect(forBounds: bounds)
        }
        let inset = (titleFont.lineHeight + titleBottomInset) / 2
        var rect = bounds.insetBy(dx: 0, dy: inset)
        rect.origin.y += inset
        return super.textRect(forBounds: rect)
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // MARK: - NSNotification
    
    private func addTextDidChangeObserver() {
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        guard isTitle == text.isEmpty else { return }
        updatePlaceholder(animated: true)
    }
    
    // MARK: - Placeholder
    
    @IBInspectable open var reservePlaceForTitle: Bool = true {
        didSet {
            guard reservePlaceForTitle != oldValue else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable open override var placeholder: String? {
        get {
            return placeholderLayer.string as? String
        }
        set {
            guard newValue != placeholder else { return }
            let hadPlaceholder = havePlaceholder
            placeholderLayer.string = newValue
            guard hadPlaceholder != havePlaceholder else { return }
            updatePlaceholder()
        }
    }
    
    private lazy var placeholderLayer: CATextLayer = {
        let placeholder = CATextLayer()
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.truncationMode = kCATruncationEnd
        layer.addSublayer(placeholder)
        return placeholder
    }()
    
    private var havePlaceholder: Bool {
        return placeholder?.isEmpty == false
    }
    
    // MARK: - Placeholder update
    
    private var isTitle = false
    
    private func updatePlaceholder() {
        placeholderLayer.isHidden = !havePlaceholder
        isTitle = !text.isEmpty
        invalidateIntrinsicContentSize()
        guard havePlaceholder else { return }
        setPlaceholderFont()
        setPlaceholderColor()
        layoutPlaceholder()
    }
    
    // MARK: - Placeholder animation
    
    open var placeholderAnimationDuration: Double?
    
    private func updatePlaceholder(animated: Bool) {
        let animation = animated && !CATransaction.disableActions()
        setAnimation(turnOn: animation) {
            if animation, let customDuration = placeholderAnimationDuration {
                CATransaction.setAnimationDuration(customDuration)
            }
            updatePlaceholder()
            if !animation { placeholderLayer.displayIfNeeded() }
            if !reservePlaceForTitle { layoutIfNeeded() }
        }
    }
    
    private func setAnimation(turnOn: Bool, block: (() -> ())) {
        CATransaction.begin()
        CATransaction.setDisableActions(!turnOn)
        block()
        CATransaction.commit()
    }
    
    // MARK: - Placeholder rect
    
    @IBInspectable open var titleBottomInset: CGFloat = 8 {
        didSet {
            guard titleBottomInset != oldValue else { return }
            invalidateIntrinsicContentSize()
        }
    }
    
    private func layoutPlaceholder() {
        CATransaction.setDisableActions(false)
        let rect = isTitle ? super.textRect(forBounds: bounds) : textRect(forBounds: bounds)
        let height = max(titleFont.lineHeight, placeholderFont.lineHeight)
        let size = CGSize(width: rect.width, height: height)
        placeholderLayer.frame = CGRect(origin: rect.origin, size: size)
    }
    
    private func position(for rect: CGRect) -> CGPoint {
        let x = rect.origin.x + rect.size.width / 2
        let y = rect.origin.y + rect.size.height / 2
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Placeholder fonts
    
    @IBInspectable open var titleFontSize: CGFloat = 12 {
        didSet {
            guard titleFontSize != oldValue else { return }
            setPlaceholderFont()
            invalidateIntrinsicContentSize()
        }
    }
    
    private var titleFont: UIFont {
        return UIFont(descriptor: placeholderFont.fontDescriptor, size: titleFontSize)
    }
    
    private var placeholderFont: UIFont {
        return font ?? .systemFont(ofSize: UIFont.systemFontSize)
    }
    
    private func setPlaceholderFont() {
        placeholderLayer.font = placeholderFont.fontName as CFTypeRef
        let font = isTitle ? titleFont : placeholderFont
        placeholderLayer.fontSize = font.pointSize
    }
    
    // MARK: - Placeholder Colors
    
    @IBInspectable open var placeholderColor: UIColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) {
        didSet { if !isTitle { setPlaceholderColor() } }
    }
    
    @IBInspectable open var titleColor: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) {
        didSet { if isTitle { setPlaceholderColor() } }
    }
    
    private func setPlaceholderColor() {
        let color = isTitle ? titleColor : placeholderColor
        placeholderLayer.foregroundColor = color.cgColor
    }
    
}
