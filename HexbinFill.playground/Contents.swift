//: Playground - noun: a place where people can play

import Hwamei

func renderHexagon(points: [CGPoint], in view: UIView) {
    let hexbin = HexBin.init(radius: 24)
    let bins = hexbin.hexbin(points)
    
    view.select(view.layer)
        .selectAll(NSPredicate(format: "cls = 'hexagon'"))
        .data(bins)
        .enter()
        .append(name: .shape)
        .property("cls", value: "hexagon")
        .property("fillColor") {(node, datum, idx, group) -> AnyObject?  in
            let p = datum as! HexBin.Bin
            let c = p.center
            let r = sqrt((c.x - 512) * (c.x - 512) + (c.y - 512) * (c.y - 512))
            //let hue: CGFloat = 0.5, saturation: CGFloat = r / 512.0
            return UIColor(hue: c.x / 512, saturation: 0.8, brightness: 1.0 - r / 512, alpha: 1.0).cgColor
        }.property("strokeColor", value: UIColor(white: 0.7, alpha: 1.0).cgColor)
        .style(name: "transform") { (node, datum, idx, group) -> AnyObject? in
            let p = datum as! HexBin.Bin
            return CATransform3DMakeTranslation(p.center.x, p.center.y, 0) as AnyObject?
        }.property("path", value: hexbin.hexagon())
}
let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))
let points = (0..<600).map { _ in CGPoint(x: Int(arc4random() % 1024), y: Int(arc4random() % 1024)) }

renderHexagon(points: points, in: view2)

view2
