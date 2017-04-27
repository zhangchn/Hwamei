//
//  HwameiTests.swift
//  HwameiTests
//
//  Created by ZhangChen on 14/03/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import XCTest
import UIKit
import QuartzCore

@testable import Hwamei

class HwameiTests: XCTestCase {
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
    
    func testNestedSelector() {
        let layer1 = CALayer()
        let layer2 = CALayer()
        let layer3 = CALayer()
        layer1.setValue("fancy", forKeyPath: "cls")
        layer2.setValue("fancy", forKeyPath: "cls")
        layer3.setValue("fancy", forKeyPath: "cls")
        
        view?.layer.addSublayer(layer1)
        layer1.addSublayer(layer2)
        layer1.addSublayer(layer3)
        
        let sel = view!.selectAll(NSPredicate(format: "cls = 'fancy'"))
        
        XCTAssertEqual(sel._groups[0].count, 3)
//        XCTAssertTrue(sel._groups.count == 3)
        
        layer1.removeFromSuperlayer()
    }
    
    func testDataAppend() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let predicate = NSPredicate(format: "%K = 's'", "age")
        let sel = view!.selectAll(predicate).data([[1, 2], [2, 3, 7]]).enter()
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
        let update = view!.selectAll(p).data([2, 3])
        let groups = update._groups
        XCTAssertTrue(groups[0][0] == layer1)
        
    }
    
    func testDataUpdateEnterMerge() {
        let predicate1 = NSPredicate(format: "cls = 3")
        
        let view1 = view!
        
        func f1 (_ d: [Int]) {
            let update = view1.selectAll(predicate1).data(d)
            let enter = update.enter()
                .append(name: .layer)
                .property("cls", value: 3)
            
            _ = update.exit().remove()
            
            _ = update.merge(enter).property("v") { (layer, datum, idx, group) -> Any? in
                return datum
            }
        }
        f1( [2, 3, 4])
        f1( [11, 2, 4, 5, 7])
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
    
    func testArc() {
        let a = Arc().innerRadius(50).outerRadius(90).cornerRadius(12)
            .startAngle(.pi)
            .endAngle( 1.5 * .pi)

        let p = a.arc()
//
//        let circular = view!.select(NSPredicate()).data(value: [0, 1 ,2])
//            .enter().append(name: .shape)
//            .property("bounds", value: NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80)))
//            .property("backgroundColor", value: UIColor.yellow.cgColor)
//            .property("strokeColor", value: UIColor.red.cgColor)
//            .property("fillColor", value: UIColor.red.cgColor)
//            .style(name: "transform", value: CATransform3DMakeTranslation(140, 140, 0) as AnyObject?)
//            .property("path", value: p)
        XCTAssert(true)
    }
    
    func testAxis() {
        let s = Linear<Double, CGFloat>(deinterpolate: Double.reverseInterpolate, reinterpolate: Double.interpolate)
        _ = s.range([0, 320]).domain([0, 1000])
        let a1 = Axis(orientation: AxisOrientation.left, scale: s)
        let view3 = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))
        _ = view3.select(NSPredicate(format:"cls=graph")).data([[]])
            .enter()
            .append(name: .layer)
            .call(a1.axis)

        XCTAssertTrue(true)
    }
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
