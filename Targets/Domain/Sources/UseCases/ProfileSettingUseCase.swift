//
//  ProfileSettingUseCase.swift
//  Domain
//
//  Created by 한상진 on 2023/03/01.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import RxSwift

public enum ProfileSettingResult: Error {
  case success
  case error
}

public protocol ProfileSettingUseCaseType {

  // MARK: Properties
  var profileSettingResultSubject: PublishSubject<ProfileSettingResult> { get }

  // MARK: Methods
  func checkDuplicationNickName(nickName: String) -> Observable<Bool>
  func changeNickName(nickName: String) -> Observable<Void>
}

final class ProfileSettingUseCase: ProfileSettingUseCaseType {
  
  // MARK: Properties
  public let profileSettingResultSubject: PublishSubject<ProfileSettingResult> = .init()
  private let service: ProfileSettingServiceType
  private let disposeBag: DisposeBag = .init()

  // MARK: Initializer
  init(service: ProfileSettingServiceType) {
    self.service = service
  }

  // MARK: Methods
  func checkDuplicationNickName(nickName: String) -> Observable<Bool> {
    service.checkDuplicationNickName(nickName: nickName).asObservable()
  }

  func changeNickName(nickName: String) -> Observable<Void> {
    service.changeNickName(nickName: nickName)
      .subscribe(with: self, onSuccess: { owner, _ in
        owner.profileSettingResultSubject.onNext(.success)
      }, onFailure: { owner, error in
        owner.profileSettingResultSubject.onNext(.error)
      })
      .disposed(by: disposeBag)

    return .empty()
  }
}
