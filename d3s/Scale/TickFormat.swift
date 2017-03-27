//
//  TickFormat.swift
//  d3s
//
//  Created by ZhangChen on 27/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

public func tickFormat(domain: [Double], count: Int, specifier: String) -> FormatFunc {
    // TODO: support formatSpecifier
    return format(specifier)
}
