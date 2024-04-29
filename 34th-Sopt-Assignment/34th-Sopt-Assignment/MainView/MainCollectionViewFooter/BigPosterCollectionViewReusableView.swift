//
//  BigPosterCollectionViewReusableView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/26/24.
//

import UIKit

final class BigPosterCollectionViewReusableView: UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "BigPosterCollectionViewReusableView"
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray3
        
        return pageControl
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
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().inset(14)
        }
    }
    
    // MARK: - Action
    func pageControlChanged(with numberOfPages: Int, currentPage: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
    }
}

