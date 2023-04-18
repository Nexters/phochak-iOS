//
//  Alertable+.swift
//  DesignKit
//
//  Created by 여정수 on 2023/04/17.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

public protocol Alertable {}

public enum AlertType {
  case profileSetting
  case signOut
  case logout
  case clearCache
  case networkError
  case tokenExpired
  case nicknameDuplicated
  case exclamePost
  case alreadyExclamed
  case blind

  public var title: String {
    switch self {
    case .profileSetting: return "프로필 설정"
    case .signOut: return "회원탈퇴"
    case .logout: return "로그아웃"
    case .clearCache: return "캐시삭제"
    case .networkError: return "네트워크 불안정"
    case .tokenExpired: return "세션이 만료되었습니다"
    case .nicknameDuplicated: return "닉네임이 중복되었습니다"
    case .exclamePost: return "포스팅 신고"
    case .alreadyExclamed: return "신고된 게시물"
    case .blind: return "포스팅 신고누적"
    }
  }

  public var message: String {
    switch self {
    case .profileSetting: return "닉네임을 변경하고 포착을 즐겨보세요"
    case .signOut: return "아이디와 포스팅은 복구할 수 없습니다"
    case .logout: return "소셜계정을 다시 연결하면 정보가 복구됩니다"
    case .clearCache: return "영상 캐시 데이터를 삭제합니다"
    case .networkError: return "인터넷 연결을 확인해주세요"
    case .tokenExpired: return "다시 로그인 후 시도해 주세요"
    case .nicknameDuplicated: return "수정 후 다시 시도해 주세요"
    case .exclamePost: return "신고가 누적된 영상은 볼 수 없게 됩니다"
    case .alreadyExclamed: return "이미 신고가 완료된 영상입니다"
    case .blind: return "이 영상은 다른 사용자에게 보이지 않습니다"
    }
  }
}

public extension Alertable where Self: UIViewController {
  func presentAlert(
    type: AlertType,
    okAction: @escaping (() -> Void?),
    cancelAction: (() -> Void)? = nil
  ) {
    let alertController: UIAlertController = .init(title: type.title, message: type.message, preferredStyle: .alert)
    alertController.modalPresentationStyle = .overCurrentContext
    alertController.modalTransitionStyle = .crossDissolve
    alertController.view.backgroundColor = .createColor(.monoGray, .w800)
    alertController.view.cornerRadius(radius: 16)
    alertController.addAction(.init(title: "확인", style: .default, handler: { _ in okAction() }))

    if let cancelAction {
      alertController.addAction(.init(title: "취소", style: .cancel, handler: { _ in cancelAction() }))
    }

    present(alertController, animated: true)
  }
}
