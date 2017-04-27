//: Playground - noun: a place where people can play

import Hwamei

let a = Arc().innerRadius(50).outerRadius(90).cornerRadius(12)
    .startAngle(.pi)
    .endAngle( 1.5 * .pi)

let p = a.arc().path
func testPath(p: CGPath, view: UIView) {
    view.select(NSPredicate()).data([0, 1, 2, 3, 4, 5, 6, 7])
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

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
testPath(p: p, view: view)
view
