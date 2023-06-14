//
//  BlockedListCell.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

final class BlockedListCell: UITableViewCell {

  // MARK: Properties
  private let nameLabel: UILabel = .init()

  // MARK: Override
  override func prepareForReuse() {
    super.prepareForReuse()

    nameLabel.text = .init()
  }

  // MARK: Initialzer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(name: String) {
    nameLabel.text = name
  }
}

// MARK: - Private
private extension BlockedListCell {
  func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none
    
    nameLabel.do {
      $0.textColor = .createColor(.monoGray, .w300)
      $0.font = .init(size: .CallOut, weight: .w600)
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    nameLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(30)
    }
  }
}
