//
//  CombineModelFunctions.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 12/7/19.
//

import Combine
import Slippers

@available(iOS 13.0, *)
public func modelPublisher<T>(from dataPublisher: AnyPublisher<Data?, Never>) -> AnyPublisher<T, Never> where T: Decodable {
    #if targetEnvironment(simulator)
        return dataPublisher.skipNils().compactMap({ JsonProvider.forceDecode(T.self, from: $0) }).eraseToAnyPublisher()
    #else
        return dataPublisher.skipNils().compactMap({ JsonProvider.decode(T.self, from: $0) }).eraseToAnyPublisher()
    #endif
}

@available(iOS 13.0, *)
public func unwrappedModelPublisher<T, U>(from dataPublisher: AnyPublisher<Data?, Never>, _ unwrapper: @escaping (T) -> U?) -> AnyPublisher<U, Never> where T: Decodable {
    return modelPublisher(from: dataPublisher).compactMap(unwrapper).eraseToAnyPublisher()
}

@available(iOS 13.0, *)
public func optModelPublisher<T>(from dataPublisher: AnyPublisher<Data?, Never>?) -> AnyPublisher<T, Never>? where T: Decodable {
    #if targetEnvironment(simulator)
        return dataPublisher?.skipNils().compactMap({ JsonProvider.forceDecode(T.self, from: $0) }).eraseToAnyPublisher()
    #else
        return dataPublisher?.skipNils().compactMap({ JsonProvider.decode(T.self, from: $0) }).eraseToAnyPublisher()
    #endif
}

@available(iOS 13.0, *)
public func unwrappedModelPublisher<T, U>(from dataPublisher: AnyPublisher<Data?, Never>?, _ unwrapper: @escaping (T) -> U?) -> AnyPublisher<U, Never>? where T: Decodable {
    return optModelPublisher(from: dataPublisher)?.compactMap(unwrapper).eraseToAnyPublisher()
}

@available(iOS 13.0, *)
public extension Publisher where Self.Failure == Never {
    func sinkThrough(_ f: @escaping (Output) -> Void) -> AnyCancellable {
        return dropFirst().sink(receiveValue: f)
    }
}

@available(iOS 13.0, *)
public extension Publisher {
    func skipNils<T>() -> Publishers.CompactMap<Self, T> where Self.Output == T?  {
        return self.compactMap { $0 }
    }
}
