//
//  ExtendedTouchAreaButton.swift
//  DesignKit
//
//  Created by 여정수 on 2023/04/18.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

/// 터치 영역이 기존 영역보다 큰 버튼
public final class ExtendedTouchAreaButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    super.point(inside: point, with: event)

    let touchArea = bounds.insetBy(dx: -5, dy: -5)
    return touchArea.contains(point)
  }
}
