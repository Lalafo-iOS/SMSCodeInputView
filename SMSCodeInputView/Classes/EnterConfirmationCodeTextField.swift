//
//  EnterConfirmationCodeTextField.swift
//  SMSCodeInputView
//
//  Created by Sergey Zalozniy on 14.03.2021.
//

import UIKit

class EnterConfirmationCodeTextField: UITextField {
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
    
    // MARK: - Instance initialization
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
