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

public protocol SettingButtonDelegate: AnyObject {
  func tapClearCacheButton()
  func tapLogoutButton()
  func tapSignOutButton()
  func tapBlockListButton()
  func tapCheckWithButton()
}

public final class SettingButtonStackView: UIStackView {

  // MARK: Properties
  private let disposeBag: DisposeBag = .init()
  private let signOutButton: UIButton = .init()
  private let logoutButton: UIButton = .init()
  private let clearCacheButton: UIButton = .init()
  private let blockListButton: UIButton = .init()
  private let checkWithButton: UIButton = .init()
  private var allButtons: [UIButton] {
    return [signOutButton, logoutButton, clearCacheButton, blockListButton, checkWithButton]
  }

  public weak var delegate: SettingButtonDelegate?

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
private extension SettingButtonStackView {

  // MARK: Methods
  func setupViews() {
    axis = .vertical
    backgroundColor = .createColor(.monoGray, .w800)

    signOutButton.do {
      $0.setTitle("회원탈퇴", for: .normal)
    }

    logoutButton.do {
      $0.setTitle("로그아웃", for: .normal)
    }

    clearCacheButton.do {
      $0.setTitle("캐시삭제", for: .normal)
    }

    blockListButton.do {
      $0.setTitle("차단한 유저", for: .normal)
    }

    checkWithButton.do {
      $0.setTitle("문의하기", for: .normal)
    }

    allButtons.forEach { button in
      button.do {
        $0.contentHorizontalAlignment = .leading
        $0.titleEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        $0.titleLabel?.font = UIFont(size: .Body, weight: .w400)
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
    signOutButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapSignOutButton()
      })
      .disposed(by: disposeBag)

    logoutButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapLogoutButton()
      })
      .disposed(by: disposeBag)

    clearCacheButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapClearCacheButton()
      })
      .disposed(by: disposeBag)

    blockListButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapBlockListButton()
      })
      .disposed(by: disposeBag)

    checkWithButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.delegate?.tapCheckWithButton()
      })
      .disposed(by: disposeBag)
  }
}
