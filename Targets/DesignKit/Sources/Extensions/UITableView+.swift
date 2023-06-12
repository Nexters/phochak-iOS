//
//  UITableView+.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public extension UITableView {
  func registerCell(cellType: UITableViewCell.Type) {
    let identifier: String = "\(cellType)"
    register(cellType, forCellReuseIdentifier: identifier)
  }

  func registerHeaderFooter(viewType: UITableViewHeaderFooterView.Type) {
    let identifier: String = "\(viewType)"
    register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
  }

  func dequeue<T: UITableViewCell>(cellType: T.Type = T.self, indexPath: IndexPath) -> T {
    return dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as! T
  }

  func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T {
    return dequeueReusableHeaderFooterView(withIdentifier: "\(viewType)") as! T
  }
}
