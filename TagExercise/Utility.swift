//
//  Utility.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation

extension String {
    func isAlphaNumeric() -> Bool {
        if isEmpty {
            return isEmpty
        }
        let invertedalphanumerics = CharacterSet.alphanumerics.inverted
        return (self as NSString).rangeOfCharacter(from: invertedalphanumerics).location == NSNotFound
    }
}
