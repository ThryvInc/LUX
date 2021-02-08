//
//  LUXTextValidator.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/18/18.
//

import Foundation

public protocol LUXTextValidatorProtocol {
    var invalidText: String { get }
    func isTextValid(text: String) -> Bool
}

open class LUXNotEmptyTextValidator: LUXTextValidatorProtocol {
    public let invalidText: String = "Cannot be empty"
    
    open func isTextValid(text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}

open class LUXLowercaseTextValidator: LUXTextValidatorProtocol {
    public let invalidText: String = "Cannot be contain uppercase characters"
    
    open func isTextValid(text: String) -> Bool {
        return text.lowercased() == text
    }
}

open class LUXLengthTextValidator: LUXTextValidatorProtocol {
    public let length: Int
    public var invalidText: String {
        get {
            return "Must be at least \(self.length) characters long"
        }
    }
    
    init(length: Int) {
        self.length = length
    }
    
    open func isTextValid(text: String) -> Bool {
        return text.count > length
    }
}

open class LUXRegexTextValidator: LUXTextValidatorProtocol {
    open var regEx = ""
    open var invalidText: String = "Not valid"
    
    open func isTextValid(text: String) -> Bool {
        let regexTest = NSPredicate(format:"SELF MATCHES[c] %@", regEx)
        return regexTest.evaluate(with: text)
    }
}

open class LUXEmailTextValidator: LUXRegexTextValidator {
    public override init() {
        super.init()
        invalidText = "Not a valid email"
        regEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    }
}

public func doesTextFit(in textView: UITextView, replacing range: NSRange, with text: String) -> Bool {
    guard let font = textView.font else { return true }
    
    let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

    let magicNumber: CGFloat = 10 // found this through guessing and experiementation...
    let rect = CGSize(width: textView.bounds.width - magicNumber, height: CGFloat.greatestFiniteMagnitude)
    let textSize = newText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
    
    let numberOfLines = textSize.height / font.lineHeight

    return textSize.height < textView.bounds.height || numberOfLines < 2
}
