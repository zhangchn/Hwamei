//: Playground - noun: a place where people can play

import UIKit
import d3s

var str = "Hello, playground"

let view = UIView.init(frame: CGRect(x: 0, y:0 , width: 50, height: 100))

//view.layer.style = ["cornerRadius": 3.0, "backgroundColor" : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor, "style": ["borderWidth" : 1.0, "borderColor": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]]

let colors : [CGColor] = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)].map { $0.cgColor }

let updateSet = view.selectAll(NSPredicate(format: "cls = 3"))
    .data(value: [1, 2, 5])
let enterSet = updateSet.enter()
    .append { (node, datum, idx, group) -> CALayer? in
        let layer =  CALayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        return layer
    }
    .property("cls", value: 3)
    .style(name: "cornerRadius", value: NSNumber(value: 5.0))
    .style(name: "backgroundColor", value: {(node: CALayer, datum: Any?, idx: Int, group: [CALayer]) -> AnyObject in
        return colors[idx]
    })
    .style(name: "borderWidth", value: NSNumber(value: 2.0))
    .style(name: "borderColor", value: UIColor.init(white: 1.0, alpha: 0.5).cgColor)
    .position { (node, datum, idx, _) -> CGPoint? in
        return CGPoint(x:15.0 + 8.0 * CGFloat(idx), y: 10 + 25.0 * 1.2 * CGFloat(idx))
    }

view
enterSet.style(name: "center")

view.layer.sublayers![0].value(forKey: "__data__")
view.layer.sublayers![2].value(forKey: "__data__")



