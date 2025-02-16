//
//  MainViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    // MARK: - Properties
    var mainLogoHeaderView = MainLogoHeaderView()
    private var mainHeaderSegmentedControl: MainHeaderSegmentedControl!
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    private var stackView = UIStackView()
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init())
    private var mainStickyHeaderViewTopConstraint = NSLayoutConstraint()
    private var scrollViewTopConstraint = NSLayoutConstraint()
    private var mainTableViewHeightConstraint = NSLayoutConstraint()
    
    // ViewModel
    private let liveViewModel = LiveViewModel()
    private let disposeBag = DisposeBag()
    
    // Data Sources
    private var poseterData = PosterModel.dummy()
    private var movieData = MovieModel.dummy()
    private var liveData = [DailyBoxOfficeList]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = .black
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        setSegmentedControlLayout()
        setLayout()
        setupCollectionView()
        setupBinding()
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        view.addSubview(mainHeaderSegmentedControl)
        view.addSubview(mainLogoHeaderView)
        
        mainLogoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(59)
        }
        mainHeaderSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(mainLogoHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.bottom.equalTo(scrollView)
            $0.height.equalTo(calculateCellHeight())
        }
    }
    private func setSegmentedControlLayout() {
        let items = ["홈", "실시간", "TV프로그램", "영화", "파라마운트+"]
        let underbarInfo = UnderbarInfo(height: 3.0, barColor: .white, backgroundColor: .clear)
        
        
        mainHeaderSegmentedControl = MainHeaderSegmentedControl(items: items, underbarInfo: underbarInfo)
    }
    
    // MARK: - SetBinding
    private func setupBinding() {
        let yesterdayDate = yesterdayDateFormattedKST()
        let trigger = Observable.just(BoxOfficeResult(date: yesterdayDate, itemsPerPage: 6, multiMovieYn: "Y", repNationCd: "K"))
        
        let input = LiveViewModel.Input(getDailyBoxOfficeTrigger: trigger)
        let output = liveViewModel.transform(input)
        
        output.dailyBoxOffice
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                self?.liveData = data
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    
    //MARK: -Helpers
    private func calculateCellHeight() -> CGFloat {
        let sectionSpacing: CGFloat = 22
        let widthFraction = view.bounds.width
        let heightMultiplier = CGFloat(498.0 / 375.0)
        let bigPosterCellHeight: CGFloat = widthFraction * heightMultiplier
        let movieCellHeight: CGFloat = 163
        let headerCellHeight: CGFloat = 36
        let footerCellHeight: CGFloat = 148
        let liveCellHeight: CGFloat = 134
        
        return bigPosterCellHeight + movieCellHeight * 3 + liveCellHeight + headerCellHeight * 4 + sectionSpacing * 4 + footerCellHeight * 2
    }
    
    private func setupCollectionView() {
        collectionView.register(
            BigPosterCollectionViewCell.self,
            forCellWithReuseIdentifier: BigPosterCollectionViewCell.className)
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.className)
        collectionView.register(
            LiveCollectionViewCell.self,
            forCellWithReuseIdentifier: LiveCollectionViewCell.className)
        
        collectionView.register(
            MovieHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieHeaderCollectionReusableView.className)
        
        collectionView.register(
            BigPosterCollectionViewReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: BigPosterCollectionViewReusableView.className)
        collectionView.register(
            MovieFooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MovieFooterCollectionReusableView.className)
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 22
        return UICollectionViewCompositionalLayout(
            sectionProvider: { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                guard let section = MainViewSection(rawValue: sectionIndex) else { return nil }
                switch section {
                case .bigMoviePoster:
                    return self?.createBigPosterSection()
                case .recommendInTiving, .popularSeries, .mysteriousMovie:
                    return self?.createMovieSection(for: section)
                case .popularLiveChannel:
                    return self?.createLiveSection()
                }
            }, configuration: config)
    }
    private func createBigPosterSection() -> NSCollectionLayoutSection {
        let widthFraction = CGFloat(1.0)
        let heightMultiplier = CGFloat(498.0 / 375.0)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(widthFraction * heightMultiplier))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(36))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    private func createMovieSection(for sectionType: MainViewSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(98),
            heightDimension: .absolute(163))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(148))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        if sectionType == .popularSeries {
            section.boundarySupplementaryItems = [header, footer]
        } else {
            section.boundarySupplementaryItems = [header]
        }
        return section
    }
    private func createLiveSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(134))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(134))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 7
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}


//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return poseterData.count
        case 1, 3, 4:
            return movieData.count
        case 2:
            return liveData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BigPosterCollectionViewCell.className,
                for: indexPath) as? BigPosterCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1, 3, 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.className,
                for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(movieData[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveCollectionViewCell.className,
                for: indexPath) as! LiveCollectionViewCell
            cell.dataBind(liveData[indexPath.item], index: indexPath.item + 1)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionType = MainViewSection(rawValue: indexPath.section)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let sectionType = sectionType,
                  let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MovieHeaderCollectionReusableView.className,
                    for: indexPath) as? MovieHeaderCollectionReusableView else {
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
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: BigPosterCollectionViewReusableView.className,
                    for: indexPath) as? BigPosterCollectionViewReusableView else {
                        return UICollectionReusableView()
                    }
                footerView.delegate = self
                footerView.pageControl.numberOfPages = poseterData.count
                footerView.pageControl.currentPage = Int(collectionView.contentOffset.x / collectionView.frame.width)
                return footerView
                
            case .popularSeries:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MovieFooterCollectionReusableView.className,
                    for: indexPath) as? MovieFooterCollectionReusableView else {
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
        if scrollView == self.scrollView {
            updateLogoAndHeaderPosition(scrollView)
        }
    }

    private func updateLogoAndHeaderPosition(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        UIView.animate(withDuration: 0.3) {
            if scrollOffset >= 59 {
                self.mainHeaderSegmentedControl.snp.remakeConstraints { make in
                    make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(41)
                }
                self.mainLogoHeaderView.alpha = 0
            } else {
                self.mainHeaderSegmentedControl.snp.remakeConstraints { make in
                    make.top.equalTo(self.mainLogoHeaderView.snp.bottom)
                    make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(41)
                }
                self.mainLogoHeaderView.alpha = 1
            }
            self.view.layoutIfNeeded()
        }
    }

    private func updatePageControlForBigPosterSection(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)

        if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: 0)) as? BigPosterCollectionViewReusableView {
            footerView.pageControl.currentPage = currentPage
        }
    }
}

extension MainViewController: BigPosterCollectionViewDelegate {
    func didChangePage(to index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension MainViewController {
    func yesterdayDateFormattedKST() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? calendar.timeZone

        let currentDate = Date()
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: currentDate) else { return 0 }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.dateFormat = "yyyyMMdd"

        return Int(dateFormatter.string(from: yesterday)) ?? 0
    }
}
