//
//  HomeViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeViewController: BaseViewController<HomeReactor> {

  // MARK: Properties
  private let titleImageView: UIImageView = .init()
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  private let likeVideoPostSubject: PublishSubject<Int> = .init()
  private let updatedDataSourceSubject: PublishSubject<[VideoPost]> = .init()
  private var isFirstEnter: Bool = true
  private var currentIndex: Int = 0
  private var previousIndex: Int = 0

  // MARK: Initializer
  init(reactor: HomeReactor) {
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

    titleImageView.do {
      $0.image = UIImage(literal: .logo)
      navigationItem.leftBarButtonItem = .init(customView: $0)
    }

    flowLayout.do {
      $0.itemSize = .init(width: view.frame.width * 0.7, height: view.frame.height * 0.54)
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 30
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.decelerationRate = .fast
      $0.contentInset = .init(top: 0, left: 50, bottom: 0, right: 50)
      $0.registerCell(cellType: VideoPostCell.self)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra(reactor: reactor)
  }

  func refresh() {
    reactor?.action.onNext(.refresh)
  }
}

// MARK: - Private
private extension HomeViewController {
  // MARK: Methods
  func bindAction(reactor: HomeReactor) {
    rx.viewDidLoad
      .map { HomeReactor.Action.fetchUserProfile }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.didEndDragging.map { _ in }
      .asObservable()
      .withUnretained(self)
      .map { owner, _ in HomeReactor.Action.fetchMoreItems(size: 6, currentIndex: owner.currentIndex) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.itemSelected
      .map { HomeReactor.Action.tapVideoCell(index: $0.item) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    likeVideoPostSubject
      .map { HomeReactor.Action.likeVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    updatedDataSourceSubject
      .map { HomeReactor.Action.updateDataSource(videoPosts: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    rx.viewWillAppear
      .map { HomeReactor.Action.fetchInitialItems }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.isNeededProfileGuide }
      .distinctUntilChanged()
      .asSignal(onErrorJustReturn: false)
      .filter { $0 }
      .emit { [weak self] _ in
        self?.presentAlert(
          type: .profileSetting,
          okAction: { reactor.action.onNext(.pushProfileSettingScene) },
          isNeededCancel: true
        )
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.videoPosts }
      .distinctUntilChanged()
      .bind(to: collectionView.rx.items(
        cellIdentifier: "\(VideoPostCell.self)",
        cellType: VideoPostCell.self)
      ) { [weak self] index, post, cell in
        cell.configure(post)
        cell.delegate = self

        if index == self?.currentIndex {
          cell.applyLagreScaleTransform {
            cell.playVideo()
          }
        }
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(onNext: { isLoading in
        if isLoading {
          ActivityIndicatorView.show()
        } else {
          ActivityIndicatorView.hide()
        }
      })
      .disposed(by: disposeBag)

    reactor.alreadyExclamedSubject
      .asSignal(onErrorJustReturn: ())
      .emit(with: self, onNext: { owner, _ in
        owner.presentAlert(type: .alreadyExclamed, okAction: {})
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.didRefresh }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, didRefresh in
        if didRefresh {
          guard let rect = owner.collectionView.layoutAttributesForItem(at: .init(item: 0, section: 0)) else {
            return
          }

          owner.collectionView.scrollRectToVisible(rect.frame, animated: true)
          owner.currentIndex = 0
        }
      })
      .disposed(by: disposeBag)
  }

  func bindExtra(reactor: HomeReactor) {
    collectionView.rx.didScroll
      .asSignal()
      .map(currentIndexByOffset)
      .distinctUntilChanged()
      .map { _ in }
      .emit(to: transformBinder)
      .disposed(by: disposeBag)

    collectionView.rx.willEndDragging
      .asSignal()
      .map { $1 }
      .emit(to: pagingBinder)
      .disposed(by: disposeBag)

    Observable.combineLatest(
      rx.viewWillAppear,
      collectionView.rx.willDisplayCell.filter { $0.1.contains(where: { $0 == 0 }) }) { _, _ in }
      .debounce(.milliseconds(50), scheduler: MainScheduler.instance)
      .take(1)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        if owner.isFirstEnter, let cell = owner.collectionView.cellForItem(at: .init(item: 0, section: 0)) {
          cell.applyLagreScaleTransform()
          owner.isFirstEnter.toggle()
        }
      })
      .disposed(by: disposeBag)

    rx.viewWillAppear
      .skip(1)
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, _ in
        owner.collectionView.reloadData()
      })
      .disposed(by: disposeBag)

    titleImageView.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.refresh()
      })
      .disposed(by: disposeBag)
  }

  // MARK: Properties
  var pagingBinder: Binder<UnsafeMutablePointer<CGPoint>> {
    return .init(self) { owner, contentOffset in
      guard let layout = owner.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }

      let cellWidth = layout.itemSize.width + layout.minimumLineSpacing

      var offset = contentOffset.pointee
      let index = round((offset.x + owner.collectionView.contentInset.left) / cellWidth)

      if index > CGFloat(owner.currentIndex) {
        owner.currentIndex += 1
        owner.previousIndex = owner.currentIndex - 1
      } else if index < CGFloat(owner.currentIndex), owner.currentIndex != 0 {
        owner.currentIndex -= 1
        owner.previousIndex = owner.currentIndex + 1
      }

      offset = .init(
        x: CGFloat(owner.currentIndex) * cellWidth - owner.collectionView.contentInset.left - 10,
        y: 0
      )

      contentOffset.pointee = offset
    }
  }

  var transformBinder: Binder<Void> {
    return .init(self) { owner, _ in
      guard let layout = owner.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }

      let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
      let offsetX = owner.collectionView.contentOffset.x
      let index = round((offsetX + owner.collectionView.contentInset.left) / cellWidthIncludeSpacing)
      let indexPath = IndexPath(item: Int(index), section: 0)

      if let cell = owner.collectionView.cellForItem(at: indexPath) as? VideoPostCell {
        UIView.animate(withDuration: 0.25) {
          cell.applyLagreScaleTransform {
            cell.playVideo()
          }
        }
      }

      for visibleIndex in owner.collectionView.indexPathsForVisibleItems.map({ $0.item }) {
        if visibleIndex != Int(index) {
          let cell = owner.collectionView.cellForItem(at: .init(item: Int(visibleIndex), section: 0)) as? VideoPostCell
          UIView.animate(withDuration: 0.25) {
            cell?.applyIdentityTransform({
              cell?.stopVideo()
          })
          }
        }
      }
    }
  }

  func currentIndexByOffset() -> Int {
      guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return .zero
      }

      let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
      let offsetX = collectionView.contentOffset.x
      let index = round((offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing)

      return Int(index)
    }
}

extension HomeViewController: VideoPostCellDelegate {
  func didTapLikeButton(postID: Int) {
    reactor?.action.onNext(.likeVideoPost(postID: postID))
  }

  func didTapExclameButton(postID: Int) {
    presentAlert(
      type: .exclamePost,
      okAction: { [weak self] in
        self?.reactor?.action.onNext(.exclameVideoPost(postID: postID))
      },
      isNeededCancel: true
    )
  }
}

// MARK: - PostRollingDelegate
extension HomeViewController: PostRollingDelegate {
  func scrollToItem(with videoPosts: [VideoPost], index: Int) {
    updatedDataSourceSubject.onNext(videoPosts)

    currentIndex = index
    previousIndex = index == 0 ? 0 : index - 1

    guard let rect = collectionView.layoutAttributesForItem(at: .init(item: index, section: 0)) else {
      return
    }

    collectionView.scrollRectToVisible(rect.frame, animated: false)
    collectionView.layoutIfNeeded()
  }
}
