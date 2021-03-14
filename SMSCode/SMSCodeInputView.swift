//
//  SMSCodeInputView.swift
//  Lalafo
//
//  Created by Sergey Zalozniy on 14.01.2021.
//

import UIKit

protocol SMSCodeInputViewDelegate: class {
    func smsCodeInputView(_ view: SMSCodeInputView,
                          didChange code: String)
}

class SMSCodeInputView: UIView {
    weak var delegate: SMSCodeInputViewDelegate?
    
    @objc dynamic
    var numberOfDigits: Int
    @objc dynamic
    var isSecureTextEntry: Bool = false
    @objc dynamic
    var font: UIFont = UIFont.systemFont(ofSize: 17)
    @objc dynamic
    var textColor: UIColor = UIColor.darkText
    
    @objc dynamic
    var borderEdges: UIRectEdge = UIRectEdge.bottom
    @objc dynamic
    var activeDigitBorderColor: UIColor = UIColor(red: 0.133, green: 0.792, blue: 0.275, alpha: 1)
    @objc dynamic
    var noramlDigitBorderColor: UIColor = UIColor.lightGray
    @objc dynamic
    var errorDigitBorderColor: UIColor = UIColor.systemRed
    
    @objc dynamic
    var activeDigitBorderWidth: CGFloat = 1
    @objc dynamic
    var noramlDigitBorderWidth: CGFloat = 1
    @objc dynamic
    var errorDigitBorderWidth: CGFloat = 2
    @objc dynamic
    var filledDigitBorderWidth: CGFloat = 2
    
    @objc dynamic
    var activeDigitBackgrounColor: UIColor = UIColor(red: 0.133, green: 0.792, blue: 0.275, alpha: 0.1)
    @objc dynamic
    var normalDigitBackgroundColor: UIColor = UIColor.clear
    @objc dynamic
    var errorDigitBackgroundColor: UIColor = UIColor.systemRed.withAlphaComponent(0.3)
    
    @objc dynamic
    var digitSize: CGSize = CGSize(width: 48, height: 49)
    @objc dynamic
    var digitSpacing: CGFloat = 8
    
    private (set) var code: String = ""
    
    private let stackView: UIStackView = UIStackView()
    private var smsCodeTextFields: [EnterConfirmationCodeTextField] = []
    private var observations: [NSKeyValueObservation] = []

    private enum State {
        case normal
        case error
    }
    private var state: State = .normal
    
    override var intrinsicContentSize: CGSize {
        let width: CGFloat = CGFloat(numberOfDigits) * digitSize.width + CGFloat(numberOfDigits - 1) * digitSpacing
        return CGSize(width: width, height: digitSize.height)
    }
    
    // MARK: - Instance initialization
    required init(digits: Int) {
        self.numberOfDigits = digits
        super.init(frame: .zero)
     
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.numberOfDigits = 5
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Override methods
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        guard let firstTextField = smsCodeTextFields.first else {
            return false
        }
        return firstTextField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        guard let firstTextField = smsCodeTextFields.first(where: { $0.isFirstResponder}) else {
            return false
        }
        return firstTextField.resignFirstResponder()
    }
    
    // MARK: - Interface methods
    func highlightErrorState() {
        state = .error
        
        updateTextFieldState()
    }
    
    // MARK: - Private methods
    private func commonInit() {
        configureStackView()
        configureInputFields()
        configureObservers()
    }
    
    private func configureObservers() {
        let keypathForObservers: [AnyKeyPath] = [
            \SMSCodeInputView.numberOfDigits,
            \SMSCodeInputView.isSecureTextEntry,
            \SMSCodeInputView.font,
            \SMSCodeInputView.textColor,
            \SMSCodeInputView.borderEdges,
            \SMSCodeInputView.activeDigitBorderColor,
            \SMSCodeInputView.noramlDigitBorderColor,
            \SMSCodeInputView.errorDigitBorderColor,
            \SMSCodeInputView.activeDigitBorderWidth,
            \SMSCodeInputView.noramlDigitBorderWidth,
            \SMSCodeInputView.errorDigitBorderWidth,
            \SMSCodeInputView.filledDigitBorderWidth,
            \SMSCodeInputView.activeDigitBackgrounColor,
            \SMSCodeInputView.normalDigitBackgroundColor,
            \SMSCodeInputView.errorDigitBackgroundColor,
            \SMSCodeInputView.digitSize,
            \SMSCodeInputView.digitSpacing]
        
        keypathForObservers
            .forEach { keyPath in
                let observerHandler: ((Any, Any) -> Void) = { [unowned self] (_, _) in
                    self.configureInputFields()
                    self.invalidateIntrinsicContentSize()
                }
                let observation: NSKeyValueObservation?
                switch keyPath {
                case let keypath as KeyPath<SMSCodeInputView, Int>:
                    observation = observe(keypath, changeHandler: observerHandler)

                case let keypath as KeyPath<SMSCodeInputView, UIFont>:
                    observation = observe(keypath, changeHandler: observerHandler)
                    
                case let keypath as KeyPath<SMSCodeInputView, Bool>:
                    observation = observe(keypath, changeHandler: observerHandler)
                    
                case let keypath as KeyPath<SMSCodeInputView, CGFloat>:
                    observation = observe(keypath, changeHandler: observerHandler)

                case let keypath as KeyPath<SMSCodeInputView, CGSize>:
                    observation = observe(keypath, changeHandler: observerHandler)
                    
                case let keypath as KeyPath<SMSCodeInputView, UIColor>:
                    observation = observe(keypath, changeHandler: observerHandler)
                    
                case let keypath as KeyPath<SMSCodeInputView, UIRectEdge>:
                    observation = observe(keypath, changeHandler: observerHandler)

                default:
                    observation = nil
                }
                if let observation = observation {
                    observations.append(observation)
                }
        }
    }
    
    private func configureInputFields() {
        guard numberOfDigits > 0 else {
            assertionFailure("numberOfDigits should be more than 0")
            return
        }
        
        smsCodeTextFields.removeAll()
        
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
            subview.tag = 0
        }
        
        for i in 1...numberOfDigits {
            let textField = EnterConfirmationCodeTextField(frame: .zero)

            textField.borderEdges = borderEdges
            textField.font = font
            textField.textColor = textColor
            textField.isSecureTextEntry = isSecureTextEntry
            textField.tag = i
            textField.delegate = self
            textField.textAlignment = .center
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            textField.keyboardType = .numberPad
            textField.backgroundColor = UIColor.white
            textField.addTarget(self, action: #selector(updateTextFieldState), for: UIControl.Event.editingChanged)
            smsCodeTextFields.append(textField)
        }
        
        smsCodeTextFields.forEach { textField in
            stackView.addArrangedSubview(textField)
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            let widthConstrant = NSLayoutConstraint(item: textField,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1,
                                                    constant: digitSize.width)
            
            textField.addConstraint(widthConstrant)
            
            let heightConstrant = NSLayoutConstraint(item: textField,
                                                    attribute: .width,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1,
                                                    constant: digitSize.height)
            textField.addConstraint(heightConstrant)
        }
        
        updateTextFieldState()
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = digitSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        let edges: [NSLayoutConstraint.Attribute] = [.top, .bottom, .left, .right]
        edges.forEach { edge in
            let constraint = NSLayoutConstraint(item: stackView,
                                                attribute: edge,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: edge,
                                                multiplier: 1,
                                                constant: 0)
            addConstraint(constraint)
        }
    }
    
    private func userDidIntsertFullCodeFromPastboard(_ code: String) {
        for i in 0..<numberOfDigits {
            let index = code.index(code.startIndex, offsetBy: i)
            smsCodeTextFields[i].text = String(code[index])
        }
        updateTextFieldState()
    }
    
    @objc
    private func updateTextFieldState() {
        let newCode = smsCodeTextFields
            .map({ $0.text! })
            .joined()
        
        if newCode != code {
            state = .normal
            code = newCode
            delegate?.smsCodeInputView(self, didChange: code)
        }
        
        smsCodeTextFields.forEach { textField in
            textField.separatorHeight = borderWidth(for: textField)
            textField.separatorColor = borderColor(for: textField)
            textField.backgroundColor = backgroundColor(for: textField)
        }
    }
    
    private func backgroundColor(for textField: EnterConfirmationCodeTextField) -> UIColor {
        if textField.isFirstResponder {
            return activeDigitBackgrounColor
        }
        
        switch state {
        case .normal:
            return normalDigitBackgroundColor
        case .error:
            return errorDigitBackgroundColor
        }
    }
    
    private func borderWidth(for textField: EnterConfirmationCodeTextField) -> CGFloat {
        if textField.isFirstResponder {
            return activeDigitBorderWidth
        }
        
        switch state {
        case .normal:
            if textField.text?.count == 1 {
                return filledDigitBorderWidth
            }
            return noramlDigitBorderWidth
        case .error:
            return errorDigitBorderWidth
        }
    }
    
    private func borderColor(for textField: EnterConfirmationCodeTextField) -> UIColor {
        if textField.isFirstResponder {
            return activeDigitBorderColor
        }
        
        switch state {
        case .normal:
            return noramlDigitBorderColor
        case .error:
            return errorDigitBorderColor
        }
    }
}

extension SMSCodeInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.sendActions(for: UIControl.Event.editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldCount = textField.text?.count else {
            return false
        }
        
        let textCount = string.count
        if textCount == numberOfDigits {
            userDidIntsertFullCodeFromPastboard(string)
            return false
        }
        
        let setValueAndMoveForward = {
            textField.text = string
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
            textField.sendActions(for: UIControl.Event.editingChanged)
        }
        
        let clearValueAndMoveBack = {
            textField.text = ""
            let previousTag = textField.tag - 1
            if let previousResponder = textField.superview?.viewWithTag(previousTag) {
                previousResponder.becomeFirstResponder()
            }
            textField.sendActions(for: UIControl.Event.editingChanged)
        }
        
        if textFieldCount < 1 && string.count > 0 {
            setValueAndMoveForward()
            return false
        } else if textFieldCount >= 1 && string.count == 0 {
            clearValueAndMoveBack()
            return false
        } else if textFieldCount >= 1 {
            setValueAndMoveForward()
            return false
        }
        
        return true
    }
}

fileprivate class EnterConfirmationCodeTextField: UITextField {
    var separatorHeight: CGFloat = 1 {
        didSet {
            updateSeparatorHeightConstraint()
        }
    }
    
    var separatorColor: UIColor = UIColor.clear {
        didSet {
            updateSeparatorColor()
        }
    }
    
    var borderEdges: UIRectEdge = .all {
        didSet {
            updateVisibleBorderEdges()
        }
    }
    
    private let bottomSeparatorView: UIView = UIView()
    private let topSeparatorView: UIView = UIView()
    private let leftSeparatorView: UIView = UIView()
    private let rightSeparatorView: UIView = UIView()
    private var separators: [UIView] {
        return [bottomSeparatorView, topSeparatorView, leftSeparatorView, rightSeparatorView]
    }
    private var separatorHeightConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSeparator()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureSeparator()
    }

    // MARK: - Private methods
    private func configureSeparator() {
        separators.forEach { separator in
            addSubview(separator)
        }
        
        let pinToEdges: [UIView: [NSLayoutConstraint.Attribute]] = [
            bottomSeparatorView: [.bottom, .left, .right],
            topSeparatorView: [.top, .left, .right],
            leftSeparatorView: [.top, .bottom, .left],
            rightSeparatorView: [.top, .bottom, .right]]
        
        pinToEdges.forEach { (separator, edges) in
            separator.translatesAutoresizingMaskIntoConstraints = false
            
            edges.forEach { edge in
                let constraint = NSLayoutConstraint(item: separator,
                                                    attribute: edge,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: edge,
                                                    multiplier: 1,
                                                    constant: 0)
                addConstraint(constraint)
            }
            
            let heightAttribute: NSLayoutConstraint.Attribute
            if edges.contains(.bottom) && edges.contains(.top) {
                heightAttribute = NSLayoutConstraint.Attribute.width
            } else {
                heightAttribute = NSLayoutConstraint.Attribute.height
            }
            
            let constraint = NSLayoutConstraint(item: separator,
                                                attribute: heightAttribute,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: separatorHeight)
            separator.addConstraint(constraint)
            separatorHeightConstraints.append(constraint)
        }
        

        
    }
    
    private func updateSeparatorHeightConstraint() {
        separatorHeightConstraints.forEach { constraint in
            constraint.constant = separatorHeight
        }
    }
    
    private func updateSeparatorColor() {
        separators.forEach { separator in
            separator.backgroundColor = separatorColor
        }
    }
    
    private func updateVisibleBorderEdges() {
        topSeparatorView.isHidden = !borderEdges.contains(.top)
        bottomSeparatorView.isHidden = !borderEdges.contains(.bottom)
        leftSeparatorView.isHidden = !borderEdges.contains(.left)
        rightSeparatorView.isHidden = !borderEdges.contains(.right)
    }

    // MARK: - Override Methods
    override func deleteBackward() {
        super.deleteBackward()
        
        let previousTag = tag - 1
        if let previousResponder = superview?.viewWithTag(previousTag) {
            previousResponder.becomeFirstResponder()
            
            if let activeTextField = previousResponder as? UITextField {
                if let isEmpty = activeTextField.text?.isEmpty, !isEmpty {
                    activeTextField.text = ""
                }
            }
        }
        sendActions(for: UIControl.Event.editingChanged)
    }
}
