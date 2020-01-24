//
//  SuperButton.swift
//
//  Created by Kraig Wastlund

import Foundation
import UIKit
import AVKit

public class SuperButton: UIImageView {
    var isExploding: Bool = false
    var dimension: CGFloat!
    
    convenience init(color: UIColor, dimension: CGFloat) {
        self.init(frame: CGRect.zero)
        self.backgroundColor = color
        self.dimension = dimension
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = CGRect.zero
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = dimension
        setImage()
    }
    
    func setImage() {
        let podBundle = Bundle(for: self.classForCoder)
        guard let bundleUrl = podBundle.url(forResource: "SuperButton", withExtension: "bundle") else { assert(false); return }
        guard let bundle = Bundle(url: bundleUrl) else { assert(false); return }
        guard let image = UIImage(named: "super_menu", in: bundle, compatibleWith: nil) else { assert(false); return }
        self.image = image
    }
    
    func growNodesAndRotate() {
        if !self.isGrown() {
            self.layer.zPosition = 2
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 4.0)
            })
            AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
        }
    }
    
    func isGrown() -> Bool {
        return self.transform.d != 1.0
    }
    
    func shrivel() {
        if !isExploding {
            self.layer.zPosition = 1
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform.identity.rotated(by: 0)
            })
        }
    }
    
    func explode(completion: (() -> Void)?) {
        self.isExploding = true
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
        }) { (complete: Bool) in
            self.isExploding = false
            if let block = completion {
                block ()
            }
        }
    }
}
