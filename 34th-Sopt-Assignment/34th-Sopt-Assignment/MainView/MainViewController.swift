//
//  MainViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import Foundation
import UIKit

final class MainViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    private let contentsView = UIView()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .init())
    
    private var poseterData = PoseterModel.dummy() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var movieData = MovieModel.dummy() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var liveData = LiveModel.dummy() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        setLayout()
        setupCollectionView()
    }
    // MARK: - SetLayout
    
    private func setLayout() {
        self.view.addSubview(collectionView)
//        self.view.addSubview(scrollView)
//        scrollView.addSubview(contentsView)
//        contentsView.addSubview(collectionView)
//        
//        scrollView.snp.makeConstraints {
//           $0.edges.equalToSuperview()
//        }
//        contentsView.snp.makeConstraints {
//            $0.edges.equalTo(scrollView)
//        }
        collectionView.snp.makeConstraints {
//            $0.top.equalTo(contentsView.snp.top)
//            $0.bottom.equalTo(contentsView.snp.bottom)
//            $0.leading.trailing.equalToSuperview().inset(12)
//            $0.height.equalTo(800)
            $0.edges.equalToSuperview()
           
        }
    }
    // MARK: - Action
    
    //MARK: -Helpers
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            BigPosterCollectionViewCell.self,
            forCellWithReuseIdentifier: BigPosterCollectionViewCell.identifier)
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.register(
            LiveCollectionViewCell.self,
            forCellWithReuseIdentifier: LiveCollectionViewCell.identifier)
        
        collectionView.register(
            MovieHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieHeaderCollectionReusableView.identifier)
        collectionView.register(
            MovieFooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MovieFooterCollectionReusableView.identifier)

        
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.backgroundColor = .black
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
        
        section.boundarySupplementaryItems = [header]
        
        if sectionType == .popularSeries {
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(148))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom)
            
            section.boundarySupplementaryItems = [footer]
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


//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
                withReuseIdentifier: BigPosterCollectionViewCell.identifier,
                for: indexPath) as? BigPosterCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(poseterData[indexPath.item])
            return cell
        case 1, 3, 4:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCollectionViewCell.identifier,
                for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            cell.dataBind(movieData[indexPath.item])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LiveCollectionViewCell.identifier,
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
                    withReuseIdentifier: MovieHeaderCollectionReusableView.identifier,
                    for: indexPath) as? MovieHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            let title: String
            switch sectionType {
            case .recommendInTiving:
                title = "티빙에서 꼭 봐야하는 콘텐츠"
            case .popularLiveChannel:
                title = "인기 LIVE 채널"
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
            guard sectionType == .popularSeries, let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MovieFooterCollectionReusableView.identifier,
                for: indexPath) as? MovieFooterCollectionReusableView else {
                return UICollectionReusableView()
            }
            return footerView
            
        default:
            return UICollectionReusableView()
        }
    }
}
