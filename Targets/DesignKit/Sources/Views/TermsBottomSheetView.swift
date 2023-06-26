//
//  TermsBottomSheetView.swift
//  DesignKit
//
//  Created by 한상진 on 2023/06/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxSwift

public protocol TermsViewDelegate: AnyObject {
  func tapAgreeButton(loginType: LoginType)
  func tapShowButton()
  func tapCloseButton()
}

public enum LoginType {
  case kakao, apple
}

public final class TermsBottomSheetView: UIView {

  // MARK: Properties
  private let titleLabel: UILabel = .init()
  private let termsLabel: UILabel = .init()
  private let showButton: UIButton = .init()
  private let agreeButton: UIButton = .init()
  private let closeButton: UIButton = .init()

  public var loginType: LoginType?
  public weak var delegate: TermsViewDelegate?
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension TermsBottomSheetView {
  func setupViews() {
    backgroundColor = .createColor(.monoGray, .w800)
    cornerRadius([.topLeft, .topRight], radius: 18)

    titleLabel.do {
      $0.text = "PhoChak 이용약관에 동의해주세요"
      $0.font = .init(size: .Title3, weight: .w800)
      $0.textColor = .createColor(.monoGray, .w50)
      addSubview($0)
    }

    termsLabel.do {
      $0.text = "[필수] 서비스 이용약관 동의"
      $0.font = .init(size: .Body, weight: .w400)
      $0.textColor = .createColor(.monoGray, .w50)
      addSubview($0)
    }

    showButton.do {
      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.init(size: .Body, weight: .w400) as Any,
        .foregroundColor: UIColor.createColor(.monoGray, .w50) as Any,
        .underlineStyle: NSUnderlineStyle.single.rawValue
      ]

      let attributedString: NSMutableAttributedString = .init(
        string: "보기",
        attributes: attributes
      )

      $0.setAttributedTitle(attributedString, for: .normal)
      addSubview($0)
    }

    agreeButton.do {
      $0.setTitle("동의 후 시작하기", for: .normal)
      $0.setTitleColor(.createColor(.blue, .w400), for: .normal)
      $0.titleLabel?.font = .init(size: .SubHead, weight: .w600)
      addSubview($0)
    }

    closeButton.do {
      $0.setImage(.init(literal: .iconX), for: .normal)
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().offset(30)
    }

    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().inset(30)
    }

    termsLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.height.equalTo(14)
      $0.leading.equalTo(titleLabel)
    }

    showButton.snp.makeConstraints {
      $0.top.equalTo(termsLabel)
      $0.height.equalTo(14)
      $0.trailing.equalTo(closeButton)
    }

    agreeButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-30)
      $0.centerX.equalToSuperview()
    }
  }

  func bind() {
    agreeButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        guard let loginType = owner.loginType else {
          return
        }

        owner.delegate?.tapAgreeButton(loginType: loginType)
      })
      .disposed(by: disposeBag)

    closeButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.tapCloseButton()
      })
      .disposed(by: disposeBag)

    showButton.rx.tap
      .subscribe(with: self, onNext: { owner, _ in
        owner.delegate?.tapShowButton()
      })
      .disposed(by: disposeBag)
  }
}
