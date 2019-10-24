//
//  Segment.swift
//
//
//  Created by Przemysław Bobak on 24/10/2019.
//

import UIKit

public struct TachoSegment {
    let start: Float
    let length: Float
    let color: CGColor

    public init(start: Float, length: Float, color: CGColor) {
        self.start = start
        self.length = length
        self.color = color
    }

    static var empty: TachoSegment {
        let white = CGColor(
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            components: [1.0, 1.0, 1.0, 1.0]
        )

        return TachoSegment(start: 0, length: 1, color: white!)
    }
}
