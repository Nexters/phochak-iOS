//
//  PhoChakTextField.swift
//  DesignKit
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public final class PhoChakTextField: UITextField {

  // MARK: Properties
  public enum FieldStyle {
    case search
    case text

    var placeholderText: String {
      switch self {
      case .search: return "어떤 주제를 찾아볼까요"
      case .text: return "터치해서 입력하기"
      }
    }
  }

  private let fieldStyle: FieldStyle
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  public init(fieldStyle: FieldStyle) {
    self.fieldStyle = fieldStyle
    super.init(frame: .zero)

    setupUI()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension PhoChakTextField {

  // MARK: Methods
  func setupUI() {
    backgroundColor = .createColor(.monoGray, .w900)
    textColor = .createColor(.monoGray, .w50)
    tintColor = .createColor(.blue, .w400)
    layer.cornerRadius = 10
    leftViewMode = .always
    leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 1))

    attributedPlaceholder = NSAttributedString(
      string: fieldStyle.placeholderText,
      attributes: [
        NSAttributedString.Key.foregroundColor : UIColor.createColor(.monoGray, .w400)
      ]
    )
  }

  func bind() {
    rx.controlEvent(.editingDidBegin)
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.attributedPlaceholder = nil
      })
      .disposed(by: disposeBag)

    rx.controlEvent(.editingDidEnd)
      .withLatestFrom(rx.text.orEmpty.asObservable())
      .filter { $0.isEmpty }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.attributedPlaceholder = NSAttributedString(
          string: owner.fieldStyle.placeholderText,
          attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.createColor(.monoGray, .w400)
          ]
        )
      })
      .disposed(by: disposeBag)
  }
}
