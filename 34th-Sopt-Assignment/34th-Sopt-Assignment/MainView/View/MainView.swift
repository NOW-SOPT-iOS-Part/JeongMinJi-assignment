//
//  MainView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 6/7/24.
//

import UIKit
import SnapKit

final class MainView: UIView {
    // MARK: - Properties
    var mainLogoHeaderView = MainLogoHeaderView()
    var mainHeaderSegmentedControl: MainHeaderSegmentedControl!
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var poseterData = [PosterModel]()
    var movieData = [MovieModel]()
    var liveData = [DailyBoxOfficeList]()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setSegmentedControlLayout()
        setLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setSegmentedControlLayout()
        setLayout()
    }
    
    // MARK: - Setup View
    private func setupView() {
        collectionView.register(BigPosterCollectionViewCell.self, forCellWithReuseIdentifier: BigPosterCollectionViewCell.className)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.className)
        collectionView.register(LiveCollectionViewCell.self, forCellWithReuseIdentifier: LiveCollectionViewCell.className)
        collectionView.register(MovieHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MovieHeaderCollectionReusableView.className)
        collectionView.register(BigPosterCollectionViewReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BigPosterCollectionViewReusableView.className)
        collectionView.register(MovieFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MovieFooterCollectionReusableView.className)
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .black
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        addSubview(scrollView)
        scrollView.addSubview(collectionView)
        addSubview(mainHeaderSegmentedControl)
        addSubview(mainLogoHeaderView)
        
        mainLogoHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
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
    
    // MARK: - Helpers
    private func calculateCellHeight() -> CGFloat {
        let sectionSpacing: CGFloat = 22
        let widthFraction = bounds.width
        let heightMultiplier = CGFloat(498.0 / 375.0)
        let bigPosterCellHeight: CGFloat = widthFraction * heightMultiplier
        let movieCellHeight: CGFloat = 163
        let headerCellHeight: CGFloat = 36
        let footerCellHeight: CGFloat = 148
        let liveCellHeight: CGFloat = 134
        
        return bigPosterCellHeight + movieCellHeight * 3 + liveCellHeight + headerCellHeight * 4 + sectionSpacing * 4 + footerCellHeight * 2
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(widthFraction * heightMultiplier))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
    
    private func createMovieSection(for sectionType: MainViewSection) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(98), heightDimension: .absolute(163))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(148))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        if sectionType == .popularSeries {
            section.boundarySupplementaryItems = [header, footer]
        } else {
            section.boundarySupplementaryItems = [header]
        }
        return section
    }
    
    private func createLiveSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(134))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(134))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 7
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(36))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
