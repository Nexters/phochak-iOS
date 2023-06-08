//
//  PostRollingViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFAudio
import DesignKit
import Domain
import UIKit

import RxCocoa
import RxSwift

protocol PostRollingDelegate: AnyObject {
  func scrollToItem(with videoPosts: [VideoPost], index: Int)
}

final class PostRollingViewController: BaseViewController<PostRollingReactor> {

  // MARK: Properties
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  private let exclameButtonTapSubject: PublishSubject<Int> = .init()
  private let likeButtonTapSubject: PublishSubject<Int> = .init()
  private let topGradientView: UIView = .init()
  private let navBackBarButton: UIBarButtonItem = .init(image: UIImage(literal: .back))
  private let navMuteSoundBarButton: UIBarButtonItem = .init(image: .init(systemName: "speaker"))
  weak var delegate: PostRollingDelegate?

  // MARK: Initializer
  init(reactor: PostRollingReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    navigationItem.hidesBackButton = true

    let audioSession = AVAudioSession.sharedInstance()
    if audioSession.category != .playback {
      try? audioSession.setCategory(.playback, options: [.allowBluetooth])
      try? audioSession.setActive(true)
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    collectionView.scrollToItem(
      at: .init(item: reactor?.currentIndex ?? 0, section: 0),
      at: .centeredHorizontally,
      animated: false
    )

    topGradientView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0.5),
      endColor: .createColor(.monoGray, .w950, alpha: 0)
    )
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    NotificationCenter.default.post(name: .muteAllPlayers, object: nibName)
    if tabBarController?.selectedIndex == 0 {
      delegate?.scrollToItem(with: reactor?.currentState.videoPosts ?? [], index: reactor?.currentIndex ?? 0)
    }

    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }

  override func setupViews() {
    super.setupViews()

    navigationItem.leftBarButtonItem = navBackBarButton
    navigationItem.rightBarButtonItem = navMuteSoundBarButton

    flowLayout.do {
      $0.minimumLineSpacing = 0
      $0.sectionInset = .zero
      $0.scrollDirection = .horizontal
      $0.itemSize = .init(
        width: view.frame.width,
        height: view.frame.height
      )
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.contentInsetAdjustmentBehavior = .never
      $0.registerCell(cellType: DetailPostCell.self)
      $0.isPagingEnabled = true
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.rx.setDelegate(self).disposed(by: disposeBag)
      view.addSubview($0)
    }

    view.addSubview(topGradientView)
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    topGradientView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(view.frame.height * 0.213)
    }
  }

  override func bind(reactor: PostRollingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra(reactor: reactor)
  }
}

extension PostRollingViewController: UICollectionViewDelegate {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let visibleItems = collectionView.indexPathsForVisibleItems.sorted(by: { $0[1] > $1[1] })

    let cell: DetailPostCell?
    if velocity.x > 0 {
      cell = collectionView.cellForItem(
        at: .init(item: visibleItems[safe: 0]?.item ?? 0, section: 0)
      ) as? DetailPostCell
      reactor?.action.onNext(.didSwipe(direction: .right))
    } else {
      cell = collectionView.cellForItem(
        at: .init(item: visibleItems[safe: 1]?.item ?? 0, section: 0)
      ) as? DetailPostCell
      reactor?.action.onNext(.didSwipe(direction: .left))
    }

    cell?.playVideo()
  }
}

// MARK: - Private
private extension PostRollingViewController {
  func bindAction(reactor: PostRollingReactor) {
    Observable.just(())
      .map { PostRollingReactor.Action.load }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.willEndDragging
      .withUnretained(self)
      .filter { owner, _ in
        return owner.tabBarController?.selectedIndex != PhoChakTab.myPage.rawValue
      }
      .map({ (owner, event) -> Int in
        let index = Int(event.targetContentOffset.pointee.x / owner.collectionView.frame.width)
        return index
      })
      .map { PostRollingReactor.Action.fetchItems(size: 3, currentIndex: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    exclameButtonTapSubject
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, postID in
        owner.presentAlert(
          type: .exclamePost,
          okAction: { [weak self] in
            self?.reactor?.action.onNext(.exclameVideoPost(postID: postID))
            self?.presentAlert(type: .didExclame)
          },
          isNeededCancel: true
        )
      })
      .disposed(by: disposeBag)

    likeButtonTapSubject
      .map { PostRollingReactor.Action.likeVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    navBackBarButton.rx.tap
      .map { PostRollingReactor.Action.tapBackButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: PostRollingReactor) {
    reactor.state
      .map { $0.videoPosts }
      .distinctUntilChanged()
      .bind(to: collectionView.rx.items(
        cellIdentifier: "\(DetailPostCell.self)",
        cellType: DetailPostCell.self)
      ) { [weak self] index, post, cell in
        cell.configure(reactor: .init(videoPost: post))

        if index == self?.reactor?.currentIndex {
          cell.playVideo()
        }

        if let exclameButtonTapSubject = self?.exclameButtonTapSubject {
          cell.exclameButtonTapSubject
            .subscribe(exclameButtonTapSubject)
            .disposed(by: cell.disposeBag)
        }

        if let likeButtonTapSubject = self?.likeButtonTapSubject {
          cell.likeButtonTapSubject
            .subscribe(likeButtonTapSubject)
            .disposed(by: cell.disposeBag)
        }
      }
      .disposed(by: disposeBag)
  }

  func bindExtra(reactor: PostRollingReactor) {
    collectionView.rx.didEndDisplayingCell
      .subscribe(onNext: { cell, index in
        guard let cell = cell as? DetailPostCell else {
          return
        }
        cell.updateMuteState(isMuted: true)
      })
      .disposed(by: disposeBag)

    collectionView.rx.willDisplayCell
      .asSignal()
      .emit(onNext: { [weak self] cell, index in
        guard let cell = cell as? DetailPostCell else {
          return
        }

        cell.updateMuteState(isMuted: false)
        self?.navMuteSoundBarButton.image = .init(systemName: "speaker")
      })
      .disposed(by: disposeBag)

    reactor.alreadyExclamedSubject
      .asSignal(onErrorJustReturn: ())
      .emit(with: self, onNext: { owner, _ in
        owner.presentAlert(type: .alreadyExclamed)
      })
      .disposed(by: disposeBag)

    navMuteSoundBarButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        guard let cell = owner.collectionView.cellForItem(at: .init(item: reactor.currentIndex, section: 0)) as? DetailPostCell else {
          return
        }
        let isMute = !(cell.isMute)
        cell.updateMuteState(isMuted: isMute)
        owner.navMuteSoundBarButton.image = isMute ? .init(systemName: "speaker.slash") : .init(systemName: "speaker")
      })
      .disposed(by: disposeBag)
  }
}
