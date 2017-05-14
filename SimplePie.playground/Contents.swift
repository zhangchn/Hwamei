//: Playground - noun: a place where people can play

import UIKit
import Hwamei

let view3 = UIView.init(frame: CGRect(x: 0, y:0 , width: 320, height: 320))

let arc = Arc()
arc.outerRadius = 80
arc.cornerRadius = 5
arc.innerRadius = 20
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

// The following chart is derived from https://bl.ocks.org/mbostock/raw/99f0a6533f7c949cf8b8/
func testArcs<T: Comparable>(template: Arc, arcs: [Pie<T>.SliceTuple], view: UIView) {
    let center = CGPoint(x: view.bounds.maxX / 2, y: view.bounds.maxY / 2)
    let colors = [#colorLiteral(red: 0.1215686275, green: 0.4666666667, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 1, green: 0.4980392157, blue: 0.05490196078, alpha: 1), #colorLiteral(red: 0.1725490196, green: 0.6274509804, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.8392156863, green: 0.1529411765, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.5803921569, green: 0.4039215686, blue: 0.7411764706, alpha: 1), #colorLiteral(red: 0.5490196078, green: 0.337254902, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.8901960784, green: 0.4666666667, blue: 0.7607843137, alpha: 1), #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1), #colorLiteral(red: 0.737254902, green: 0.7411764706, blue: 0.1333333333, alpha: 1), #colorLiteral(red: 0.09019607843, green: 0.7450980392, blue: 0.8117647059, alpha: 1)]
    view.select(NSPredicate()).data(arcs)
        .enter().append(name: .shape)
        .property("frame", value: NSValue(cgRect: CGRect(origin: center, size: .zero)))
        .style(name: "alpha", value: NSNumber(value: 0.5))
        .property("strokeColor", value: UIColor.black.cgColor)
        .property("fillColor") { _, _, idx, _ in
            colors[idx % colors.count].cgColor
        }
        .property("path") { _, datum, idx, _ -> AnyObject? in
            if let datum = datum as? Pie<T>.SliceTuple {
                return template.arc(datum).path
            }
            return nil
    }
}
let arcTemplate = Arc()
arcTemplate.outerRadius(180).innerRadius(120).cornerRadius(10)
let pie2 = Pie<CGFloat>()

let arcs = pie2.padAngle(0.03).pie([1, 1, 2, 3, 5, 8, 13])

arcs.count

let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
testArcs(template: arcTemplate, arcs: arcs, view: view2)
view2
