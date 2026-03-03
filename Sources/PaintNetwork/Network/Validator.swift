//
//  Validator.swift
//  Paint
//
//  Created by Maverick on 03/03/26.
//
import Foundation

public protocol Validator{
    associatedtype Input
    func validate(_ input: Input) throws -> Bool
}

public struct EmailValidator: Validator {
    public typealias Input = String
    public func validate(_ input: String) -> Bool {
        let emailRegex =
            #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: input)
    }
}

public struct PasswordValidator: Validator {
    public typealias Input = String
    public func validate(_ input: String) -> Bool {
        return input.count >= 5
    }
}
