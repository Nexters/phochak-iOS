//
//  DuplicationCheckButton.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

public final class DuplicationCheckButton: UIButton {

  // MARK: Properties
  public let isFocusingTextFieldSubject: PublishSubject<Bool> = .init()
  public let isEmptyTextFieldSubject: PublishSubject<Bool> = .init()
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
private extension DuplicationCheckButton {
  func setupUI() {
    setTitle("중복확인", for: .normal)
    titleLabel?.font = .createFont(.FootNote, .w600)
    setTitleColor(.createColor(.monoGray, .w50), for: .normal)
    layer.cornerRadius = 10
    layer.borderColor = UIColor.createColor(.monoGray, .w800).cgColor
  }

  func bind() {
    Observable.combineLatest(isFocusingTextFieldSubject, isEmptyTextFieldSubject)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, combineValues in
        let (isFocusing, isEmpty) = combineValues

        owner.setTitleColor(.createColor(.monoGray, isEmpty ? .w700 : .w50), for: .normal)
        owner.backgroundColor = isEmpty ? .clear : .createColor(.blue, .w400)
        owner.isEnabled = !isEmpty
        owner.layer.borderWidth = isFocusing && isEmpty ? 0.5 : 0
      })
      .disposed(by: disposeBag)
  }
}
