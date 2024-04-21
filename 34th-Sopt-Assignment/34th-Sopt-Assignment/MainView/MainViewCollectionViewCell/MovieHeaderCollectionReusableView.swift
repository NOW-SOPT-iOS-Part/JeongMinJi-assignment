//
//  MovieHeaderCollectionReusableView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/21/24.
//

import UIKit

final class MovieHeaderCollectionReusableView: UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "MovieHeaderCollectionReusableView"
    
    var viewAllTapped: (() -> Void)?
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .pretendard(to: .semiBold, size: 15)
        label.text = "티빙에서 꼭 봐야하는 콘텐츠"
        return label
    }()
    
    private lazy var viewAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.gray3, for: .normal)
        button.titleLabel?.font = .pretendard(to: .medium, size: 11)
        button.addTarget(self, action: #selector(viewAllButtonDidTap), for: .touchUpInside)
        
        let arrowImage = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImage.tintColor = .gray3
        arrowImage.frame = CGRect(x: button.titleLabel!.frame.maxX+40, y: button.titleLabel!.frame.maxY-6, width: 8, height: 10)
        button.addSubview(arrowImage)
        button.addTarget(self, action: #selector(viewAllButtonDidTap), for: .touchUpInside)

        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        [headerTitleLabel, viewAllButton].forEach {
            self.addSubview($0)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            
        }
        viewAllButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.bottom.equalTo(headerTitleLabel.snp.bottom)
            $0.trailing.equalToSuperview().inset(15)
        }
        
    }
    
    // MARK: - Action
    @objc private func viewAllButtonDidTap() {
        viewAllTapped?()
    }
}

extension MovieHeaderCollectionReusableView {
    func dataBind(_ title: String, sectionType: MainViewSection) {
        headerTitleLabel.text = title
        
        viewAllTapped = { [weak self] in
            
            
            switch sectionType {
            case .bigMoviePoster: break
            case .recommendInTiving:
                self?.navigateToRecommendInTiving()
            case .popularLiveChannel:
                self?.navigateToPopularLiveChannel()
            case .popularSeries:
                self?.navigateToPopularSeries()
            case .mysteriousMovie:
                self?.navigateToMysteriousMovie()
            }
        }
    }
    
    // 전체 보기 화면 구성이 모두 같고 데이터만 다른 경우 하나로 통일 가능
    private func navigateToRecommendInTiving() {
        print("티빙에서 꼭 봐야하는 콘텐츠 전체보기")
    }
    
    private func navigateToPopularLiveChannel() {
        print("인기 LIVE 채널 전체보기")
    }
    
    private func navigateToPopularSeries() {
        print("1화 무료! 파라마운트+ 인기 시리즈 전체보기")
    }
    
    private func navigateToMysteriousMovie() {
        print("마술보다 더 신비로운 영화(신비로운 영화사전님) 전체보기")
    }
}
