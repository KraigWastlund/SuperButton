//
//  SuperNode.swift
//  superbutton
//
//  Created by Kraig Wastlund on 05/28/18
//  Copyright © 2017 Kraig Wastlund. All rights reserved.
//

import Foundation
import UIKit
import AVKit

@available(iOS 8.2, *)
public class SuperNodeView: UIView {
    
    public let superImageNode = SuperImageNode(frame: CGRect.zero)
    private let titleLabel = UILabel()
    var titleLabelYConstraint: NSLayoutConstraint!
    
    public var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    public var image: UIImage = UIImage() {
        didSet {
            self.superImageNode.image = image
        }
    }
    public var completion: ()->Void = {} {
        didSet {
            self.superImageNode.completion = completion
        }
    }
    
    var titleLabelFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .light)
    
    convenience public init(title: String, image: UIImage, tintColor: UIColor? = nil, completion: @escaping ()->Void) {
        self.init()
        initSet(title: title, image: image, tintColor: tintColor, completion: completion)
    }
    
    private func initSet(title: String, image: UIImage, tintColor: UIColor?, completion: @escaping ()->Void) {
        self.title = title
        if let c = tintColor {
            self.superImageNode.tintColor = c
            self.titleLabel.textColor = c
            self.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            self.image = image
        }
        self.completion = completion
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(superImageNode)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.frame = CGRect.zero
        titleLabel.textAlignment = .center
        titleLabel.font = titleLabelFont
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "Test Label"
        titleLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        addSubview(titleLabel)
        transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    private func setupContraints() {
        
        // title label
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.75, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[title(20)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["title": titleLabel]))
        titleLabelYConstraint = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: superImageNode, attribute: .top, multiplier: 1.0, constant: -20.0)
        addConstraint(titleLabelYConstraint)
        
        // node
        addConstraint(NSLayoutConstraint(item: superImageNode, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.75, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: superImageNode, attribute: .height, relatedBy: .equal, toItem: superImageNode, attribute: .width, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: superImageNode, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: superImageNode, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    func isTouched(point: CGPoint) -> Bool {
        if point.x > 4 && point.x < frame.width - 4 {
            if point.y > 0 && point.y < frame.height + 40 {
                return true
            }
        }
        
        return false
    }
    
    func grow(_ scale: CGFloat) {
        if !isGrown() {
            layer.zPosition = 2
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else { return }
                let originalImageNodeHeight = s.superImageNode.frame.height
                s.superImageNode.grow(scale)
                let currentImageNodeHeight = s.superImageNode.frame.height
                let difference = originalImageNodeHeight - currentImageNodeHeight
                s.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                s.titleLabelYConstraint.constant = difference / 2 - 6
            })
            AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
        }
    }
    
    func isGrown() -> Bool {
        return superImageNode.transform.d != 1.0
    }
    
    func shrivel() {
        self.layer.zPosition = 1
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let s = self else { return }
            s.superImageNode.shrivel()
            s.titleLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
    }
}


public class SuperImageNode: UIImageView {
    var completion: (() -> Void)!
    var isExploding: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        alpha = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func grow(_ scale: CGFloat) {
        assert(completion != nil)
        if !isGrown() {
            layer.zPosition = 2
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform(scaleX: scale, y: scale)
                s.alpha = 1.0
            })
            AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
        }
    }
    
    func isGrown() -> Bool {
        return transform.d != 1.0
    }
    
    fileprivate func shrivel() {
        if !isExploding {
            layer.zPosition = 1
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                s.alpha = 0.8
            })
        }
    }
    
    func explode(completion: (() -> Void)?) {
        isExploding = true
        AudioServicesPlaySystemSound(1521)
        UIView.animate(withDuration: 0.05, animations: { [weak self] in
            guard let s = self else { return }
            s.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        }) { [weak self] (complete: Bool) in
            guard let s = self else { return }
            s.isExploding = false
            s.shrivel()
            if let block = completion {
                block ()
            }
        }
    }
}
