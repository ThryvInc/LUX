//
//  LithoOperators.swift
//  LithoOperators
//
//  Created by Elliot Schrock on 10/12/19.
//

import Prelude

infix operator >?>: Composition
public func >?><A, B, C>(f: @escaping (A) -> B?, g: @escaping (B) -> C) -> (A) -> C? {
    return { a in
        if let b = f(a) {
            return g(b)
        } else {
            return nil
        }
    }
}

prefix operator ~
public prefix func ~<A, B, C>(f: @escaping (A, B) -> C) -> ((A, B)) -> C {
    return { (tuple: (A, B)) -> C in
        return f(tuple.0, tuple.1)
    }
}

infix operator <>: Composition
public func <><A>(f: @escaping (A) -> Void, g: @escaping (A) -> Void) -> (A) -> Void {
    return { a in
        f(a)
        g(a)
    }
}

//allows mutating A, as opposded to <>
infix operator <~>: Composition
public func <~><A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}

//allows mutating A, as opposed to |>
infix operator />: ForwardApplication
public func /><A>(a: inout A, f: @escaping (inout A) -> Void) -> Void {
    f(&a)
}

//this is basically an operator for currying
infix operator >|>: Composition
public func >|><A, B, C>(a: A, f: @escaping (A, B) -> C) -> (B) -> C {
    return { b in f(a, b) }
}

//basically an operator for currying, but the value goes into the second place
infix operator >||>: Composition
public func >||><A, B, C>(b: B, f: @escaping (A, B) -> C) -> (A) -> C {
    return { a in f(a, b) }
}

prefix operator ^
public prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return get(kp)
}
public prefix func ^<Root, Value>(kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return prop(kp)
}
public prefix func ^ <Root, Value>(
  _ kp: WritableKeyPath<Root, Value>
  )
  -> (@escaping (inout Value) -> Void)
  -> (inout Root) -> Void {

    return { update in
      { root in
        update(&root[keyPath: kp])
      }
    }
}

//other useful higher order functions

public func map<U, V>(array: [U], f: (U) -> V) -> [V] {
    return array.map(f)
}

public extension Sequence {
  func map<Value>(_ kp: KeyPath<Element, Value>) -> [Value] {
    return self.map { $0[keyPath: kp] }
  }
}

public func map<Element, Value>(array: [Element], _ kp: KeyPath<Element, Value>) -> [Value] {
    return array.map(kp)
}

public func voidCurry<T>(_ t: T, _ f: @escaping (T) -> Void) -> () -> Void {
    return { f(t) }
}

public func ifExecute<T>(_ t: T?, _ f: (T) -> Void) {
    if let t = t {
        f(t)
    }
}

public func ifExecute<T, U>(_ t: T?, _ f: (T) -> U) -> U? {
    if let t = t {
        return f(t)
    }
    return nil
}

public protocol ConditionalApply {}
extension ConditionalApply {
    public func ifApply(_ condition: Bool, _ function: (Self) -> Self) -> Self {
        if condition {
            return function(self)
        } else {
            return self
        }
    }
}



public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

public func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ f: @escaping (Value) -> Value
  )
  -> (Root) -> Root {

    return prop(kp)(f)
}

public func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ value: Value
  )
  -> (Root) -> Root {

    return prop(kp) { _ in value }
}

public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func over<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ set: @escaping (A) -> B
  )
  -> (S) -> T {
    return setter(set)
}

public func set<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ value: B
  )
  -> (S) -> T {
    return over(setter) { _ in value }
}

public func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in
    root[keyPath: kp]
  }
}

public typealias MutableSetter<S, A> = (@escaping (inout A) -> Void) -> (inout S) -> Void

public func mver<S, A>(
  _ setter: MutableSetter<S, A>,
  _ set: @escaping (inout A) -> Void
  )
  -> (inout S) -> Void {
    return setter(set)
}

public func mut<S, A>(
  _ setter: MutableSetter<S, A>,
  _ value: A
  )
  -> (inout S) -> Void {
    return mver(setter) { $0 = value }
}

public func mutEach<A>(_ f: @escaping (inout A) -> Void) -> (inout [A]) -> Void {
  return {
    for i in $0.indices {
      f(&$0[i])
    }
  }
}
