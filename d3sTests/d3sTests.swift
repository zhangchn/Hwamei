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
    
    func testDataUpdateEnterMerge() {
        let predicate1 = NSPredicate(format: "cls = 3")
        
        let view1 = view!
        
        func f1 (d: [Int]) {
            let update = view1.selectAll(predicate1).data(value: d)
            let enter = update.enter()
                .append(name: .layer)
                .property("cls", value: 3)
            
            _ = update.exit().remove()
            
            _ = update.merge(enter).property("v") { (layer, datum, idx, group) -> Any? in
                return datum
            }
        }
        f1(d: [2, 3, 4])
        f1(d: [11, 2, 4, 5, 7])
        let v = view1.layer.sublayers!.flatMap { layer in
            layer.value(forKey: "v")
        } as! [Int]
        XCTAssertTrue(v.contains(11))
        XCTAssertTrue(v.contains(2))
        XCTAssertTrue(v.contains(4))
        XCTAssertTrue(v.contains(5))
        XCTAssertTrue(v.contains(7))
        XCTAssertTrue(v.count == 5)
    }
    
//    func testArc() {
//        let a = Arc().innerRadius(0).outerRadius(30).startAngle(-.pi).endAngle(.pi)
//        
//        let p = a.arc()
//
//        let circular = view!.select(NSPredicate()).data(value: [0, 1 ,2])
//            .enter().append(name: .shape)
//            .property("bounds", value: NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80)))
//            .property("backgroundColor", value: UIColor.yellow.cgColor)
//            .property("strokeColor", value: UIColor.red.cgColor)
//            .property("fillColor", value: UIColor.red.cgColor)
//            .style(name: "transform", value: CATransform3DMakeTranslation(140, 140, 0) as AnyObject?)
//            .property("path", value: p)
//        XCTAssert(<#T##expression: Bool##Bool#>)
//    }
    
    func testContinuousScale() {
        let c = Continuous<Double, Double>.init(deinterpolate: Double.reverseInterpolate, reinterpolate: Double.interpolate)
        _ = c.domain([1, 10]).range([10, 100])
        XCTAssertTrue(c.scale(10) == 100.0)
        XCTAssertTrue(c.scale(1) == 10.0)
        XCTAssertTrue(c.scale(5) == 50.0)
        XCTAssertTrue(c.scale(5.5) == 55.0)
        XCTAssertEqualWithAccuracy(c.scale(6.6), 66.0, accuracy: 0.00001)
    }
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
