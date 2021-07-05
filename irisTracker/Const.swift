//
//  Const.swift
//  irisTracker
//
//  Created by Tommy on 2021/07/05.
//

import Foundation

class Eye {
    var leftEdge: MPLandmark!
    var rightEdge: MPLandmark!
    var topEdge: MPLandmark!
    var bottomEdge: MPLandmark!
    
    init(left: MPLandmark, right: MPLandmark, top: MPLandmark, bottom: MPLandmark) {
        self.leftEdge = left
        self.rightEdge = right
        self.topEdge = top
        self.bottomEdge = bottom
    }
    
    func calculateRelativePosition(iris: MPLandmark) -> Coordinate {
        let centerX = (self.rightEdge.x + self.leftEdge.x) / 2.0
        let multiplierX = 1.0 / (self.rightEdge.x - centerX)
        let x = (iris.x - centerX) * multiplierX
        let centerY = (self.topEdge.y + self.bottomEdge.y) / 2.0
        let multiplierY = 1.0 / (self.topEdge.y - centerY)
        let y = (iris.y - centerY) * multiplierY
        return Coordinate(x: x, y: y)
    }
}

class Coordinate {
    var x: Float!
    var y: Float!
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}
