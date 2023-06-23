//
//  LoginViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AuthenticationServices
import DesignKit
import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import Then

final class SignInViewController: BaseViewController<SignInReactor> {

  // MARK: Properties
  private let iconImageView: UIImageView = .init(image: UIImage(literal: .loginIcon))
  private let logoImageView: UIImageView = .init(image: UIImage(literal: .loginLogo))
  private let titleImageView: UIImageView = .init(image: UIImage(literal: .loginTitle))
  private let kakaoLoginButton: UIButton = .init()
  private let appleLoginButton: UIButton = .init()
  private let termsBottomSheetView: TermsBottomSheetView = .init()

  // MARK: Initializer
  init(reactor: SignInReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func bind(reactor: SignInReactor) {
    bind()
  }

  override func setupViews() {
    super.setupViews()

    [iconImageView, logoImageView, titleImageView].forEach {
      view.addSubview($0)
    }

    appleLoginButton.do {
      $0.backgroundColor = .createColor(.monoGray, .w50)
      $0.setImage(UIImage(literal: .apple), for: .normal)
      $0.setTitle("애플로 로그인", for: .normal)
      $0.titleLabel?.font = UIFont(size: .CallOut, weight: .w800)
      $0.setTitleColor(.createColor(.monoGray, .w900), for: .normal)
      $0.cornerRadius(radius: 10)
      $0.titleEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
      view.addSubview($0)
    }

    kakaoLoginButton.do {
      $0.backgroundColor = .createColor(.yellow, .w400)
      $0.setImage(UIImage(literal: .kakao), for: .normal)
      $0.setTitle("카카오 로그인", for: .normal)
      $0.titleLabel?.font = UIFont(size: .CallOut, weight: .w800)
      $0.setTitleColor(.createColor(.monoGray, .w900), for: .normal)
      $0.cornerRadius(radius: 10)
      $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
      view.addSubview($0)
    }

    termsBottomSheetView.do {
      $0.delegate = self
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    appleLoginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(appleLoginButton.snp.width).multipliedBy(0.171)
      $0.bottom.equalToSuperview().inset(60)
    }

    kakaoLoginButton.snp.makeConstraints {
      $0.leading.trailing.height.equalTo(appleLoginButton)
      $0.bottom.equalTo(appleLoginButton.snp.top).offset(-15)
    }

    titleImageView.snp.makeConstraints {
      $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-248)
      $0.centerX.equalToSuperview()
    }

    logoImageView.snp.makeConstraints {
      $0.bottom.equalTo(titleImageView.snp.top).offset(-20)
      $0.centerX.equalToSuperview()
    }

    iconImageView.snp.makeConstraints {
      $0.bottom.equalTo(logoImageView.snp.top).offset(-40)
      $0.centerX.equalToSuperview()
    }

    termsBottomSheetView.snp.makeConstraints {
      $0.height.equalTo(view.frame.height * 0.286)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(view.frame.height * 0.286)
    }
  }
}

// MARK: - Apple Authentication Services Extension
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    view.window!
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:

      guard let identityToken = appleIDCredential.identityToken,
            let stringToken = String(data: identityToken, encoding: .utf8)
      else { return }

      reactor?.action.onNext(.receiveAppleSigninAuthCode(token: stringToken))

    default:
      break
    }
  }
}

// MARK: - TermsViewDelegate Extension
extension SignInViewController: TermsViewDelegate {
  func tapAgreeButton(loginType: LoginType) {
    switch loginType {
    case .apple:
      signinWithApple()
    case .kakao:
      reactor?.action.onNext(.tapKakaoSignInButton)
    }
  }

  func tapCloseButton() {
    hideTermsView()
  }
}

// MARK: - Private Extenion
private extension SignInViewController {
  func bind() {
    kakaoLoginButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.showTermsView(loginType: .kakao)
      })
      .disposed(by: disposeBag)

    appleLoginButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.showTermsView(loginType: .apple)
      })
      .disposed(by: disposeBag)
  }

  func signinWithApple() {
    let appleIDProvider: ASAuthorizationAppleIDProvider = .init()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authController = ASAuthorizationController(authorizationRequests: [request])
    authController.delegate = self
    authController.presentationContextProvider = self
    authController.performRequests()
  }

  func showTermsView(loginType: LoginType) {
    termsBottomSheetView.loginType = loginType
    self.view.backgroundColor = .createColor(.monoGray, .w800, alpha: 0.4)
    self.view.removeGradient()

    UIView.animate(withDuration: 0.3, animations: {
      self.termsBottomSheetView.transform = CGAffineTransform(
        translationX: 0,
        y: -(self.view.frame.height * 0.286)
      )
      self.view.layoutIfNeeded()
    })
  }

  func hideTermsView() {
    self.view.setGradientBackground()
    self.view.backgroundColor = nil

    UIView.animate(withDuration: 0.3, animations: {
      self.termsBottomSheetView.transform = CGAffineTransform(
        translationX: 0,
        y: (self.view.frame.height * 0.286)
      )
      self.view.layoutIfNeeded()
    })
  }
}
