//: Playground - noun: a place where people can play

import UIKit
import Hwamei

var str = "Hello, playground"

let view = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))

view.layer.backgroundColor = UIColor.white.cgColor
//view.layer.style = ["cornerRadius": 3.0, "backgroundColor" : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor, "style": ["borderWidth" : 1.0, "borderColor": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]]


func rebind(view: UIView, data: [Any]) {
    let colors : [CGColor] = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)].map { $0.cgColor }
    
    let updateSet = view.selectAll(NSPredicate(format: "cls = 3"))
        .data(data)
    
    let enterSet = updateSet.enter()
        .append(name: .layer)
        .property("cls", value: 3)
        .property("bounds", value: CGRect(x: 0, y: 0, width: 30, height: 30))
        .style(name: "cornerRadius", value: NSNumber(value: 5.0))
        .style(name: "borderWidth", value: NSNumber(value: 2.0))
        .style(name: "borderColor", value: UIColor(white: 1.0, alpha: 0.5).cgColor)

    let textUpdateSet = enterSet.selectAll(NSPredicate(format: "cls = 4")).data(value: { (node, datum, idx, group) -> [Any] in
            return [datum!]
        })
    let textEnterSet = textUpdateSet.enter().append(name: .text)
        .property("cls", value: 4)
        .each { (layer, datum, idx, group) in
            if let t = layer as? CATextLayer {
                t.frame = t.superlayer!.bounds
                t.foregroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                t.fontSize = 13
                t.alignmentMode = kCAAlignmentCenter
            }
        }
    
    updateSet.exit().remove()
    
//    updateSet.each { (layer, datum, idx, group) in
//        datum!
//        idx
//    }
    // XXX: Always merge update set with enter set
    updateSet.merge(enterSet)
        .property("position", { (_, datum, idx, _) -> Any? in
            datum!
            return CGPoint(x: 15 + 8 * idx, y: 19 + 30 * idx)
        })
        .style(name: "backgroundColor", value: {(node: CALayer, datum: Any?, idx: Int, group: [CALayer]) -> AnyObject in
            idx
            datum!
            return colors[idx % colors.count]
        })

    textEnterSet.merge(textUpdateSet).each { (layer, datum, idx, group) in
        if let t = layer as? CATextLayer {
            t.string = "\(datum!)"
            datum!
        }
    }
}
//view
//rebind(view: view, data: [2, 3, 5])
//view
//
//rebind(view: view, data: [11, 12, 5, 7, 9])
//view

//points.count


//testPath(p: p, view: view2)
//view2
//let c1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//let c2 = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//let c : CGColor? = interpolateGamma(a: c1.cgColor, b: c2.cgColor, gamma: 0.40)(0.5)
//let uc = UIColor.init(cgColor: c!)

//let b = [1, 3, 5, 7, 9]
//bisectRight()(b, 4, 0, 4)
//bisectLeft()(b, 1, 0, 4)
//let c = Continuous<Double, Double>.init(deinterpolate: Double.reverseInterpolate, reinterpolate: Double.interpolate)
//c.domain([0, 10]).scale(20)
//c.scale(300)
//
//let e = Power().domain([0,10.0]).exponent(3.3)
//e.scale(300.0)
//e.scale(20)
//e.invert(8)
//
//format(".02")(3)

//let s = Linear<Double, CGFloat>()
let s = Log<CGFloat>()
s.range([300, 10]).domain([1, 10])
s.scale(1000)

let a1 = Axis(orientation: AxisOrientation.left, scale: s)
//    .tickArguments(["count": 5, "specifier": ""])
    .tickValues([1, 10, 100, 1000])
let view3 = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))
view3.select(NSPredicate(format:"cls=graph")).data([[]])
    .enter()
    .append(name: .layer)
    .property("transform", value: CATransform3DMakeTranslation(30, 0 , 0))
    .call(a1.axis)

view3.layer.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor
view3
