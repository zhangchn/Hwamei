//
//  Chord.swift
//  d3s
//
//  Created by ZhangChen on 07/04/2017.
//  Copyright © 2017 Zhang Chen. All rights reserved.
//

import Foundation

struct ChordSubgroup {
    var index: Int
    var subindex: Int
    var startAngle: Double
    var endAngle: Double
    var radius: Double?
    var value: Double
}

struct ChordGroup {
    var index: Int
    var startAngle: Double
    var endAngle: Double
    var value: Double
}

class Chord {
    var padAngle: Double = 0
    func padAngle(_ a: Double) -> Self {
        self.padAngle = a
        return self
    }
    
    var sortGroups : ((Double, Double) -> Bool)?
    var sortSubgroups : ((Double, Double) -> Bool)?
    var sortChords: ((Double, Double) -> Bool)?
    
    typealias SubgroupPair = (source: ChordSubgroup, target: ChordSubgroup)
    func chord(_ matrix: [[Double]]) -> ([SubgroupPair], [ChordGroup]) {
        let placeholder0 = ChordGroup(index: -1, startAngle: 0, endAngle: 0, value: 0)
        let placeholder1 = ChordSubgroup(index: -1, subindex: -1, startAngle: 0, endAngle: 0, radius: nil, value: 0)
        let n = matrix.count
        var groupSums: [Double] = []
        var groupIndex = Array(0..<n)
        var subgroupIndex: [[Int]] = []
        var chords: [SubgroupPair] = []
        var groups: [ChordGroup] = [ChordGroup].init(repeating: placeholder0, count: n)
        var subgroups: [ChordSubgroup] = [ChordSubgroup].init(repeating: placeholder1, count: n * n)
        
        // compute sum by group
        var k: Double = 0
        for i in 0..<n {
            var x: Double = 0
            for j in 0..<n {
                x += matrix[i][j]
            }
            groupSums.append(x)
            subgroupIndex.append(Array(0..<n))
            k += x
        }
        // sort groups
        if let sortGroups = sortGroups {
            groupIndex.sort(by: { (a, b) -> Bool in
                sortGroups(groupSums[a], groupSums[b])
            })
        }
        // sort subgroups
        if let sortSubgroups = sortSubgroups {
            for i in 0..<subgroupIndex.count {
                subgroupIndex[i].sort(by: { (a, b) -> Bool in
                    return sortSubgroups(matrix[i][a], matrix[i][b])
                })
            }
        }
        let q = max(0, .tau - padAngle * Double(n)) / k
        let dx = q == 0 ? .tau / Double(n) : padAngle
        
        var x: Double = 0
        for di in groupIndex {
            let x0 = x
            for dj in subgroupIndex[di] {
                let v = matrix[di][dj]
                let a0 = x
                x += v * q
                let a1 = x
                subgroups[dj * n + di] = ChordSubgroup(index: di, subindex: dj, startAngle: a0, endAngle: a1, radius: nil, value: v)
            }
            groups[di] = ChordGroup(index: di, startAngle: x0, endAngle: x, value: groupSums[di])
            x += dx
        }
        
        // Generate chords for non-empty subgroup-subgroup links
        for i in 0..<n {
            for j in 0..<n {
                let source = subgroups[j * n + i]
                let target = subgroups[i * n + i]
                if source.value != 0 || target.value != 0 {
                    chords.append(source.value < target.value ?
                        (source: target, target: source) :
                        (source: source, target: target)
                    )
                }
            }
        }
        if let sortChords = sortChords {
            chords.sort() { (a, b) -> Bool in
                return sortChords(a.source.value + a.target.value,
                                  b.source.value + b.target.value)
            }
        }
        return (chords, groups)
    }
    
}
