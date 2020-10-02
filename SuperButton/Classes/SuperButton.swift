//
//  SuperButton.swift
//
//  Created by Kraig Wastlund

import Foundation
import UIKit
import AVKit

public protocol SuperButtonActivity {
    func superButtonActive(_ active: Bool)
}

public class SuperButton: UIImageView {
    var isExploding: Bool = false
    var dimension: CGFloat!
    var delegate: SuperButtonActivity?
    
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
            self.delegate?.superButtonActive(true)
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
            self.delegate?.superButtonActive(false)
            self.layer.zPosition = 1
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform.identity.rotated(by: 0)
            })
        }
    }
}
