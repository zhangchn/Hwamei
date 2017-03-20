//
//  d3sTests.swift
//  d3sTests
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import XCTest
import UIKit
import QuartzCore

@testable import d3s

class d3sTests: XCTestCase {
    var view: UIView?
    override func setUp() {
        super.setUp()
        view = UIView()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        view = nil
    }
    
    func testDataAppend() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let predicate = NSPredicate(format: "%K = 's'", "age")
        let sel = view!.selectAll(predicate).data(value: [[1, 2], [2, 3, 7]]).enter()
        XCTAssertTrue(sel._enterGroups.count == 1)
        let newNodes = sel.append { (node, data, idx, group) -> CALayer? in
            return CALayer()
        }
        XCTAssertTrue(newNodes._groups.count == 1)
        let groups = newNodes._groups
        XCTAssertTrue((groups[0][1].value(forKey: "__data__") as? [Int])! == [2, 3, 7])
        XCTAssertTrue(groups[0][0].superlayer == view!.layer)
    }
    
    func testDataUpdate() {
        let layer1 = CALayer()
        layer1.setValue(3, forKey: "cal")
        view!.layer.addSublayer(layer1)
        
        let p = NSPredicate(format: "cal = 3")
        let update = view!.selectAll(p).data(value: [2, 3])
        let groups = update._groups
        XCTAssertTrue(groups[0][0] == layer1)
        
    }
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
