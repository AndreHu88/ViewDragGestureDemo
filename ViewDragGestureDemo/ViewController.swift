//
//  ViewController.swift
//  ViewDragGestureDemo
//
//  Created by admin  on 2020/12/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        button.setTitle("弹出视图", for: .normal)
        button.addTarget(self, action: #selector(promptView), for: .touchUpInside)
        button.backgroundColor = .red
        self.view.addSubview(button)
       
    }
    
    
    @objc func promptView() {
        
        let commentView = CommentPopView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200))
        CommentContainerView.showToView(superView: self.view, frame: UIScreen.main.bounds, commentBackView: commentView)
    }
    


}

