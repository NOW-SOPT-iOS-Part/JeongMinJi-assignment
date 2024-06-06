//
//  LiveModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import RxSwift
import Foundation

struct BoxOfficeResult {
    let date: Int
    let itemsPerPage: Int
    let multiMovieYn: String
    let repNationCd: String
}

class LiveViewModel {
    private let disposeBag = DisposeBag()
    private let boxofficeManager = BoxofficeManager.shared
    
    // MARK: - Input
    struct Input {
        let getDailyBoxOfficeTrigger: Observable<BoxOfficeResult>
    }
    
    // MARK: - Output
    struct Output {
        let dailyBoxOffice: Observable<[DailyBoxOfficeList]>
    }
    
    // MARK: - Transformation
    func transform(_ input: Input) -> Output {
        let dailyBoxOffice = input.getDailyBoxOfficeTrigger
            .flatMapLatest { [weak self] request -> Observable<[DailyBoxOfficeList]> in
                guard let self = self else { return Observable.just([]) }
                return self.getDailyBoxOffice(
                    targetDt: request.date,
                    itemPerPage: request.itemsPerPage,
                    multiMovieYn: request.multiMovieYn,
                    repNationCd: request.repNationCd
                ).catchAndReturn([])
            }.observe(on: MainScheduler.instance)
        
        return Output(dailyBoxOffice: dailyBoxOffice)
    }
    
    // MARK: - API
    private func getDailyBoxOffice(targetDt: Int, itemPerPage: Int, multiMovieYn: String, repNationCd: String) -> Observable<[DailyBoxOfficeList]> {
        return Observable.create { observer in
            self.boxofficeManager.getDailyBoxOffice(key: "\(PrivacyInfoManager.moviekey)", targetDt: targetDt, itemPerPage: itemPerPage, multiMovieYn: multiMovieYn, repNationCd: repNationCd) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response.boxOfficeResult.dailyBoxOfficeList ?? [])
                    observer.onCompleted()
                case .failure(_):
                    observer.onError(NSError(domain: "API Error", code: -1, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
