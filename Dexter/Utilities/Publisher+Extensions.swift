//
//  Publisher+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 27/11/2021.
//

import Combine
import Foundation

public extension Publisher {

    func sinkNetworkRequest(_ handleValue: ((Output) -> Void)? = nil,
                            handleFailure: ((Error) -> Void)? = nil,
                            store subscriptions: inout Set<AnyCancellable>)  {
        sink(receiveCompletion: { $0.handleCompletion(handleFailure) },
             receiveValue: { handleValue?($0) })
            .store(in: &subscriptions)
    }
}

public extension Subscribers.Completion {
    
    func handleCompletion(_ handleFailure: ((Error) -> Void)? = nil) {
        switch self {
        case .failure(let error):
            print(error.localizedDescription)
            handleFailure?(error)
            
        case .finished:
            break
        }
    }
}
