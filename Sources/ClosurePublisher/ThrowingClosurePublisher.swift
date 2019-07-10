//
//  ThrowingClosurePublisher.swift
//  ClosurePublisher
//
//  Created by Tim Gymnich on 7/10/19.
//

import Foundation
import Combine

@available(OSX 10.15, iOS 13, *)
extension Publishers {
    
    public struct ThrowingClosurePublisher<ReturnType>: Publisher {
        public typealias Output = ReturnType
        public typealias Failure = Error
        
        private var closure: () throws -> ReturnType
        
        public init(closure: @escaping () throws -> ReturnType) {
            self.closure = closure
        }
        
        public func receive<S>(subscriber: S) where S : Subscriber, ThrowingClosurePublisher.Failure == S.Failure, ThrowingClosurePublisher.Output == S.Input {
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
