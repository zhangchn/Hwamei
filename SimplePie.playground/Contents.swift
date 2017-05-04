//: Playground - noun: a place where people can play

import UIKit
import Hwamei

let view3 = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))

let arc = Arc([.outerRadius: { _ in 80 }])
let pie = Pie<CGFloat>()
view3.select(NSPredicate(format: "cls=pie")).data([0])
    .enter()
    .append(name: .layer)
    .property("cls", value: "pie")
    .selectAll(NSPredicate(format: "cls=slice")).data(pie.pie([2, 2.433, 3.3145, 4]))
    .enter()
    .append(name: .shape)
    .property("frame", value: CGRect(x: 160, y: 160, width: 0, height: 0))
    .property("cls", value: "slice")
    .property("strokeColor", value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
    .property("lineWidth", value: 2)
    .property("fillColor", { (_, datum, idx, _) -> Any? in
        if let tuple = datum as? Pie<CGFloat>.SliceTuple {
            let color = UIColor(hue: tuple.3[.startAngle]! / (2 * CGFloat.pi), saturation: 1, brightness: 1, alpha: 1).cgColor
            return color
        }
        return nil
    })
    .property("path") { (node, datum, idx, _) -> CGPath? in
        if let tuple = datum as? Pie<CGFloat>.SliceTuple {
            let slice = arc.arc(tuple.3)
            return slice.path
        }
        return nil
}

view3
