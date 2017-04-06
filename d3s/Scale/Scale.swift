//
//  Scale.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public protocol Scale {
    associatedtype DomainType
    associatedtype RangeType
    var domain: [DomainType] { get }
    //var range: [RangeType] { get }
    // func rescale() -> Self
    func scale(_ x: DomainType) -> RangeType
    var ticks: (([String: Any]) -> [DomainType])? { get }
    var tickFormat: ((Int, String) -> FormatFunc)? { get }
}

public protocol RangedScale: Scale {
    var range: [RangeType] { get }
}

public protocol InvertibleScale: RangedScale {
    func invert(_ y: RangeType) -> DomainType
}
