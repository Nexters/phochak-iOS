//
//  DetailPostCell.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AVFoundation
import DesignKit
import Domain
import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

final class DetailPostCell: BaseCollectionViewCell, View, VideoPlayable {

  // MARK: Properties
  let videoPlayerView: VideoPlayerView = .init()
  private let hashTagListView: HashTagListView = .init()
  private let firstGradientView: UIView = .init()
  private let secondGradeintView: UIView = .init()
  let exclameButtonTapSubject: PublishSubject<Int> = .init()
  let likeButtonTapSubject: PublishSubject<Int> = .init()

  // MARK: Override
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupViews() {
    contentView.backgroundColor = .clear
    contentView.addSubview(videoPlayerView)
    videoPlayerView.addSubview(secondGradeintView)
    videoPlayerView.addSubview(firstGradientView)

    hashTagListView.do {
      $0.backgroundColor = .clear
      videoPlayerView.addSubview($0)
    }
  }

  override func layoutSubviews() {
    firstGradientView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0),
      endColor: .createColor(.monoGray, .w950, alpha: 0.9)
    )

    secondGradeintView.setGradient(
      startColor: .createColor(.monoGray, .w950, alpha: 0),
      endColor: .createColor(.monoGray, .w950, alpha: 0.9)
    )
  }

  override func setupLayoutConstraints() {
    videoPlayerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    hashTagListView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-44)
      $0.height.equalToSuperview().multipliedBy(0.23)
    }

    firstGradientView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.26)
      $0.bottom.equalToSuperview()
    }

    secondGradeintView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.473)
      $0.bottom.equalToSuperview()
    }
  }

  // MARK: Methods
  func configure(reactor: DetailPostCellReactor) {
    self.reactor = reactor

    videoPlayerView.configure(videoPost: reactor.videoPost)
  }

  func bind(reactor: DetailPostCellReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra()
  }

  func updateMuteState(isMuted: Bool) {
    videoPlayerView.player?.isMuted = isMuted
  }
}

// MARK: - Private
private extension DetailPostCell {
  func bindAction(reactor: DetailPostCellReactor) {
    Observable.just(reactor.videoPost)
      .map { DetailPostCellReactor.Action.load(videoPost: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: DetailPostCellReactor) {
    reactor.state
      .map { $0.videoPost }
      .subscribe(with: self, onNext: { owner, videoPost in
        guard let videoPost = videoPost else { return }
        owner.hashTagListView.configure(videoPost: videoPost)
      })
      .disposed(by: disposeBag)
  }

  func bindExtra() {
    videoPlayerView.addDoubleTapGesture()
      .rx.event
      .filter { $0.state == .recognized }
      .map { [weak self] _ in self?.reactor?.videoPost.id ?? 0 }
      .filter { [weak self] _ in
        FeedbackGenerator.shared.generate(.success)
        return !(self?.reactor?.videoPost.isLiked ?? false)
      }
      .bind(to: likeButtonTapSubject)
      .disposed(by: disposeBag)

    hashTagListView.exclameButtonTapObservable
      .subscribe(exclameButtonTapSubject)
      .disposed(by: disposeBag)

    hashTagListView.likeButtonTapObservable
      .subscribe(likeButtonTapSubject)
      .disposed(by: disposeBag)
  }
}
