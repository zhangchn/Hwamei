//: Playground - noun: a place where people can play

import UIKit
import Hwamei

let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 880, height: 240))

func drawGrid(in view: UIView) {
    let layer = view.layer
    let vertical = Int(layer.bounds.width / 20.0)
    let horizontal = Int(layer.bounds.height / 20.0)
    layer.backgroundColor = #colorLiteral(red: 0.915152967, green: 0.915152967, blue: 0.915152967, alpha: 1).cgColor
    
    let predv = NSPredicate(format: "cls = 'vert_line'")
    let predh = NSPredicate(format: "cls = 'hori_line'")
    let vLine = Path().move(to: .zero).line(to: CGPoint(x: 0, y: layer.bounds.height))
    view.selectAll(predv).data(Array(0..<vertical))
        .enter()
        .append(name: .shape)
        .property("cls", value: "vert_line")
        .property("path", value: vLine.path)
        .property("lineWidth") { _, _, idx, _ in
            return  CGFloat(idx % 2 == 0 ? 1.0 : 2.0)
        }
        .property("strokeColor", value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor)
        .property("position") { _, _, idx, _ in
            return CGPoint(x: 20.0 * (0.5 + CGFloat(idx)), y: 0)
    }
    
    let hLine = Path().move(to: .zero).line(to: CGPoint(x: layer.bounds.width, y: 0))
    view.selectAll(predh).data(Array(0..<horizontal))
        .enter()
        .append(name: .shape)
        .property("cls", value: "vert_line")
        .property("path", value: hLine.path)
        .property("lineWidth") { _, _, idx, _ in
            return  CGFloat(idx % 2 == 0 ? 1.0 : 2.0)
        }
        .property("strokeColor", value: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor)
        .property("position") { _, _, idx, _ in
            return CGPoint(x: 0, y: 20.0 * (0.5 + CGFloat(idx)))
    }
}

func drawCurve(in view: UIView, through points: [CGPoint], liner: Line) {
    let predPoint = NSPredicate(format: "cls = 'point'")
    let linePath = liner.line(points).path
    let pointPath = Path().arc(center: .zero, radius: 3.0, start: 0, end: CGFloat.pi * 2).path
    view.selectAll(predPoint).data(points)
        .enter().append(name: .shape)
        .property("strokeColor", value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        .property("fillColor", value: nil)
        .property("lineWidth", value: 0.5)
        .property("position") {_, datum, idx, _ in return datum }
        .property("path", value: pointPath)
    view.selectAll(nil).data([0]).enter().append(name: .shape)
        .property("strokeColor", value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor)
        .property("lineWidth", value: 1.0)
        .property("fillColor", value: nil)
        .property("path", value: linePath)

}

let points = [(4, 9), (8, 3), (11, 1), (13, 1),
              (16, 7), (22, 7), (26, 3), (31, 5),
              (34, 7), (37, 6), (40, 9)].map { CGPoint(x: $0.0 * 20 + 10, y: $0.1 * 20 + 10) }

let line = Line(Path())

drawGrid(in: view1)
drawCurve(in: view1, through: points, liner: line)
view1
let view2 = UIView(frame: CGRect(x: 0, y: 0, width: 880, height: 240))
let line2 = Line(Path())
line2.curve({ ctx in Basis(ctx) })
drawGrid(in: view2)
drawCurve(in: view2, through: points, liner: line2)
view2

let view3 = UIView(frame: CGRect(x: 0, y: 0, width: 880, height: 240))
let line3 = Line(Path())
line3.curve({ ctx in BasisClosed(ctx) })
drawGrid(in: view3)
drawCurve(in: view3, through: points, liner: line3)
view3

let view4 = UIView(frame: CGRect(x: 0, y: 0, width: 880, height: 240))
let line4 = Line(Path())
line4.curve({ ctx in LinearClosedCurve(ctx) })
drawGrid(in: view4)
drawCurve(in: view4, through: points, liner: line4)
view4
