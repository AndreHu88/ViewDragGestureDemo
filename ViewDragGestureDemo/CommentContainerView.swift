//
//  CommentContainerView.swift
//  ViewDragGestureDemo
//
//  Created by admin  on 2020/12/29.
//

import UIKit

class CommentContainerView: UIView {
    
    var containerView : UIView?
    
    var scrollerView : UIScrollView?
    
    /// 向下拖拽最后的偏移量
    var lastDrapOffset : CGFloat = 0
    
    /// 当前拖拽的是否是TableView
    var isDragScrollView : Bool = false
    
    init(frame : CGRect, commentBackView : UIView) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        self.addGestureRecognizer(self.tapGestureRecognizer)
        
        commentBackView.addGestureRecognizer(self.panGestureRecognizer)
        
        self.addSubview(commentBackView)
        self.containerView = commentBackView
    }
    
    //MARK: Public
    public static func showToView(superView : UIView, frame : CGRect, commentBackView : UIView) {
        
        let view = CommentContainerView(frame: frame, commentBackView: commentBackView)
        superView.addSubview(view)
        
        UIView.animate(withDuration: 0.2) {
            
            var frame = view.containerView?.frame ?? .zero
            frame.origin.y = frame.origin.y - frame.size.height
            view.containerView?.frame = frame
        }
    }
    
    func dismissView() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            
            var frame = self.containerView?.frame ?? .zero
            frame.origin.y = frame.origin.y + frame.size.height
            self.containerView?.frame = frame
            
        } completion: { (result) in
            
            self.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    @objc func tapGestureAction(tapGesture : UITapGestureRecognizer) {
        
    }
    
    /// 拖拽手势
    @objc func panGestureAction(panGesture : UIPanGestureRecognizer) {
        
        let point = panGesture.translation(in: self.containerView)
        
        print(point)
        
        guard let containerView = self.containerView else { return  }
        
        /// 当前拖拽的是tableView
        if self.isDragScrollView {
            
            /// 说明tableView在顶部
            if (self.scrollerView?.contentOffset.y ?? 0) <= 0 {
                
                if point.y > 0 {
                    
                    self.scrollerView?.contentOffset = .zero
                    self.scrollerView?.panGestureRecognizer.isEnabled = false
                    self.scrollerView?.panGestureRecognizer.isEnabled = true
                    self.isDragScrollView = false
                    
                    self.containerView?.frame = CGRect(x: containerView.frame.origin.x, y: containerView.frame.origin.y + point.y, width: containerView.frame.width, height: containerView.frame.height )
                }
            }
            
        }
        else {
            
            var containerViewOriginY = self.containerView?.frame.origin.y ?? 0
            
            if point.y > 0 {
                
                self.containerView?.frame = CGRect(x: self.containerView?.frame.origin.x ?? 0, y: self.containerView?.frame.origin.y ?? 0 + point.y, width: self.containerView?.frame.width ?? 0, height: self.containerView?.frame.height ?? 0)
            }
            else if point.y < 0 && containerViewOriginY > (self.frame.size.height - containerView.frame.size.height) {
                //向上拖
                
                let containerViewOffset = self.frame.size.height - containerView.frame.size.height
                
                containerViewOriginY = (containerViewOriginY + point.y) > containerViewOffset ? (containerViewOriginY + point.y) : containerViewOffset
                
                self.containerView?.frame = CGRect(x: containerView.frame.origin.x, y: containerViewOriginY, width: containerView.frame.size.width, height: containerView.frame.size.height)
                
            }
            
        }
        
        panGesture.setTranslation(.zero, in: containerView)
        if panGesture.state == .ended {
            
            print("转换之后的point: \(point)")

            if self.lastDrapOffset > 10 && !self.isDragScrollView {
                
                /// 轻扫下拉
                dismissView()
            }
            else {
                
                /// 普通拖拽 超过一半就消失
                if containerView.frame.origin.y >= UIScreen.main.bounds.size.height - containerView.frame.size.height / 2 {
                    self.dismissView()
                }
                else {
                    
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                        
                        /// 让view恢复到原来的frame
                        var frame = self.containerView?.frame ?? .zero
                        frame.origin.y = self.frame.size.height - containerView.frame.size.height
                        self.containerView?.frame = frame
                        
                    } completion: { (result) in
                        
                        print("结束了")
                    }
                }

            }
            
        }
        
        self.lastDrapOffset = point.y
    }
    
    
    //MARK: lazyload
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tapGesture:)))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(panGesture:)))
        panGesture.delegate = self
        return panGesture
    }()
    
}

extension CommentContainerView : UIGestureRecognizerDelegate {
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if gestureRecognizer == self.panGestureRecognizer {
            
            var touchView = touch.view
            while touchView != nil {
                
                if touchView is UIScrollView {
                    
                    self.isDragScrollView = true
                    self.scrollerView = touchView as? UIScrollView
                    break
                }
                else if touchView == self.containerView {
                    
                    self.isDragScrollView = false
                    break
                }
                
                touchView = touchView?.next as? UIView
            }
        }
        
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.tapGestureRecognizer {
            
            /// 如果是点击手势
            let point = gestureRecognizer.location(in: self.containerView)
            if (self.containerView?.layer.contains(point) ?? false) && gestureRecognizer.view == self {
                return false
            }
        }
        else if gestureRecognizer == self.panGestureRecognizer {
            
        }
        
        return true
    }
    
    /// 控制Gesture是否可以同时识别， 一般使用默认值(默认返回NO：不与任何手势共存)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == self.panGestureRecognizer {
            
            if otherGestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) {
                
                if otherGestureRecognizer.view is UIScrollView {
                    return true
                }
            }
        }
        
        return false
    }
    
}
