//
//  SuperButtonView.swift
//  superbutton
//
//  Created by Kraig Wastlund on 05/28/18
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import UIKit
import AVFoundation

var _nodeGrowScale: CGFloat = 2.0

@available(iOS 8.2, *)
public class SuperButtonView: UIView {
    
    // width and height static values are used to layout buttons
    var width: CGFloat = 360
    var height: CGFloat = 300
    
    private let maxNumberOfNodes = 7
    
    var nodes: [SuperNodeView]!
    var superButton: SuperButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        if frame.width > 0 {
            self.width = frame.width
        }
        if frame.height > 0 {
            self.height = frame.height
        }
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
        
        let screenWidth = UIScreen.main.bounds.size.width
        let nodeWidth = (screenWidth / CGFloat(nodes.count)) - 10
        let nodeHeight = nodeWidth * 2
        
        // super node views
        let points = getNodeCenterPoints(numberOfNodes: self.nodes.count, nodeWidth: nodeWidth)
        assert(points.count == self.nodes.count)
        
        
        for (i, node) in self.nodes.enumerated() {
            let superCenter = CGPoint(x: width / 2, y: height / 2)
            let point = points[i]
            
            // x and y
            self.addConstraint(NSLayoutConstraint(item: node, attribute: .centerX, relatedBy: .equal, toItem: self.superButton, attribute: .centerX, multiplier: 1.0, constant: -(superCenter.x - point.x)))
            self.addConstraint(NSLayoutConstraint(item: node, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: point.y))
            
            // width/height
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[node(\(nodeWidth))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["node": node]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[node(\(nodeHeight))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["node": node]))
        }
    }
    
    private func getNodeCenterPoints(numberOfNodes: Int, nodeWidth: CGFloat) -> [CGPoint] {
        
        assert(numberOfNodes <= maxNumberOfNodes)
        
        var points = [CGPoint]()
        for i in 0..<numberOfNodes {
            points.append(point(buttonIndex: i, nodeWidth: nodeWidth))
        }
        
        return points
    }
    
    private func point(buttonIndex: Int, nodeWidth: CGFloat) -> CGPoint {
        
        // (all values are center)
        let xPadding: CGFloat = nodeWidth
        let startAndEndingYValue: CGFloat = 100
        let middleYValue: CGFloat = 60
        let startXValue: CGFloat = xPadding
        let endingXValue: CGFloat = width - xPadding
        
        if buttonIndex == 0 {
            return CGPoint(x: startXValue, y: startAndEndingYValue)
        } else if buttonIndex == nodes.count - 1 {
            return CGPoint(x: endingXValue, y: startAndEndingYValue)
        }
        
        let differenceBetweenStartAndEndX = endingXValue - startXValue
        let xSeparation = differenceBetweenStartAndEndX / CGFloat(nodes.count - 1)
        
        let x = startXValue + (xSeparation * CGFloat(buttonIndex))
        var percentage: CGFloat = (x - startXValue) / differenceBetweenStartAndEndX
        
        if percentage == 0.5 {
            return CGPoint(x: x, y: middleYValue)
        }
        
        var y: CGFloat!
        if percentage < 0.5 {
            percentage *= 2.0
            y = startAndEndingYValue - (percentage * (startAndEndingYValue - middleYValue))
        } else {
            let amountOverFiftyPercent = percentage - 0.5
            percentage = 0.5 - amountOverFiftyPercent
            percentage *= 2.0
            y = startAndEndingYValue - (percentage * (startAndEndingYValue - middleYValue))
        }
        
        return CGPoint(x: x, y: y)
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
