//
//  EmptySearchResultView.swift
//  Feature
//
//  Created by 여정수 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

final class EmptySearchResultView: UIView {

  private let guideLabel: UILabel = .init().then {
    $0.text = "검색 결과가 없어요"
    $0.font = .init(size: .Title3, weight: .w300)
    $0.textColor = .createColor(.monoGray, .w600)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear
    addSubview(guideLabel)

    guideLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-25)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
