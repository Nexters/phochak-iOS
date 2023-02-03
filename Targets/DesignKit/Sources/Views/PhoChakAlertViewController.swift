//
//  PhoChakAlertViewController.swift
//  DesignKit
//
//  Created by 한상진 on 2023/02/02.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

public final class PhoChakAlertViewController: UIViewController {

  // MARK: Properties
  private let alertContainerView: UIView = .init()
  private let titleLabel: UILabel = .init()
  private let messageLabel: UILabel = .init()
  private let cancelButton: UIButton = .init()
  private let acceptButton: UIButton = .init()
  private let topBorderLine: UIView = .init()
  private let centerBorderLine: UIView = .init()
  private let disposeBag: DisposeBag = .init()
  private let alertType: AlertTypeLiteral

  private var titleString: String {
    switch alertType {
    case .profileSetting: return "프로필 설정"
    case .accountDeletion: return "회원탈퇴"
    case .signOut: return "로그아웃"
    case .cacheDeletion: return "캐시삭제"
    }
  }

  private var messageString: String {
    switch alertType {
    case .profileSetting: return "닉네임을 변경하고 포착을 즐겨보세요"
    case .accountDeletion: return "아이디와 포스팅은 복구할 수 없습니다"
    case .signOut: return "소셜계정을 다시 연결하면 정보가 복구됩니다"
    case .cacheDeletion: return "영상 캐시 데이터를 삭제합니다"
    }
  }

  public var acceptButtonAction: Signal<Void> {
    acceptButton.rx.tap.asSignal()
  }

  public enum AlertTypeLiteral {
    case profileSetting
    case accountDeletion
    case signOut
    case cacheDeletion
  }

  // MARK: Initializer
  public init(alertType: AlertTypeLiteral) {
    self.alertType = alertType
    super.init(nibName: nil, bundle: nil)
    setupModalStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
    bind()
  }
}

// MARK: - Extension
private extension PhoChakAlertViewController {
  func setupModalStyle() {
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }

  func setupViews() {
    view.backgroundColor = .createColor(.monoGray, .w950, alpha: 0.3)

    alertContainerView.do {
      $0.backgroundColor = .createColor(.monoGray, .w800)
      $0.cornerRadius(radius: 14)
      view.addSubview($0)
    }

    titleLabel.do {
      $0.text = titleString
      $0.font = .createFont(.HeadLine, .w600)
      $0.textColor = .createColor(.monoGray, .w50)
      $0.textAlignment = .center
      alertContainerView.addSubview($0)
    }

    messageLabel.do {
      $0.text = messageString
      $0.font = .createFont(.FootNote, .w400)
      $0.textColor = .createColor(.monoGray, .w50)
      $0.textAlignment = .center
      alertContainerView.addSubview($0)
    }

    cancelButton.do {
      $0.setTitle("취소", for: .normal)
      $0.setTitleColor(.createColor(.blue, .w400), for: .normal)
      $0.titleLabel?.font = .createFont(.SubHead, .w400)
      alertContainerView.addSubview($0)
    }

    acceptButton.do {
      $0.setTitle("확인", for: .normal)
      $0.setTitleColor(.createColor(.blue, .w400), for: .normal)
      $0.titleLabel?.font = .createFont(.SubHead, .w600)
      alertContainerView.addSubview($0)
    }

    [topBorderLine, centerBorderLine].forEach { borderLine in
      borderLine.do {
        $0.backgroundColor = .black
        alertContainerView.addSubview($0)
      }
    }
  }

  func setupLayoutConstraints() {
    alertContainerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(58)
      $0.height.equalTo(alertContainerView.snp.width).multipliedBy(0.538)
      $0.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.equalToSuperview().offset(25)
    }

    messageLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.equalTo(titleLabel.snp.bottom).offset(10)
    }

    cancelButton.snp.makeConstraints {
      $0.leading.bottom.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.5)
      $0.height.equalTo(view.frame.height * 0.066)
    }

    acceptButton.snp.makeConstraints {
      $0.trailing.bottom.equalToSuperview()
      $0.size.equalTo(cancelButton)
    }

    topBorderLine.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1)
      $0.bottom.equalTo(cancelButton.snp.top)
    }

    centerBorderLine.snp.makeConstraints {
      $0.top.equalTo(topBorderLine)
      $0.leading.equalTo(cancelButton.snp.trailing).inset(0.5)
      $0.width.equalTo(1)
      $0.bottom.equalToSuperview()
    }
  }

  func bind() {
    let viewTapGestureSignal = view.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .map { _ in }
      .asSignal(onErrorSignalWith: .empty())

    let cancelButtonTapSignal = cancelButton.rx.tap.asSignal()

    Signal.merge(viewTapGestureSignal, cancelButtonTapSignal)
      .emit(with: self, onNext: { owner, _ in
        owner.dismiss(animated: true)
      })
      .disposed(by: disposeBag)
  }
}
