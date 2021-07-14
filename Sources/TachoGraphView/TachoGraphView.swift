//
//  TachoGraphView.swift
//
//
//  Created by Przemysław Bobak on 24/10/2019.
//

import UIKit

open class TachoGraphView: UIView {

    public var image: UIImage? {
        didSet {
            backgroundView.image = image
        }
    }
    public var secondaryImage: UIImage? {
        didSet {
            secondaryImageView.image = secondaryImage
        }
    }
    public var idleColor: UIColor = UIColor.darkGray
    public var segments: [TachoSegment] = [TachoSegment.empty] {
        willSet {
            segmentViews.forEach { $0.removeFromSuperview() }
        }
        didSet {
            updateSegmentViews()
        }
    }
    public var clockwise: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    public var completed: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    public var imageScale: CGFloat = 0.87 {
        didSet {
            setNeedsLayout()
        }
    }
    public var secondaryImageScale: CGFloat = 0.27 {
        didSet {
            setNeedsLayout()
        }
    }
    public var segmentsTotalLength: CGFloat {
        return segments.reduce(0, { (value, segment) -> CGFloat in
            return value + CGFloat(segment.length)
        })
    }
    public var resizeSubviewsToScale: Bool = true

    public private(set) var segmentViews: [SegmentView] = []
    public private(set) var backgroundView: UIImageView!
    public private(set) var secondaryImageView: UIImageView!
    public private(set) var indicatorView: IndicatorView!

    private var completedLength: CGFloat {
        return completed * segmentsTotalLength
    }
    private var rotationAngle: CGFloat {
        return -1 * ((CGFloat.pi * 2) * completed)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        // Background Image View
        backgroundView = UIImageView(frame: bounds)
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.layer.anchorPoint = center
        backgroundView.frame = bounds

        addSubview(backgroundView)

        // Secondary Image View
        secondaryImageView = UIImageView(frame: bounds)
        secondaryImageView.contentMode = .scaleAspectFill
        secondaryImageView.layer.anchorPoint = center
        secondaryImageView.frame = bounds

        addSubview(secondaryImageView)

        // Indicator View
        indicatorView = IndicatorView()
        indicatorView.frame = bounds

        addSubview(indicatorView)

        updateSegmentViews()
    }

    private func updateSegmentViews() {
        segmentViews = segments.map({ (segment) -> SegmentView in
            let view = SegmentView(with: segment)
            view.frame = bounds
            view.bounds = bounds
            view.center = center
            view.totalLength = segmentsTotalLength
            view.isUserInteractionEnabled = false

            addSubview(view)

            return view
        })

        setNeedsLayout()
        setNeedsDisplay()
    }

    private func tintColor(for segment: TachoSegment) -> UIColor {
        let isCompleted = segment.start <  Float(completedLength)

        return isCompleted ? UIColor(cgColor: segment.color) : idleColor
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let imgOneOffset: CGFloat = (1 - imageScale) * bounds.width
        let imgOneFrame: CGRect = bounds.insetBy(dx: imgOneOffset, dy: imgOneOffset)
        let imgOneBounds: CGRect = CGRect(x: 0, y: 0, width: imgOneFrame.width, height: imgOneFrame.height)

        subviews.forEach { (view) in
            view.frame = resizeSubviewsToScale ? imgOneFrame : bounds
            view.setNeedsLayout()
        }

        // Background View
        let imgOneMask = CAShapeLayer()
        imgOneMask.path = UIBezierPath(ovalIn: imgOneBounds).cgPath
        backgroundView.frame = imgOneFrame
        backgroundView.layer.mask = imgOneMask
        backgroundView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // Secondary Image View
        let imgTwoWidth: CGFloat = secondaryImageScale * bounds.width
        let imgTwoOffset: CGFloat = bounds.width - imgTwoWidth
        let imgTwoFrame: CGRect = CGRect(x: imgTwoOffset, y: imgTwoOffset, width: imgTwoWidth, height: imgTwoWidth)
        let imgTwoBounds: CGRect = CGRect(x: 0, y: 0, width: imgTwoFrame.width, height: imgTwoFrame.height)
        let imgTwoMask = CAShapeLayer()
        imgTwoMask.path = UIBezierPath(ovalIn: imgTwoBounds).cgPath
        secondaryImageView.layer.mask = imgTwoMask
        secondaryImageView.frame = imgTwoFrame
        secondaryImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        bringSubviewToFront(secondaryImageView)

        segmentViews.forEach { $0.frame = bounds }

        indicatorView.frame = bounds
        indicatorView.setNeedsDisplay()

        updateSegments()
    }

    open func updateSegments() {
        segmentViews.forEach { view in
            view.frame = bounds
            view.bounds = bounds
            view.clockwise = clockwise
            view.rotationAngle = 0
            view.tintColor = tintColor(for: view.segment)
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)

        segmentViews.forEach { (view) in
            view.transform = CGAffineTransform.identity.rotated(by: rotationAngle)
        }
    }
}

