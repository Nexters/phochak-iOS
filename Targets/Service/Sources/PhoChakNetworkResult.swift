//
//  PhoChakNetworkResult.swift
//  Service
//
//  Created by 한상진 on 2023/02/10.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Foundation

public enum PhoChakNetworkResult: String, Error {
  case P000 = "P000"
  case P100 = "P100"
  case P200 = "P200"
  case P201 = "P201"
  case P202 = "P202"
  case P203 = "P203"
  case P204 = "P204"
  case P205 = "P205"
  case P300 = "P300"
  case P400 = "P400"
  case P410 = "P410"
  case P411 = "P411"
  case P412 = "P412"
  case P413 = "P413"
  case P414 = "P414"
  case P450 = "P450"

  public var description: String {
    switch self {
    case .P000: return "정상 처리"
    case .P100: return "서버 에러 발생"
    case .P200: return "요청 값이 올바르지 않습니다"
    case .P201: return "토큰을 찾을 수 없습니다"
    case .P202: return "올바르지 않은 토큰입니다"
    case .P203: return "만료된 토큰입니다"
    case .P204: return "올바르지 않은 Apple 토큰입니다"
    case .P205: return "지원하지 않는 Provider입니다"
    case .P300: return "존재하지 않는 유저입니다"
    case .P400: return "존재하지 않는 게시글입니다"
    case .P410: return "이미 포착된 게시글입니다"
    case .P411: return "포착하지 않은 게시글입니다"
    case .P412: return "최신순이 아닌 경우 정렬 기준의 값은 필수입니다"
    case .P413: return "지원하지 않는 정렬 기준입니다"
    case .P414: return "정렬 기준이 존재하지 않습니다"
    case .P450: return "지원하지 않는 비디오 확장자입니다"
    }
  }
}
