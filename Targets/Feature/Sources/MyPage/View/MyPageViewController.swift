//
//  MyPageViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController<MyPageReactor> {

  // MARK: Properties
  private let settingBarButton: UIBarButtonItem = .init()
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )

  private lazy var settingButtons: SettingButtons = .init()
  private lazy var deleteVideoPostButton: UIButton = .init()
  private lazy var selectedOptionButtonIndexNumber: Int = .init()

  private lazy var withdrawlAlertViewController: PhoChakAlertViewController = .init(
    alertType: .withdrawl
  )
  private lazy var signOutAlertViewController: PhoChakAlertViewController = .init(
    alertType: .signOut
  )
  private lazy var clearCacheAlertViewController: PhoChakAlertViewController = .init(
    alertType: .clearCache
  )

  // MARK: Initializer
  init(reactor: MyPageReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupViews() {
    super.setupViews()

    flowLayout.do {
      $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
      $0.minimumInteritemSpacing = 7
      $0.minimumLineSpacing = 7
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.registerCell(cellType: MyPageProfileCell.self)
      $0.registerCell(cellType: MyPagePostCell.self)
      $0.registerCell(cellType: DefaultCell.self)
      $0.registerHeader(viewType: PostsSectionHeaderView.self)
      $0.registerHeader(viewType: DefaultHeaderView.self)
      $0.delegate = self
      $0.dataSource = self
      view.addSubview($0)
    }

    settingBarButton.do {
      $0.image = .createImage(.setting)
      navigationItem.rightBarButtonItem = $0
    }

    settingButtons.do {
      $0.withdrawlButtonDelegate = self
      $0.signOutButtonDelegate = self
      $0.clearCacheButtonDelegate = self
    }

    deleteVideoPostButton.do {
      $0.setImage(.createImage(.deleteVideoPost), for: .normal)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: MyPageReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra()
  }
}

// MARK: - Extension
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = MyPageReactor.Section(rawValue: indexPath.section) else {
      return .zero
    }

    switch section {
    case .profile:
      return .init(
        width: collectionView.frame.width - 60,
        height: view.frame.height * 0.124
      )

    case .posts:
      return .init(
        width: (collectionView.frame.width - 54) / 3,
        height: view.frame.height * 0.23
      )
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard let section = MyPageReactor.Section(rawValue: section) else {
      return .zero
    }

    switch section {
    case .profile:
      return .zero
    case .posts:
      return CGSize(
        width: collectionView.frame.width - 40,
        height: view.frame.height * 0.08
      )
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    reactor?.action.onNext(.fetchItems(size: 6))
  }
}

extension MyPageViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let section = MyPageReactor.Section(rawValue: section) else {
      return 0
    }

    switch section {
    case .profile:
      return reactor?.currentState.user == nil ? 0 : 1
    case .posts:
      guard let currentFilter = reactor?.currentState.postFilter else {
        return 0
      }

      if currentFilter == .uploaded {
        return reactor?.currentState.uploadedPosts.count ?? 0
      } else {
        return reactor?.currentState.likedPosts.count ?? 0
      }
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    MyPageReactor.Section.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let section = MyPageReactor.Section(rawValue: indexPath.section) else {
      return .init()
    }

    let cell: UICollectionViewCell
    switch section {
    case .profile:
      guard let user = reactor?.currentState.user else {
        return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
      }

      let profileCell = collectionView.dequeue(cellType: MyPageProfileCell.self, indexPath: indexPath)
      profileCell.delegate = self
      profileCell.configure(nickname: user.nickname)
      cell = profileCell

    case .posts:
      guard let postFilter = reactor?.currentState.postFilter else {
        return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
      }

      let postCell = collectionView.dequeue(cellType: MyPagePostCell.self, indexPath: indexPath)
      postCell.delegate = self

      if postFilter == .uploaded {
        guard let post = reactor?.currentState.uploadedPosts[safe: indexPath.item] else {
          return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
        }

        postCell.configure(videoPost: post, indexNumber: indexPath.row)
      } else {
        guard let post = reactor?.currentState.likedPosts[safe: indexPath.item] else {
          return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
        }

        postCell.configure(videoPost: post, hideOption: true, indexNumber: indexPath.row)
      }
      cell = postCell
    }

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return DefaultHeaderView()
    }

    if indexPath.section == MyPageReactor.Section.posts.rawValue {
      let headerView = collectionView.dequeueHeader(viewType: PostsSectionHeaderView.self, indexPath: indexPath)
      headerView.delegate = self
      return headerView
    } else {
      return collectionView.dequeueHeader(viewType: DefaultHeaderView.self, indexPath: indexPath)
    }
  }
}

// MARK: - MyPagePostCellDelegate
extension MyPageViewController: MyPagePostCellDelegate {
  func tapPost(videoPost: VideoPost) {
    if !videoPost.isBlind {
      reactor?.action.onNext(.videoPostCellTap(videoPost: videoPost))
    } else {
      presentBlindAlertView()
    }
  }

  func tapOptionButton(indexNumber: Int, optionButton: UIButton) {
    selectedOptionButtonIndexNumber = indexNumber
    deleteVideoPostButton.removeFromSuperview()
    view.addSubview(deleteVideoPostButton)

    deleteVideoPostButton.snp.makeConstraints {
      $0.bottom.equalTo(optionButton.snp.top).offset(-7.5)
      $0.size.equalTo(CGSize(width: 58, height: 40.5))
      $0.centerX.equalTo(optionButton)
    }
  }
}

// MARK: - MyPageProfileCellDelegate
extension MyPageViewController: MyPageProfileCellDelegate {
  func tapEditProfileButton() {
    reactor?.action.onNext(.editProfileButtonTap)
  }
}

// MARK: - PostsSectionHeaderDelegate
extension MyPageViewController: PostsSectionHeaderDelegate {
  func updateFilter(postFilter: PostsFilterOption) {
    reactor?.action.onNext(.updatePostsListFilter(postFilter: postFilter))
  }
}

// MARK: - SettingButtonsDelegate
extension MyPageViewController
: WithdrawalButtonDelegate, SignOutButtonDelegate, ClearCacheButtonDelegate {
  func tapWithdrawalButton() {
    present(withdrawlAlertViewController, animated: true)
  }

  func tapSignOutButton() {
    present(signOutAlertViewController, animated: true)
  }

  func tapClearCacheButton() {
    present(clearCacheAlertViewController, animated: true)
  }
}

// MARK: Private
private extension MyPageViewController {
  func bindAction(reactor: MyPageReactor) {
    typealias Action = MyPageReactor.Action

    rx.viewWillAppear
      .map { MyPageReactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    withdrawlAlertViewController.acceptButtonAction
      .map { _ in Action.tapWithdrawalButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    signOutAlertViewController.acceptButtonAction
      .map { _ in Action.tapSignOutButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    clearCacheAlertViewController.acceptButtonAction
      .map { _ in Action.tapClearCacheButton }
      .emit(with: self, onNext: { owner, action in
        reactor.action.onNext(action)
        owner.clearCacheAlertViewController.dismiss(animated: true)
      })
      .disposed(by: disposeBag)

    deleteVideoPostButton.rx.tap
      .asSignal()
      .withUnretained(self)
      .map { owner, _ in
        Action.tapPostDeletionButton(indexNumber: owner.selectedOptionButtonIndexNumber)
      }
      .emit(with: self, onNext: { owner, action in
        reactor.action.onNext(action)
        owner.deleteVideoPostButton.removeFromSuperview()
      })
      .disposed(by: disposeBag)
  }

  func bindState(reactor: MyPageReactor) {
    Observable.combineLatest(
      reactor.state.map { $0.user },
      reactor.state.map { $0.uploadedPosts }) { _, _ in }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        if owner.reactor?.currentState.user != nil {
          owner.collectionView.reloadData()
        }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.postFilter }
      .subscribe()
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.likedPosts }
      .subscribe()
      .disposed(by: disposeBag)
  }

  func bindExtra() {
    settingBarButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        guard let screen = owner.view.window?.windowScene?.screen.bounds else { return }
        owner.view.addSubview(owner.settingButtons)

        owner.settingButtons.snp.makeConstraints {
          $0.top.equalTo(owner.view.safeAreaLayoutGuide)
          $0.trailing.equalToSuperview().inset(20)
          $0.width.equalTo(screen.width * 0.641)
        }
      })
      .disposed(by: disposeBag)

    let viewTapGestureSignal = view.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .map { _ in }
      .asSignal(onErrorSignalWith: .empty())

    let collectionViewDidScrollSignal = collectionView.rx.didScroll.asSignal()

    Signal.merge(viewTapGestureSignal, collectionViewDidScrollSignal)
      .emit(with: self, onNext: { owner, _ in
        owner.settingButtons.removeFromSuperview()
        owner.deleteVideoPostButton.removeFromSuperview()
      })
      .disposed(by: disposeBag)
  }

  //TODO: - 추후 변경 예정
  func presentBlindAlertView() {
    let alert: PhoChakAlertViewController = .init(alertType: .blind)
    present(alert, animated: true)

    alert.acceptButtonAction
      .asSignal()
      .emit { _ in
        alert.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
