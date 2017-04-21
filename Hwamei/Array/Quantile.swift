//
//  Quantile.swift
//  Hwamei
//
//  Created by ZhangChen on 29/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation


fileprivate func number3<T: FloatingPoint>(_ x: T, _: Int, _: [T]) -> T {
    return x
}

public protocol IntConvertible {
    func asInt() -> Int
}

extension Float: IntConvertible {
    public func asInt() -> Int {
        return Int(self)
    }
}

extension Double: IntConvertible {
    public func asInt() -> Int {
        return Int(self)
    }
}


public func quantile<S, T: FloatingPoint & IntConvertible>(_ array: [S], p: T, f: (S, Int, [S]) -> T) -> T {
    assert(!array.isEmpty)
    if p <= 0 || array.count < 2 {
        return f(array[0], 0, array)
    }
    if p >= 1 {
        return f(array.last!, array.count - 1, array)
    }
    
    let h = T(array.count - 1) * p
    let j = floor(h)
    let i = j.asInt()
    let a = f(array[i], i, array)
    let b = f(array[i + 1], i + 1, array)
    return a + (b - a) * (h - j)
}

public func quantile<T: FloatingPoint & IntConvertible>(_ array: [T], p: T) -> T {
    return quantile(array, p: p, f: number3)
}
