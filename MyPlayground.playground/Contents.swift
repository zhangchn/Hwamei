//: Playground - noun: a place where people can play

import UIKit
import d3s

var str = "Hello, playground"

let view = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))

view.layer.backgroundColor = UIColor.white.cgColor
//view.layer.style = ["cornerRadius": 3.0, "backgroundColor" : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor, "style": ["borderWidth" : 1.0, "borderColor": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]]


func rebind(view: UIView, data: [Any]) {
    let colors : [CGColor] = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)].map { $0.cgColor }
    
    let updateSet = view.selectAll(NSPredicate(format: "cls = 3"))
        .data(value: data)
    
    let enterSet = updateSet.enter()
        .append(name: .layer)
        .property("cls", value: 3)
        .property("bounds", value: CGRect(x: 0, y: 0, width: 30, height: 30))
        .style(name: "cornerRadius", value: NSNumber(value: 5.0))
        .style(name: "borderWidth", value: NSNumber(value: 2.0))
        .style(name: "borderColor", value: UIColor(white: 1.0, alpha: 0.5).cgColor)

    let textUpdateSet = enterSet.selectAll(NSPredicate(format: "cls = 4")).data(value: { (node, datum, idx, group) -> [Any?] in
        datum!
            return [datum]
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
        .property("position", value: { (_, datum, idx, _) -> Any? in
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

//rebind(view: view, data: [11, 12, 5, 7, 9])
//view

//points.count
func renderHexagon(points: [CGPoint], in view: UIView) {
    let hexbin = HexBin.init(radius: 24)
    let bins = hexbin.hexbin(points)

    view.select(view.layer)
        .selectAll(NSPredicate(format: "cls = 'hexagon'"))
        .data(value: bins)
        .enter()
        .append(name: .shape)
        .property("cls", value: "hexagon")
        .property("fillColor") {(node, datum, idx, group) -> AnyObject?  in
            let p = datum as! HexBin.Bin
            let c = p.center
            let r = sqrt((c.x - 512) * (c.x - 512) + (c.y - 512) * (c.y - 512))
            let hue: CGFloat = 0.5, saturation: CGFloat = r / 512.0
            return UIColor(hue: c.x / 512, saturation: 0.8, brightness: 1.0 - r / 512, alpha: 1.0).cgColor
        }.property("strokeColor", value: UIColor(white: 0.7, alpha: 1.0).cgColor)
        .style(name: "transform") { (node, datum, idx, group) -> AnyObject? in
            let p = datum as! HexBin.Bin
            return CATransform3DMakeTranslation(p.center.x, p.center.y, 0) as AnyObject?
        }.property("path", value: hexbin.hexagon())
}
let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))
//let points = (0..<600).map { _ in CGPoint(x: Int(arc4random() % 1024), y: Int(arc4random() % 1024)) }
//
//renderHexagon(points: points, in: view2)
//
//view2

let a = Arc().innerRadius(20).outerRadius(380).cornerRadius(15)

let p = a.arc().path
func testPath(p: CGPath, view: UIView) {
    view.select(NSPredicate()).data(value: [0, 1, 2, 3, 4, 5, 6, 7])
        .enter().append(name: .shape)
        .property("bounds", value: NSValue(cgRect: CGRect(x: 0, y: 0, width: 80, height: 80)))
        .style(name: "alpha", value: NSNumber(value: 0.5))
        .property("lineWidth", value: 1)
        .property("strokeColor", value: UIColor.red.cgColor)
        .property("fillColor") { _, _, idx, _ in
            let hue : CGFloat = 0.1 * CGFloat(idx)
            let sat : CGFloat = 0.8
            let bri : CGFloat = 0.4 + 0.1 * CGFloat(idx)
            
            return UIColor(hue: hue, saturation:sat, brightness: bri, alpha: 1.0).cgColor
        }
        .style(name: "transform") { _, _, idx, _ -> AnyObject? in
            return CATransform3DMakeTranslation(CGFloat(140), CGFloat(140 + 100), 0) as AnyObject?
        }
        .property("path") { _, _, idx, _ -> AnyObject? in
            return p
//            return a.startAngle(CGFloat(idx) * 0.25 * .pi).endAngle(CGFloat(idx + 1) * 0.25 * .pi).arc().path
    }
}

//testPath(p: p, view: view2)
//view2
//let c1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//let c2 = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
//let c : CGColor? = interpolateGamma(a: c1.cgColor, b: c2.cgColor, gamma: 0.40)(0.5)
//let uc = UIColor.init(cgColor: c!)

//let b = [1, 3, 5, 7, 9]
//bisectRight()(b, 4, 0, 4)
//bisectLeft()(b, 1, 0, 4)
let c = Continuous<Double, Double>.init(deinterpolate: Double.reverseInterpolate, reinterpolate: Double.interpolate)
c.domain([1, 10]).range([10, 100]).scale(20)
c.invert(200)

let e = Power().domain([1,10]).exponent(3)
e.scale(3)

