//
//  SuperButtonView.swift
//  superbutton
//
//  Created by Kraig Wastlund on 05/28/18
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

// This view is designed to go edge of screen to edge of screen

import UIKit
import AVFoundation

var _nodeGrowScale: CGFloat = 2.0

@available(iOS 8.2, *)
public class SuperButtonView: UIView {
    
    var path: UIBezierPath!
    
    let _desiredMinSideMargin: CGFloat = 40
    
    let _xPadding: CGFloat = 10
    var _nodeWidth: CGFloat {
        get {
            let screenWidth = UIScreen.main.bounds.width
            let divider = (screenWidth - _desiredMinSideMargin * 2) / CGFloat(nodes.count) - _xPadding
            return min(divider, 60)
        }
    }
    // width and height static values are used to layout buttons
    var width: CGFloat {
        get {
            return CGFloat(self.nodes.count) * (_xPadding + _nodeWidth)
        }
    }
    var height: CGFloat = 300
    
    private let maxNumberOfNodes = 7
    
    private var nodes: [SuperNodeView]! {
        didSet {
            destroyViews()
            setupViews()
        }
    }
    var superButton: SuperButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience public init(nodes: [SuperNodeView], mainButtonColor: UIColor) {
        self.init()
        self.nodes = nodes
        self.superButton = SuperButton(color: mainButtonColor)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func swapNodes(nodes: [SuperNodeView]) {
        self.nodes = nodes
    }
    
    func destroyViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupViews() {
        self.addSubview(self.superButton)
        for node in self.nodes {
            self.addSubview(node)
        }
        
        self.setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        // super button
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[super(80)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["super": self.superButton]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[super(80)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["super": self.superButton]))
        self.addConstraint(NSLayoutConstraint(item: self.superButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: self.superButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -40.0))
        
        let nodeWidth = _nodeWidth
        let nodeHeight = nodeWidth * 2
        
        // super node views
        let points = getPoints()
        assert(points.count == self.nodes.count)
        
        let superCenter = CGPoint(x: width / 2, y: height / 2)
        for (i, node) in self.nodes.enumerated() {
            let point = points[i]
            
            // x and y
            self.addConstraint(NSLayoutConstraint(item: node, attribute: .centerX, relatedBy: .equal, toItem: self.superButton, attribute: .centerX, multiplier: 1.0, constant: -(superCenter.x - point.x)))
            self.addConstraint(NSLayoutConstraint(item: node, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: point.y))
            
            // width/height
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[node(\(nodeWidth))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["node": node]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[node(\(nodeHeight))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["node": node]))
        }
    }
    
    func showNodes() {
        assert(nodes.count > 0)
        UIView.animate(withDuration: 0.25, animations: {
            for node in self.nodes {
                node.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        })
    }
    
    func hideNodes() {
        UIView.animate(withDuration: 0.25, animations: {
            for node in self.nodes where !node.superImageNode.isExploding {
                node.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }
        })
    }
    
    func shrivelAllNodes() {
        for node in self.nodes {
            node.shrivel()
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if self.superButton.bounds.contains(touch.location(in: self.superButton)) {
                self.superButton.growNodesAndRotate()
                self.showNodes()
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.superButton.isGrown() {
            if let touch = touches.first {
                for node in self.nodes {
                    if node.isTouched(point: touch.location(in: node)) {
                        node.grow(_nodeGrowScale)
                    } else {
                        node.shrivel()
                    }
                }
            }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.superButton.isGrown() {
            if let touch = touches.first {
                for node in self.nodes {
                    if node.isTouched(point: touch.location(in: node)) {
                        node.superImageNode.explode(completion: {
                            node.superImageNode.completion()
                            self.hideNodes()
                        })
                    }
                }
            }
        }
        
        self.superButton.shrivel()
        self.hideNodes()
        self.shrivelAllNodes()
    }
}

// bezier path
@available(iOS 8.2, *)
extension SuperButtonView {
    
    private func getPoints() -> [CGPoint] {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let nodeCenterToCenterDim: CGFloat = _nodeWidth + _xPadding
        let centerX: CGFloat = width / 2
        let nodeCountMultiplier = CGFloat(nodes.count / 2)
        let distanceFromCenterToOutside: CGFloat = nodeCountMultiplier * nodeCenterToCenterDim
        
        assert(screenWidth >= distanceFromCenterToOutside * 2 + _desiredMinSideMargin * 2, "******max node count supported is 7******")
        
        let p0 = CGPoint(x: centerX - distanceFromCenterToOutside, y: 120)
        let p1 = CGPoint(x: centerX, y: 60)
        let p2 = CGPoint(x: centerX + distanceFromCenterToOutside, y: 120)
        
        if nodes.count == 1 {
            return [p1]
        }
        
        var percents = [CGFloat]()
        for p in 0..<nodes.count {
            let percent = Float(p)/Float(nodes.count - 1)
            percents.append(CGFloat(percent))
        }
        
        var points = [CGPoint]()
        for p in percents {
            let newY = getPointAtPercent(t: p, start: p0.y , c1: p1.y, end: p2.y)
            let newX = getPointAtPercent(t: p, start: p0.x , c1: p1.x, end: p2.x)
            points.append(CGPoint(x: newX, y: newY))
        }
        
        return points
    }
    
    func getPointAtPercent(t: CGFloat, start: CGFloat, c1: CGFloat, end: CGFloat ) -> CGFloat {
        let t_: CGFloat = (1.0 - t)
        let tt_: CGFloat = t_ * t_
        let tt: CGFloat = t * t
        
        return start * tt_
            + 2.0 * c1 * t_ * t
            + end * tt
    }
}
