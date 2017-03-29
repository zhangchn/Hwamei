//
//  Ordinal.swift
//  d3s
//
//  Created by ZhangChen on 29/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

class Ordinal<S: Hashable, T>: Scale {
    typealias DomainType = S
    typealias RangeType = T?
    
    var _unknown: T?
    var _domain: [S] = []
    var _range: [T?] = []
    
    var domain: [S] { get { return _domain } }
    func domain(_ d: [S]) -> Self {
        _domain = []
        index = [:]
        for key in d {
            if index[key] == nil {
                _domain.append(key)
                index[key] = _domain.count
            }
        }
        return rescale()
    }
    
    var range: [T?] { get { return _range } }
    func range(_ r: [T?]) -> Self {
        _range = r
        return rescale()
    }
    var unknown: T? { get { return _unknown } }
    func unknown(_ r: T?) -> Self {
        _unknown = r
        return rescale()
    }
    
    var index : [S : Int] = [:]
    func rescale() -> Self {
        return self
    }
    
    func scale(_ x: DomainType) -> RangeType {
        var v = index[x]
        if v == nil {
            if _unknown != nil {
                return _unknown
            }
            _domain.append(x)
            index[x] = _domain.count
            v = _domain.count
        }
        return _range[(v! - 1) % _range.count]
    }

}
