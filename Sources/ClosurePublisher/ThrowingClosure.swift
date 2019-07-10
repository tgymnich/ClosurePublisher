//
//  ThrowingClosurePublisher.swift
//  ClosurePublisher
//
//  Created by Tim Gymnich on 7/10/19.
//

import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    
    /// In contrast with `Publishers.Just`, a `Closure` publisher will evaluate it's closure on every receive call.
    public struct ThrowingClosure<ReturnType>: Publisher {
        public typealias Output = ReturnType
        public typealias Failure = Error
        
        private var closure: () throws -> ReturnType
        
        public init(closure: @escaping () throws -> ReturnType) {
            self.closure = closure
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, ThrowingClosure.Failure == S.Failure, ThrowingClosure.Output == S.Input {
            let subscription  = ThrowingClosureSubscription(subscriber: subscriber, closure: closure)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class ThrowingClosureSubscription<SubscriberType: Subscriber, ReturnType>: Subscription where SubscriberType.Input == ReturnType, SubscriberType.Failure == Error {
        private var subscriber: SubscriberType?
        private var closure: () throws -> ReturnType
        typealias ErrorType = Error
        
        init(subscriber: SubscriberType, closure: @escaping () throws -> ReturnType) {
            self.subscriber = subscriber
            self.closure = closure
        }
        
        func request(_ demand: Subscribers.Demand) {
            do {
                _ = subscriber?.receive(try closure())
            } catch {
                _ = subscriber?.receive(completion: .failure(error))
            }
        }
        
        func cancel() {
            self.subscriber = nil
        }
        
    }
    
}
