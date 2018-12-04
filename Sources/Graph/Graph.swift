//
//  Graph.swift
//  CommandLineKit
//
//  Created by Jack Maloney on 12/1/18.
//

import Foundation

public protocol Vertex: Hashable {}

public protocol Edge: Hashable {
    associatedtype V: Vertex
    
    var vertices: [V] { get }
    var length: Int { get }
}

extension Edge {
    func connectsTo(_ vert: V) -> Bool {
        return vertices.contains(where: { $0 == vert })
    }
    
    func connectsTo(_ edge: Self) -> Bool {
        var set: Set<V> = Set()
        self.vertices.forEach({ set.insert($0) })
        edge.vertices.forEach({ set.insert($0) })
        return set.count != 4
    }
}

public typealias Graph<T> = Set<T> where T: Edge
public typealias Path<T> = Array<T> where T: Edge

extension Graph {
    typealias V = Element.V
    
    public var vertices: [V] {
        return self.verticesCounted().keys.map({ $0 })
    }
    
    func verticesCounted() -> [V: Int] {
        var rv: [V: Int] = [:]
        for edge in self {
            for vertex in edge.vertices {
                if rv.keys.contains(vertex) {
                    rv[vertex]! += 1
                } else {
                    rv[vertex] = 1
                }
            }
        }
        return rv
    }
    
    func edges(from vertexA: V, to vertexB: V) -> [Element] {
        return self.filter({ $0.connectsTo(vertexA) && $0.connectsTo(vertexB) })
    }
    
    public var edges: [Element] {
        return self.sorted(by: { $0.length < $1.length })
    }
    
    func asPath() -> Path<Element>? {
        var ends: [V] = []
        self.verticesCounted().forEach { (vert, count) in
            if count.odd() {
                ends.append(vert)
            }
        }
        
        // Either has 2 endpoints, or 0 if it is a perfect loop
        if ends.count == 2 || ends.count == 0 {
            var edges = self.edges
            var current: Element = edges.removeFirst()
            
            while true {
                if edges.count == 0 { return Path(self.edges) }
                
                // Check that each path connects to the next
                for (i, next) in edges.enumerated() {
                    if current.connectsTo(next) {
                        current = edges.remove(at: i)
                    }
                }
                
                // If it made it this far track does not connect
                return nil
            }
        } else {
            return nil
        }
    }
}

extension Path {
    var length: Int {
        return self.reduce(0, { return $0 + $1.length })
    }
}
