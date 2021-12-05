//
//  URL+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 27/11/2021.
//

import Foundation

extension URL {
    
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
