//
//  Range.swift
//  d3s
//
//  Created by ZhangChen on 24/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

func range<T: Strideable>(start: T, end: T, step: T.Stride) -> StrideThrough<T> {
    return stride(from: start, through: end, by: step)
}
