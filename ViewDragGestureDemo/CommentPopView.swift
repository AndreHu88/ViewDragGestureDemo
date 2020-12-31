//
//  CommentPopView.swift
//  ViewDragGestureDemo
//
//  Created by admin  on 2020/12/29.
//

import UIKit

class CommentPopView: UIView {

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(tableView)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView : UITableView = {
        
        let tableView = UITableView(frame: self.bounds, style: .plain)
        
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

extension CommentPopView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        cell.detailTextLabel?.text = String(format: "这是%d个数据", indexPath.row)
        cell.detailTextLabel?.textColor = .red
        
        cell.textLabel?.text = String(format: "这是%d个数据", indexPath.row)
        cell.textLabel?.textColor = .red
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
}
