//
//  LiveModel.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import RxSwift
import RxCocoa
import Foundation

final class MainViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let boxofficeManager = BoxofficeManager.shared
    
    // MARK: - Input
    struct Input {
        let fetchTrigger: Observable<Void>
        let getDailyBoxOfficeTrigger: Observable<DailyBoxOfficeModel>
    }

    // MARK: - Output
    struct Output {
        let posterData: Driver<[PosterModel]>
        let movieData: Driver<[MovieModel]>
        let liveData: Driver<[DailyBoxOfficeList]>
    }
    
    // MARK: - Transform
    func transform(_ input: Input) -> Output {
        let posterData = input.fetchTrigger
            .flatMapLatest { _ in
                return Observable.just(PosterModel.dummy())
            }
            .asDriver(onErrorJustReturn: [])

        let movieData = input.fetchTrigger
            .flatMapLatest { _ in
                return Observable.just(MovieModel.dummy())
            }
            .asDriver(onErrorJustReturn: [])

        let dailyBoxOffice = input.getDailyBoxOfficeTrigger
            .flatMapLatest { [weak self] request -> Observable<[DailyBoxOfficeList]> in
                guard let self = self else { return Observable.just([]) }
                return self.getDailyBoxOffice(
                    targetDt: request.date,
                    itemPerPage: request.itemsPerPage,
                    multiMovieYn: request.multiMovieYn,
                    repNationCd: request.repNationCd
                ).catchAndReturn([])
            }
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: [])

        return Output(
            posterData: posterData,
            movieData: movieData,
            liveData: dailyBoxOffice
        )
    }

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
