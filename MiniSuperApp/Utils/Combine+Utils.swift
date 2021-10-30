//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/10/30.
//

import Foundation
import Combine
import CombineExt

public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
    
    public typealias Output = Element
    public typealias Failure = Never
    
    public var value: Element {
        return self.currentValueRelay.value
    }
    
    fileprivate let currentValueRelay: CurrentValueRelay<Output>
    
    fileprivate init(_ initialValue: Element) {
        self.currentValueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Element == S.Input {
        self.currentValueRelay.receive(subscriber: subscriber)
    }
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    
    typealias Output = Element
    typealias Failure = Never
    
    override init(_ initialValue: Element) {
        super.init(initialValue)
    }
    
    public func send(_ value: Element) {
        self.currentValueRelay.accept(value)
    }
}
