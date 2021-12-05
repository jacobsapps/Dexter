//
//  HTTPURLResponse+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 27/11/2021.
//

import Foundation

extension HTTPURLResponse {
    
    var isSuccessful: Bool {
        (200...299).contains(statusCode)
    }
}
