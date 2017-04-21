//
//  Bisect.swift
//  Hwamei
//
//  Created by ZhangChen on 23/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public protocol Bisectible: Comparable {
    associatedtype Bisector = ([Self], Self, Array<Self>.Index, Array<Self>.Index) -> Array<Self>.Index
    associatedtype Comparator = (Self, Self) -> Int
}

public extension Bisectible {
    static func ascending(_ a: Self, _ b: Self) -> Int {
        return a < b ? -1 : (a > b ? 1 : 0)
    }
}

public func leftBisector<T: Bisectible>(compare: @escaping (T, T) -> Int) ->  ([T], T, Array<T>.Index, Array<T>.Index) -> Array<T>.Index {
    return {(a, x, lo, hi) in
        var lo = max(0, lo)
        var hi = min(hi, a.count)
        
        while (lo < hi) {
            let mid = (lo + hi) >> 1
            if (compare(a[mid], x) < 0) {
                lo = mid + 1
            }
            else {
                hi = mid
            }
        }
        return lo
    }
}

public func rightBisector<T: Bisectible>(compare: @escaping (T, T) -> Int) ->  ([T], T, Array<T>.Index, Array<T>.Index) -> Array<T>.Index {
    return {(a, x, lo, hi) in
        var lo = max(0, lo)
        var hi = min(hi, a.count)
        
        while (lo < hi) {
            let mid = (lo + hi) >> 1
            if (compare(a[mid], x) > 0) {
                hi = mid
            } else {
                lo = mid + 1
            }
        }
        return lo
    }
}

public func bisectRight<T: Bisectible>() -> ([T], T, Array<T>.Index, Array<T>.Index) -> Array<T>.Index {
    return rightBisector(compare: T.ascending)
}

public func bisectLeft<T: Bisectible>() -> ([T], T, Array<T>.Index, Array<T>.Index) -> Array<T>.Index {
    return leftBisector(compare: T.ascending)
}

public func bisect<T: Bisectible>() -> ([T], T, Array<T>.Index, Array<T>.Index) -> Array<T>.Index {
    return bisectRight()
}

extension Int: Bisectible {
    
}

extension Double: Bisectible {
    
}

extension Float: Bisectible {
    
}
