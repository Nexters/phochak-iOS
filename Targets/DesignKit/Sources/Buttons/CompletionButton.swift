//
//  CompleteButton.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

public final class CompletionButton: UIButton {

  // MARK: Properties
  public let isEnableTapSubject: PublishSubject<Bool> = .init()
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  public override init(frame: CGRect) {
    super.init(frame: frame)

    setupUI()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Extension
private extension CompletionButton {
  func setupUI() {
    setTitle("완료", for: .normal)
    titleLabel?.font = .createFont(.CallOut, .w800)
    setTitleColor(.createColor(.monoGray, .w600), for: .normal)
    layer.cornerRadius = 10
    layer.borderColor = UIColor.createColor(.monoGray, .w800).cgColor
  }

  func bind() {
    isEnableTapSubject
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isEnable in
        owner.setTitleColor(.createColor(.monoGray, isEnable ? .w50 : .w600), for: .normal)
        owner.backgroundColor = isEnable ? .createColor(.monoGray, .w800) : .clear
        owner.isEnabled = isEnable
        owner.layer.borderWidth = isEnable ? 0 : 0.5
      })
      .disposed(by: disposeBag)
  }
}
