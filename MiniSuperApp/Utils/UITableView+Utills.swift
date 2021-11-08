//
//  UITableView+Utills.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import UIKit

extension UITableView {
    
    func register(cellType: UITableViewCell.Type) {
        self.register(cellType.self, forCellReuseIdentifier: "\(cellType)")
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
