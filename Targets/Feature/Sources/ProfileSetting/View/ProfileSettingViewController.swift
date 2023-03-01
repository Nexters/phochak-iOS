//
//  ProfileSettingViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import Then

final class ProfileSettingViewController: BaseViewController<ProfileSettingReactor> {

  // MARK: Properties
  private let titleLabel: UILabel = .init()
  private let subTitleLabel: UILabel = .init()
  private let textField: PhoChakTextField = .init(fieldStyle: .text)
  private let checkDuplicationButton: DuplicationCheckButton = .init()
  private let completeButton: CompletionButton = .init()
  private lazy var alertViewController: PhoChakAlertViewController = .init(alertType: .nickNameDuplicated)

  // MARK: Initializer
  init(reactor: ProfileSettingReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func bind(reactor: ProfileSettingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra()
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(titleLabel)
    view.addSubview(textField)
    view.addSubview(subTitleLabel)
    view.addSubview(completeButton)
    view.addSubview(checkDuplicationButton)

    textField.do {
      $0.becomeFirstResponder()
    }

    titleLabel.do {
      $0.text = "프로필 설정"
      $0.font = .createFont(.LargeTitle, .w800)
      $0.textColor = .createColor(.monoGray, .w50)
    }

    subTitleLabel.do {
      $0.text = "10자 이하의 닉네임을 입력해 주세요"
      $0.font = .createFont(.Body, .w400)
      $0.textColor = .createColor(.monoGray, .w500)
    }
  }

  override func setupLayoutConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
      $0.leading.equalToSuperview().offset(30)
    }

    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel)
    }

    textField.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(view.frame.height * 0.071)
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(74)
    }

    checkDuplicationButton.snp.makeConstraints {
      $0.top.bottom.trailing.equalTo(textField).inset(10)
      $0.width.equalTo(textField).multipliedBy(0.285)
    }

    completeButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(textField)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
    }
  }
}

// MARK: - Private
private extension ProfileSettingViewController {

  // MARK: Properties
  var isDuplicatedBinder: Binder<Bool> {
    .init(self, binding: { owner, isDuplicated in
      owner.subTitleLabel.textColor = .createColor(isDuplicated ? .red : .green, .w400)

      let titleText = isDuplicated ? "이미 존재하는 닉네임입니다" : "사용할 수 있는 닉네임입니다"
      owner.subTitleLabel.text = titleText
    })
  }

  // MARK: Methods
  func bindAction(reactor: ProfileSettingReactor) {
    typealias Action = ProfileSettingReactor.Action

    checkDuplicationButton.rx.tap
      .withLatestFrom(textField.rx.text.orEmpty)
      .map { Action.tapCheckButton(nickName: String($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    textField.rx.text.orEmpty
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .map { _ in Action.inputNickName }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    completeButton.rx.tap
      .withLatestFrom(textField.rx.text.orEmpty)
      .map { Action.tapCompleteButton(nickName: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    alertViewController.acceptButtonAction
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.alertViewController.dismiss(animated: true)
        reactor.action.onNext(.tapAlertAcceptButton)
      })
      .disposed(by: disposeBag)
  }

  func bindState(reactor: ProfileSettingReactor) {
    typealias State = ProfileSettingReactor.State

    reactor.isDuplicatedSubject
      .bind(to: isDuplicatedBinder)
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isEnableComplete }
      .distinctUntilChanged()
      .bind(to: completeButton.isTapEnableSubject)
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isError }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.present(owner.alertViewController, animated: true)
      })
      .disposed(by: disposeBag)
  }

  func bindExtra() {
    textField.rx.controlEvent(.editingDidBegin)
      .map { _ in true}
      .bind(to: checkDuplicationButton.isFocusingTextFieldSubject)
      .disposed(by: disposeBag)

    textField.rx.controlEvent(.editingDidEnd)
      .map { _ in false }
      .bind(to: checkDuplicationButton.isFocusingTextFieldSubject)
      .disposed(by: disposeBag)

    textField.rx.text.orEmpty
      .asSignal(onErrorJustReturn: "")
      .map(changeValidNickName)
      .emit(to: textField.rx.text)
      .disposed(by: disposeBag)

    textField.rx.text.orEmpty
      .map { $0.isEmpty }
      .distinctUntilChanged()
      .bind(to: checkDuplicationButton.isEmptyTextFieldSubject)
      .disposed(by: disposeBag)

    view.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }

  func changeValidNickName(_ text: String) -> String {
    guard let lastText = text.last else { return text }

    if lastText == " " {
      return String(text.dropLast())
    }

    if text.count > 10 {
      subTitleLabel.text = "10자 이하의 다른 닉네임을 입력해주세요"
      subTitleLabel.textColor = .createColor(.red, .w400)
      return String(text.dropLast())
    }

    if String(lastText).range(
      of: "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\_]$",
      options: .regularExpression
    ) == nil {
      subTitleLabel.text = "특수문자는 _ 만 쓸 수 있어요"
      subTitleLabel.textColor = .createColor(.red, .w400)
      return String(text.dropLast())
    }

    return text
  }
}
