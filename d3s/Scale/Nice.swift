//
//  Nice.swift
//  d3s
//
//  Created by ZhangChen on 27/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

func nice(domain: [Double],
          floor f: (Double) -> Double,
          ceil c: (Double) -> Double) -> [Double] {
    var d = domain
    var i = 0
    var j = d.count - 1
    var start = d.first!
    var stop = d.last!
    
    if stop < start {
        i = j
        j = 0
        (start, stop) = (stop, start)
    }
    d[i] = f(start)
    d[j] = c(stop)
    return d
}
