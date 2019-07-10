//
//  ClosurePublisher.swift
//  ClosurePublisher
//
//  Created by Tim Gymnich on 7/10/19.
//

import Combine

@available(OSX 10.15, iOS 13, *)
extension Publishers {
    
    public struct ClosurePublisher<ReturnType>: Publisher {
        public typealias Output = ReturnType
        public typealias Failure = Never
        
        private var closure: () -> ReturnType
        
        public init(closure: @escaping () -> ReturnType) {
            self.closure = closure
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, ClosurePublisher.Failure == S.Failure, ClosurePublisher.Output == S.Input {
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
