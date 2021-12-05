//
//  Codable+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 24/11/2021.
//

import Foundation

extension JSONEncoder {
    static var snakeCaseEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .custom { (date, encoder) in
            var container = encoder.singleValueContainer()
            try container.encode(date.isoString)
        }
        return encoder
    }
}

extension Encodable {
    var data: Data? { try? JSONEncoder.snakeCaseEncoder.encode(self) }
}

extension JSONDecoder {
    static var snakeCaseDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = dateString.isoDate else {
                throw CustomDecodingError.date
            }
            return date
        }
        return decoder
    }
}

enum CustomDecodingError: Error {
    case date
}

private extension Date {
    
    var isoString: String {
        DateFormatter.iso8601.string(from: self)
    }
}

public extension String {
    
    var isoDate: Date? {
        guard let date = DateFormatter.iso8601.date(from: self) else {
            assertionFailure("Date decoder brokwn for string: \(self)")
            return nil
        }
        return date
    }
}

private extension DateFormatter {
    
    static var iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withFullDate,
            .withTime,
            .withDashSeparatorInDate,
            .withColonSeparatorInTime
        ]
        return formatter
    }()
}
