//
//  NetworkError.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/9/24.
//

import Foundation
import Moya

enum NetworkError: Int {
    case invalidRequest = 400
    case serverError    = 500
}

struct HandleNetworkError {
    static func handleNetworkError(_ error: Error) {
        if let moyaError = error as? MoyaError {
            if let statusCode = moyaError.response?.statusCode {
                let networkError = NetworkError(rawValue: statusCode)
                switch networkError {
                case .invalidRequest:
                    print("잘못된 요청입니다.")
                default:
                    print("서버 에러, 관리자에게 문의하세요.")
                }
            }
        }
    }
}
