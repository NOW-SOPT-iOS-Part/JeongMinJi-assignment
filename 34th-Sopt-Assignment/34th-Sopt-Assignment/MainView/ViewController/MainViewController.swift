//
//  MainViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    // MARK: - Properties
    private var mainView: MainView!
    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinding()
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainView = MainView(frame: view.bounds)
        view.addSubview(mainView)
        mainView.scrollView.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    
    // MARK: - SetBinding
    private func setupBinding() {
        let yesterdayDate = DateUtils.yesterdayDateFormattedKST()
        let fetchTrigger = Observable.just(())
        let getDailyBoxOfficeTrigger = Observable.just(DailyBoxOfficeModel(date: yesterdayDate, itemsPerPage: 6, multiMovieYn: "Y", repNationCd: "K"))
        
        let input = MainViewModel.Input(fetchTrigger: fetchTrigger, getDailyBoxOfficeTrigger: getDailyBoxOfficeTrigger)
        let output = viewModel.transform(input)
        
        output.posterData
            .drive(onNext: { [weak self] data in
                self?.mainView.poseterData = data
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.movieData
            .drive(onNext: { [weak self] data in
                self?.mainView.movieData = data
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.liveData
            .drive(onNext: { [weak self] data in
                self?.mainView.liveData = data
                self?.mainView.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainView.poseterData.count
        case 1, 3, 4:
            return mainView.movieData.count
        case 2:
            return mainView.liveData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigPosterCollectionViewCell.className, for: indexPath) as? BigPosterCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1, 3, 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.className, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(mainView.movieData[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveCollectionViewCell.className, for: indexPath) as! LiveCollectionViewCell
            cell.dataBind(mainView.liveData[indexPath.item], index: indexPath.item + 1)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = MainViewSection(rawValue: indexPath.section)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let sectionType = sectionType,
                  let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieHeaderCollectionReusableView.className, for: indexPath) as? MovieHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            let title: String
            switch sectionType {
            case .recommendInTiving:
                title = "티빙에서 꼭 봐야하는 콘텐츠"
            case .popularLiveChannel:
                title = "어제 인기 박스오피스"
            case .popularSeries:
                title = "1화 무료! 파라마운트+ 인기 시리즈"
            case .mysteriousMovie:
                title = "마술보다 더 신비로운 영화(신비로운 영화사전님)"
            default:
                return UICollectionReusableView()
            }
            headerView.dataBind(title, sectionType: sectionType)
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            switch MainViewSection(rawValue: indexPath.section) {
            case .bigMoviePoster:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BigPosterCollectionViewReusableView.className, for: indexPath) as? BigPosterCollectionViewReusableView else {
                    return UICollectionReusableView()
                }
                footerView.delegate = self
                footerView.pageControl.numberOfPages = mainView.poseterData.count
                footerView.pageControl.currentPage = Int(collectionView.contentOffset.x / collectionView.frame.width)
                return footerView
                
            case .popularSeries:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieFooterCollectionReusableView.className, for: indexPath) as? MovieFooterCollectionReusableView else {
                    return UICollectionReusableView()
                }
                return footerView
                
            default:
                return UICollectionReusableView()
            }
            
        default:
            return UICollectionReusableView()
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainView.scrollView {
            updateLogoAndHeaderPosition(scrollView)
        } else if scrollView == mainView.collectionView {
            updatePageControlForBigPosterSection(scrollView)
        }
    }

    private func updateLogoAndHeaderPosition(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        UIView.animate(withDuration: 0.3) {
            if scrollOffset >= 59 {
                self.mainView.mainHeaderSegmentedControl.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(41)
                }
                self.mainView.mainLogoHeaderView.alpha = 0
            } else {
                self.mainView.mainHeaderSegmentedControl.snp.remakeConstraints { make in
                    make.top.equalTo(self.mainView.mainLogoHeaderView.snp.bottom)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(41)
                }
                self.mainView.mainLogoHeaderView.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
    }

    private func updatePageControlForBigPosterSection(_ scrollView: UIScrollView) {
        let pageWidth = mainView.collectionView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)

        if let footerView = mainView.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0)) as? BigPosterCollectionViewReusableView {
            footerView.updatePageControl(currentPage: currentPage)
        }
    }
}

extension MainViewController: BigPosterCollectionViewDelegate {
    func didChangePage(to index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        mainView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
