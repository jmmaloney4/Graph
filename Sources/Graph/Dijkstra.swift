//
//  Dijkstra.swift
//  Graph
//
//  Created by Jack Maloney on 12/3/18.
//

import Foundation
import SwiftPriorityQueue

fileprivate class DijkstraNode<T>: Comparable where T: Vertex {
    static func == (lhs: DijkstraNode, rhs: DijkstraNode) -> Bool {
        return lhs.vertex == rhs.vertex
    }
    
    static func < (lhs: DijkstraNode, rhs: DijkstraNode) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    var vertex: T
    var previous: DijkstraNode? // Previous city
    var distance: Int // From origin
    
    init(vertex: T, previous: DijkstraNode? = nil, distance: Int = Int.max) {
        self.vertex = vertex
        self.previous = previous
        self.distance = distance
    }
}

extension Graph {
    public func dijkstrasAlgorithm(from vertexA: V, to vertexB: V) -> Path<Element>? {
        var queue: PriorityQueue<DijkstraNode<V>> = PriorityQueue<DijkstraNode<V>>(ascending: true)
        queue.push(DijkstraNode(vertex: vertexA, previous: nil, distance: 0))
        for vertex in self.vertices where vertex != vertexA {
            queue.push(DijkstraNode(vertex: vertex))
        }
        var finalNode: DijkstraNode<V>?
        
        while true {
            let current = queue.pop()!
            if current.distance == Int.max {
                return nil // Shouldn't happen, means there is no path from A to B
            }
            
            var newQueue = PriorityQueue<DijkstraNode<V>>(ascending: true)
            while let node = queue.pop() {
                for track in self.edges(from: current.vertex, to: node.vertex) {
                    if node.distance > (current.distance + track.length) {
                        node.distance = current.distance + track.length
                        node.previous = current
                    }
                }
                
                newQueue.push(node)
            }
            
            queue = newQueue
            if current.vertex == vertexB {
                finalNode = current
                break
            }
        }
        
        var rv: [Element] = []
        var node = finalNode!
        while let next = node.previous {
            let edge = self.edges(from: node.vertex, to: next.vertex).first!
            rv.append(edge)
            
            node = next
        }
        
        return Path(rv)
    }
}
