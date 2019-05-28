//
//  ViewController.swift
//  SuperButton
//
//  Created by kraigwastlund on 05/28/2019.
//  Copyright (c) 2019 kraigwastlund. All rights reserved.
//

import UIKit
import DBC
import SuperButton

class ViewController: UIViewController {

    var superButtonView: SuperButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superButtonView = SuperButtonView()
        superButtonView.nodes = nodes()
        setup()
    }
    
    func setup() {
        require(superButtonView != nil, "super button view must not be nil")
        self.view.backgroundColor = .lightGray
        self.superButtonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.superButtonView)
        let views = [ "super": self.superButtonView! ]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[super]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[super(300)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func nodes() -> [SuperNodeView] {
        var nodes = [SuperNodeView]()
        
        nodes.append(SuperNodeView(title: "blah", image: #imageLiteral(resourceName: "super_add_manual"), completion: { print("hello world") }))
        
        let node1 = SuperNodeView()
        node1.title = "test"
        node1.image = #imageLiteral(resourceName: "super_clock_in")
        node1.completion = { print(":this") }
        nodes.append(node1)
        
        let node2 = SuperNodeView()
        node2.title = "test"
        node2.image = #imageLiteral(resourceName: "super_clock_in")
        node2.completion = { print(":this") }
        nodes.append(node2)
        
        let node3 = SuperNodeView()
        node3.title = "test"
        node3.image = #imageLiteral(resourceName: "super_clock_in")
        node3.completion = { print(":this") }
        //nodes.append(node3)
        
        let node4 = SuperNodeView()
        node4.title = "test"
        node4.image = #imageLiteral(resourceName: "super_clock_in")
        node4.completion = { print(":this") }
        //nodes.append(node4)
        
        let node5 = SuperNodeView()
        node5.title = "test"
        node5.image = #imageLiteral(resourceName: "super_clock_in")
        node5.completion = { print(":this") }
        nodes.append(node5)
        
        let node6 = SuperNodeView()
        node6.title = "test6"
        node6.image = #imageLiteral(resourceName: "super_clock_in")
        node6.completion = {
            print(":this")
        }
        nodes.append(node6)
        
        return nodes
    }}

