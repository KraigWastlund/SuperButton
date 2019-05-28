//
//  SuperButton.swift
//
//  Created by Kraig Wastlund

import Foundation
import UIKit
import AVKit

public class SuperButton: UIImageView {
    var isExploding: Bool = false
    var buttonBackgroundColor: UIColor = .blue {
        didSet(value) {
            self.backgroundColor = value
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = CGRect.zero
        self.backgroundColor = buttonBackgroundColor
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 40
        self.image = #imageLiteral(resourceName: "super_menu")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func growNodesAndRotate() {
        if !self.isGrown() {
            self.layer.zPosition = 2
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else { return }
                s.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi / 4.0)
                s.backgroundColor = s.buttonBackgroundColor
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
                s.backgroundColor = s.buttonBackgroundColor
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
