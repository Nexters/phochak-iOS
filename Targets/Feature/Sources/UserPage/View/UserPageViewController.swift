//
//  UserPageViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/06/13.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class UserPageViewController: BaseViewController<UserPageReactor> {

  // MARK: Properties
  private let blockBarButton: UIBarButtonItem = .init()
  private let nicknameLabel: UILabel = .init()
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )

  // MARK: Initializer
  init(reactor: UserPageReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func setupViews() {
    super.setupViews()

    nicknameLabel.do {
      $0.font = .init(size: .Title3, weight: .w700)
      $0.textColor = .createColor(.monoGray, .w50)
      view.addSubview($0)
    }

    flowLayout.do {
      $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
      $0.minimumInteritemSpacing = 7
      $0.minimumLineSpacing = 7
      $0.itemSize = .init(
        width: (view.frame.width - 60) / 3,
        height: view.frame.height * 0.23
      )
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.registerCell(cellType: MyPagePostCell.self)
      view.addSubview($0)
    }

    blockBarButton.do {
      $0.tintColor = .createColor(.red, .w400)
    }
  }

  override func setupLayoutConstraints() {
    nicknameLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
      $0.leading.equalToSuperview().offset(30)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(nicknameLabel.snp.bottom).offset(40)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: UserPageReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: Private
private extension UserPageViewController {
  typealias Section = RxCollectionViewSectionedAnimatedDataSource<VideoPostSection>
  typealias Action = UserPageReactor.Action

  func bindAction(reactor: UserPageReactor) {
    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    blockBarButton.rx.tap
      .map { Action.tapBlockButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.willDisplayCell
      .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
      .map { $0.1.row }
      .distinctUntilChanged()
      .filter { $0 + 1 >= reactor.currentState.videoPosts.count - 3 }
      .map { _ in Action.fetchMoreItems }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: UserPageReactor) {
    let dataSource: Section = .init(configureCell: { _, collectionView, indexPath, videoPost in
      let cell = collectionView.dequeue(cellType: MyPagePostCell.self, indexPath: indexPath)
      cell.configure(videoPost: videoPost, hideOption: true, indexNumber: indexPath.row)
      cell.delegate = self

      return cell
    })

    reactor.state
      .map { $0.nickname }
      .distinctUntilChanged()
      .bind(with: self, onNext: { owner, nickname in
        owner.nicknameLabel.text = nickname
      })
      .disposed(by: disposeBag)

    reactor.state
      .map {$0.isMe }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isMe in
        owner.navigationItem.rightBarButtonItem = isMe ? nil : owner.blockBarButton
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isBlocked }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isBlocked in
        owner.blockBarButton.title = isBlocked ? "차단 해제" : "차단"
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { [VideoPostSection(header: "", items: $0.videoPosts)] }
      .distinctUntilChanged()
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isLoading }
      .asSignal(onErrorSignalWith: .empty())
      .emit(onNext: { isLoading in
        if isLoading {
          ActivityIndicatorView.show()
        } else {
          ActivityIndicatorView.hide()
        }
      })
      .disposed(by: disposeBag)
  }

  func presentBlindAlertView() {
    presentAlert(type: .blind(currentFilter: .liked))
  }
}

// MARK: - UserPagePostCellDelegate
extension UserPageViewController: MyPagePostCellDelegate {
  func tapPost(videoPost: VideoPost) {
    if videoPost.isBlind {
      presentBlindAlertView()
    } else {
      reactor?.action.onNext(.videoPostCellTap(postID: videoPost.id))
    }
  }
}
