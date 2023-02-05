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

final class DetailPostCell: BaseCollectionViewCell, View {

  // MARK: Properties
  typealias Section = RxCollectionViewSectionedAnimatedDataSource<HashTagSection>

  private let videoPlayerView: VideoPlayerView = .init()
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

  override func setupLayoutConstraints() {
    videoPlayerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    hashTagListView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-15)
      $0.height.equalToSuperview().multipliedBy(0.18)
    }

    firstGradientView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(hashTagListView)
      $0.bottom.equalToSuperview()
    }

    secondGradeintView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.44)
      $0.bottom.equalToSuperview()
    }
    let firstGradient = CAGradientLayer().then {
      $0.frame = .init(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height * 0.2)
      $0.locations = [0.0, 1.0]
      $0.colors = [
        UIColor.createColor(.monoGray, .w950, alpha: 0.0).cgColor,
        UIColor.createColor(.monoGray, .w950, alpha: 0.9).cgColor
      ]
    }
    firstGradientView.layer.insertSublayer(firstGradient, at: 0)


    let secondGradient = CAGradientLayer().then {
      $0.frame = .init(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height * 0.47)
      $0.locations = [0.0, 1.0]
      $0.colors = [
        UIColor.createColor(.monoGray, .w950, alpha: 0.0).cgColor,
        UIColor.createColor(.monoGray, .w950, alpha: 0.8).cgColor
      ]
    }
    secondGradeintView.layer.insertSublayer(secondGradient, at: 0)
  }

  // MARK: Methods
  func configure(reactor: DetailPostCellReactor) {
    self.reactor = reactor

    let playerItem: AVPlayerItem = .init(url: reactor.videoPost.shorts.shortsURL)
    
    videoPlayerView.player = .init(playerItem: playerItem)
    videoPlayerView.player?.play()
    videoPlayerView.player?.isMuted = true
  }

  func bind(reactor: DetailPostCellReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)

    hashTagListView.exclameButtonTap
      .subscribe(exclameButtonTapSubject)
      .disposed(by: disposeBag)

    hashTagListView.likeButtonTap
      .subscribe(likeButtonTapSubject)
      .disposed(by: disposeBag)
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
}
