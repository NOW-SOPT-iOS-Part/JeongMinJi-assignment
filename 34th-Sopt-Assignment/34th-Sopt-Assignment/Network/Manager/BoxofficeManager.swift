//
//  BoxofficeManager.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 5/10/24.
//

import Foundation
import Moya

final class BoxofficeManager {
    typealias API = BoxofficeAPI
    
    static let shared = BoxofficeManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: -일별 박스 오피스 조회 API
    func getDailyBoxOffice(
        key: String,
        targetDt: Int,
        itemPerPage: Int,
        multiMovieYn: String,
        repNationCd: String,
        completion: @escaping (Result<GetDailyBoxOfficeDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getDailyBoxOffice(
            key: key,
            targetDt: targetDt,
            itemPerPage: itemPerPage,
            multiMovieYn: multiMovieYn,
            repNationCd: repNationCd
        )) { result in
            switch result {
            case .success(let response):
              do {
                let decodedResponse = try JSONDecoder().decode(GetDailyBoxOfficeDTO.self, from: response.data)
                completion(.success(decodedResponse))
              } catch {
                completion(.failure(MoyaError.underlying(error, response)))
              }
            case .failure(let error):
              completion(.failure(error))
            }
        }
    }
}
