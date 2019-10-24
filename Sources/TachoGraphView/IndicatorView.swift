//
//  IndicatorView.swift
//
//
//  Created by Przemysław Bobak on 24/10/2019.
//

import UIKit


open class IndicatorView: UIView {

    public var fillColor: UIColor = UIColor.white
    private var triangleLayer: CAShapeLayer = CAShapeLayer()

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.clear
    }

    private func calculateFrame(_ rect: CGRect) -> CGRect {
        // Values based on original width of 200
        let midFrame: CGFloat = rect.midX
        let topFrame: CGFloat = 0.075 * rect.height
        let height: CGFloat = 0.035 * rect.height
        let width: CGFloat = 0.05 * rect.width
        let posX: CGFloat = (midFrame - width / 2)

        return CGRect(x: posX, y: topFrame, width: width, height: height)
    }

    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()

        let frame: CGRect = calculateFrame(rect)
        let width: CGFloat = frame.width
        let height: CGFloat = frame.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: (width/2), y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.close()

        fillColor.setFill()

        context.translateBy(x: frame.midX - (width / 2), y: frame.minY - (height / 2))
        context.addPath(path.cgPath)
        context.drawPath(using: .fill)
        context.restoreGState()
    }
}
