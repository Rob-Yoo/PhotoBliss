//
//  Observable.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/23/24.
//

import Foundation

final class Observable<T> {
    private var closure: ((T) -> Void)?
    
    var value: T? {
        didSet {
            guard let value else { return }
            self.closure?(value)
        }
    }
    
//    init(_ value: T) {
//        self.value = value
//    }
    
    func bind(closure: @escaping (T) -> Void) {
//        closure(value)
        self.closure = closure
    }
}
