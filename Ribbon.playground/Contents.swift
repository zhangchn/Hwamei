//: Playground - noun: a place where people can play

import UIKit
import d3s

let width: CGFloat = 1024
let height: CGFloat = 1024
let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
let outerRadius: CGFloat = width * 0.5 - 40
let innerRadius = outerRadius - 30

let chords = Chord()
chords.padAngle = .pi / 36
chords.sortSubgroups = (>)

let arc = Arc()
arc.innerRadius = innerRadius
arc.outerRadius = outerRadius

let ribbon = Ribbon(radius: Double(innerRadius))


var matrix : [[Double]] = [
    [11975,  5871, 8916, 2868],
    [ 1951, 10048, 2060, 6171],
    [ 8010, 16145, 8090, 8045],
    [ 1013,   990,  940, 6907]
]



let (subgroupPairs, chordsGroups) = chords.chord(matrix)

let g = view.select(view.layer).append(name: .layer)
    .property("position", value: CGPoint(x: width / 2 , y: height / 2))
    .datum(subgroupPairs)

let group = g.append(name: .layer)
    .property("cls", value: "groups")
    .selectAll(NSPredicate(format: "className == 'CALayer'"))
    .data(value: { _, _, _, _ in return chordsGroups})
    .enter().append(name: .layer)

_ = group.append(name: CreatorType.shape)
    .style(name: "strokeColor", value: UIColor.blue.cgColor)
    .property("path", { (layer, data, idx, layerGroup ) -> Any? in
        let data = data as! ChordGroup
        return arc.arc(chordGroup: data).path
})

g.append(name: .layer)
.property("cls", value: "ribbons")
    .selectAll(NSPredicate(format:"className = 'CAShapeLayer'"))
    .data(value: { (_, d, _, _) in
        let d = d as! [Chord.SubgroupPair]
        return d
    })
    .enter().append(name: .shape)
    .property("path") { (_ , d, _, _) in
        let d = d as! Chord.SubgroupPair
        return ribbon.ribbon(d).path
}.style(name: "fillColor", value: UIColor.red.withAlphaComponent(0.2).cgColor)
.style(name: "strokeColor", value: UIColor.red.withAlphaComponent(0.8).cgColor)

view

