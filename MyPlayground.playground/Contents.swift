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
view
rebind(view: view, data: [2, 3, 5])
view

rebind(view: view, data: [11, 12, 5, 7, 9])
view

let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))
let hexbin = HexBin.init(radius: 32)
let points = (0..<300).map { _ in CGPoint(x: Int(arc4random() % 320 + 512), y: Int(arc4random() % 320 + 512)) }
points.count

let bins = hexbin.hexbin(points)
bins[0].center
bins[0].points

view2.select(view2.layer)
    .selectAll(NSPredicate(format: "cls = 'hexagon'"))
    .data(value: bins)
    .enter()
    .append(name: .shape)
    .property("cls", value: "hexagon")
    .property("fillColor", value: UIColor.clear.cgColor)
    .property("strokeColor", value: UIColor.black.cgColor)
    .style(name: "transform") { (node, datum, idx, group) -> AnyObject? in
        let p = datum as! HexBin.Bin
        return CATransform3DMakeTranslation(p.center.x, p.center.y, 0) as AnyObject?
    }.property("path", value: hexbin.hexagon())
view2

