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
    var range: [RangeType] { get }
    func rescale() -> Self
    func scale(_ x: DomainType) -> RangeType
}




