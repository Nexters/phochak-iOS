//
//  SettingButtons.swift
//  DesignKit
//
//  Created by 한상진 on 2023/03/02.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit
import Then

public protocol WithdrawalButtonDelegate: AnyObject {
  func tapWithdrawalButton()
}

public protocol SignOutButtonDelegate: AnyObject {
  func tapSignOutButton()
}

public protocol ClearCacheButtonDelegate: AnyObject {
  func tapClearCacheButton()
}

public final class SettingButtons: UIStackView {

  // MARK: Properties
  private let disposeBag: DisposeBag = .init()
  private let withdrawalButton: UIButton = .init()
  private let signOutButton: UIButton = .init()
  private let clearCacheButton: UIButton = .init()
  public var allButtons: [UIButton] {
    return [withdrawalButton, signOutButton, clearCacheButton]
  }

  public weak var withdrawlButtonDelegate: WithdrawalButtonDelegate?
  public weak var signOutButtonDelegate: SignOutButtonDelegate?
  public weak var clearCacheButtonDelegate: ClearCacheButtonDelegate?

  // MARK: Initializer
  public init() {
    super.init(frame: .zero)

    setupViews()
    setupConstraints()
    setupSeparator()
    setupBind()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  public override func layoutSubviews() {
    super.layoutSubviews()

    setupCornerRadius()
  }
}

// MARK: - Private
private extension SettingButtons {

  // MARK: Methods
  func setupViews() {
    axis = .vertical
    backgroundColor = .createColor(.monoGray, .w800)

    withdrawalButton.do {
      $0.setTitle("회원탈퇴", for: .normal)
    }

    signOutButton.do {
      $0.setTitle("로그아웃", for: .normal)
    }

    clearCacheButton.do {
      $0.setTitle("캐시삭제", for: .normal)
    }

    allButtons.forEach { button in
      button.do {
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        $0.titleLabel?.font = .createFont(.Body, .w400)
        $0.titleLabel?.textColor = .createColor(.monoGray, .w50)
        $0.backgroundColor = .clear

        if #available(iOS 15.0, *) {
          var buttonConfiguration = UIButton.Configuration.filled()
          buttonConfiguration.background.cornerRadius = 0
          buttonConfiguration.background.backgroundColor = .clear
          buttonConfiguration.titlePadding = 16
          buttonConfiguration.cornerStyle = .fixed
          button.configuration = buttonConfiguration
        }
      }
    }
  }

  func setupConstraints() {
    allButtons.forEach { button in
      button.snp.makeConstraints {
        $0.height.equalTo(button.snp.width).multipliedBy(0.176)
      }
    }
  }

  func setupSeparator() {
    for (idx, button) in allButtons.enumerated() {
      addArrangedSubview(button)
      guard idx != allButtons.count - 1 else { return }

      let separatorView: UIView = .init().then {
        $0.backgroundColor = .createColor(.monoGray, .w900)
      }

      separatorView.snp.makeConstraints {
        $0.height.equalTo(0.5)
      }

      addArrangedSubview(separatorView)
    }
  }

  func setupCornerRadius() {
    cornerRadius(radius: 12)
  }

  func setupBind() {
    withdrawalButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.withdrawlButtonDelegate?.tapWithdrawalButton()
      })
      .disposed(by: disposeBag)

    signOutButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.signOutButtonDelegate?.tapSignOutButton()
      })
      .disposed(by: disposeBag)

    clearCacheButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.clearCacheButtonDelegate?.tapClearCacheButton()
      })
      .disposed(by: disposeBag)
  }
}
