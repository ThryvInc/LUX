//
//  CombineModelFunctions.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 12/7/19.
//

import Combine

@available(iOS 13.0, *)
public func modelPublisher<T>(from dataPublisher: AnyPublisher<Data?, Never>) -> AnyPublisher<T, Never> where T: Decodable {
    #if targetEnvironment(simulator)
        return dataPublisher.compactMap({ $0 }).compactMap({ LUXJsonProvider.forceDecode(T.self, from: $0) }).eraseToAnyPublisher()
    #else
        return dataPublisher.compactMap({ $0 }).compactMap({ LUXJsonProvider.decode(T.self, from: $0) }).eraseToAnyPublisher()
    #endif
}

@available(iOS 13.0, *)
public func unwrappedModelPublisher<T, U>(from dataPublisher: AnyPublisher<Data?, Never>, _ unwrapper: @escaping (T) -> U?) -> AnyPublisher<U, Never> where T: Decodable {
    return modelPublisher(from: dataPublisher).compactMap(unwrapper).eraseToAnyPublisher()
}

@available(iOS 13.0, *)
public func optModelPublisher<T>(from dataPublisher: AnyPublisher<Data?, Never>?) -> AnyPublisher<T, Never>? where T: Decodable {
    #if targetEnvironment(simulator)
        return dataPublisher?.compactMap({ $0 }).compactMap({ LUXJsonProvider.forceDecode(T.self, from: $0) }).eraseToAnyPublisher()
    #else
        return dataPublisher?.compactMap({ $0 }).compactMap({ LUXJsonProvider.decode(T.self, from: $0) }).eraseToAnyPublisher()
    #endif
}

@available(iOS 13.0, *)
public func unwrappedModelPublisher<T, U>(from dataPublisher: AnyPublisher<Data?, Never>?, _ unwrapper: @escaping (T) -> U?) -> AnyPublisher<U, Never>? where T: Decodable {
    return optModelPublisher(from: dataPublisher)?.compactMap(unwrapper).eraseToAnyPublisher()
}

@available(iOS 13.0, *)
public extension Publisher where Self.Failure == Never {
    func sinkThrough(_ f: @escaping (Output) -> Void) -> AnyCancellable {
        var isFirstValue = true
        return sink { output in
            if !isFirstValue {
                f(output)
            }
            isFirstValue = false
        }
    }
}
