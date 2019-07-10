//
//  ClosurePublisher.swift
//  ClosurePublisher
//
//  Created by Tim Gymnich on 7/10/19.
//

import Combine

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Publishers {
    
    /// In contrast with `Publishers.Just`, a `Closure` publisher will evaluate it's closure on every receive call.
    public struct Closure<ReturnType>: Publisher {
        public typealias Output = ReturnType
        public typealias Failure = Never
        
        private var closure: () -> ReturnType
        
        public init(closure: @escaping () -> ReturnType) {
            self.closure = closure
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, Closure.Failure == S.Failure, Closure.Output == S.Input {
            let subscription  = ClosureSubscription(subscriber: subscriber, closure: closure)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class ClosureSubscription<SubscriberType: Subscriber, ReturnType>: Subscription where SubscriberType.Input == ReturnType {
        private var subscriber: SubscriberType?
        private var closure: () -> ReturnType
        
        init(subscriber: SubscriberType, closure: @escaping () -> ReturnType) {
            self.subscriber = subscriber
            self.closure = closure
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = subscriber?.receive(closure())
        }
        
        func cancel() {
            self.subscriber = nil
        }
        
    }
}
