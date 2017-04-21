//
//  Quantile.swift
//  Hwamei
//
//  Created by ZhangChen on 29/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

class ScaleQuantile<S: Bisectible & FloatingPoint & IntConvertible, T: Comparable>: Scale {
    typealias DomainType = S
    typealias RangeType = T
    var _domain: [S] = []
    var _range: [T] = []
    var _thresholds: [S] = []

    var tickFormat: ((Int, String) -> FormatFunc)? = nil
    var ticks: (([String : Any]) -> [S])? = nil
    func scale(_ x: S) -> T {
        return _range[bisect()(_thresholds, x, 0, _thresholds.count)]
    }
    
    func rescale() -> Self {
        let n = max(1, _range.count)
        _thresholds = (1..<n).map {
            quantile(_domain, p: S( $0 / n))
        }
        
        return self
    }
    
    var domain: [S] { get { return _domain } }
    
    func domain(_ d: [S]) -> Self {
        _domain = d.sorted()
        return rescale()
    }
    
    var quantiles: [S] { get { return _thresholds } }
    
    func invertExtent(_ y: T) -> [S] {
        if let i = _range.index(where: { $0 == y }) {
            return [ i > 0 ? _thresholds[i - 1]: _domain.first!, i < _thresholds.count ? _thresholds[i] : _domain.last!]
        } else {
            return [.nan, .nan]
        }
    }
    
    var range: [T] { get { return _range } }

    func range(_ r: [T]) -> Self {
        _range = r
        return rescale()
    }
}
