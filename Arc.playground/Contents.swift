//: Playground - noun: a place where people can play

import Hwamei

let arc1 = Arc().innerRadius(50)
    .outerRadius(90)
    .cornerRadius(12)
    .padAngle(0.5)
    .padRadius(50)
    .startAngle(.pi)
    .endAngle( 2.5 * .pi)

let p = arc1.arc().path
func testPath(p: CGPath, view: UIView) {
    let center = CGPoint(x: view.bounds.maxX / 2, y: view.bounds.maxY / 2)
    view.select(NSPredicate()).data([0, 1, 2, 3, 4, 5, 6, 7])
        .enter().append(name: .shape)
        .property("frame", value: NSValue(cgRect: CGRect(origin: center, size: .zero)))
        .style(name: "alpha", value: NSNumber(value: 0.5))
        .property("lineWidth", value: 1)
        .property("strokeColor", value: UIColor.red.cgColor)
        .property("fillColor") { _, _, idx, _ in
            let hue : CGFloat = 0.1 * CGFloat(idx)
            let sat : CGFloat = 0.8
            let bri : CGFloat = 0.4 + 0.1 * CGFloat(idx)
            
            return UIColor(hue: hue, saturation:sat, brightness: bri, alpha: 1.0).cgColor
        }
        .property("path") { _, _, idx, _ -> AnyObject? in
            return p
    }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
testPath(p: p, view: view)
view

