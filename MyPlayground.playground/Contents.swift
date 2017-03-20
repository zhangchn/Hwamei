//: Playground - noun: a place where people can play

import UIKit
import d3s

var str = "Hello, playground"

let view = UIView.init(frame: CGRect(x: 0, y:0 , width: 50, height: 100))

//view.layer.style = ["cornerRadius": 3.0, "backgroundColor" : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor, "style": ["borderWidth" : 1.0, "borderColor": #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor]]


func rebind(view: UIView, data: [Any]) {
    let colors : [CGColor] = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)].map { $0.cgColor }
    
    let updateSet = view.selectAll(NSPredicate(format: "cls = 3"))
        .data(value: data)
    let enterSet = updateSet.enter()
        .append(name: .layer)
        .property("cls", value: 3)
        .property("bounds", value: CGRect(x: 0, y: 0, width: 30, height: 30))
        .property("position", value: { (_, _, idx, _) -> Any? in
            return CGPoint(x: 15 + 8 * idx, y: 19 + 20 * idx)
        })
        .style(name: "cornerRadius", value: NSNumber(value: 5.0))
        .style(name: "backgroundColor", value: {(node: CALayer, datum: Any?, idx: Int, group: [CALayer]) -> AnyObject in
            return colors[idx % colors.count]
        })
        .style(name: "borderWidth", value: NSNumber(value: 2.0))
        .style(name: "borderColor", value: UIColor(white: 1.0, alpha: 0.5).cgColor)
    
    view
    enterSet.style(name: "center")
    
    view.layer.sublayers![0].value(forKey: "__data__")
    view.layer.sublayers![2].value(forKey: "__data__")
    
    let p1 = NSPredicate(format: "cls = 4")
    enterSet.selectAll(p1).data(value: { (node, datum, idx, group) -> [Any?] in
        return [datum]
    }).enter().append(name: .text).property("cls", value: 4).each { (layer, datum, idx, group) in
        if let t = layer as? CATextLayer {
            t.frame = t.superlayer!.bounds
            t.string = "\(datum!)"
            t.foregroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            t.fontSize = 10
            t.alignmentMode = kCAAlignmentCenter
        }
    }
}
view
rebind(view: view, data: [2, 3, 5])
view

rebind(view: view, data: [2, 3, 5, 7, 9])
view

