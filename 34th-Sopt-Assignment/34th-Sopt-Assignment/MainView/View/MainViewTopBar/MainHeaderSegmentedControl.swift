//
//  MainHeaderView.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/22/24.
//

import UIKit
import SnapKit

struct UnderbarInfo {
  var height: CGFloat
  var barColor: UIColor
  var backgroundColor: UIColor
}

final class MainHeaderSegmentedControl: UISegmentedControl {
    // MARK: - Properties    
    private lazy var underbar: UIView = makeUnderbar()
    private lazy var underbarWidth: CGFloat? = bounds.size.width / CGFloat(numberOfSegments)
    private var underbarInfo: UnderbarInfo
    private var isFirstSettingDone = false
    
    // MARK: - init
    init(items: [Any]?, underbarInfo info: UnderbarInfo) {
        self.underbarInfo = info
        super.init(items: items)
        setLayout()
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetLayout
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstSettingDone {
            isFirstSettingDone.toggle()
            setUnderbarMovableBackgroundLayer()
            layer.cornerRadius = 0
            layer.masksToBounds = false
        }
        let underBarLeadingSpacing = CGFloat(selectedSegmentIndex) * (underbarWidth ?? 50)
        UIView.animate(
            withDuration: 0.27,
            delay: 0,
            options: .curveEaseOut,
            animations: {
            self.underbar.transform = .init(translationX: underBarLeadingSpacing, y: 0)
        })
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        removeBorders()
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.pretendard(to: .medium, size: 12)
        ]
        setTitleTextAttributes(textAttributes, for: .normal)
        setTitleTextAttributes(textAttributes, for: .selected)
        selectedSegmentTintColor = .clear
    }
    
    private func setUnderbarMovableBackgroundLayer() {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = .init(
            x: 0,
            y: bounds.height - underbarInfo.height,
            width: bounds.width,
            height: underbarInfo.height)
        backgroundLayer.backgroundColor = underbarInfo.backgroundColor.cgColor
        layer.addSublayer(backgroundLayer)
    }
    

    
    private func makeUnderbar() -> UIView {
        return {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = underbarInfo.barColor
            addSubview($0)
            $0.snp.makeConstraints {
                $0.leading.bottom.equalToSuperview()
                $0.width.equalTo(underbarWidth ?? 50)
                $0.height.equalTo(underbarInfo.height)
            }
            return $0
        }(UIView(frame: .zero))
    }
    
    private func removeBorders() {
        let image = UIImage()
        setBackgroundImage(
            image,
            for: .normal,
            barMetrics: .default)
        setBackgroundImage(
            image,
            for: .selected,
            barMetrics: .default)
        setBackgroundImage(
            image,
            for: .highlighted,
            barMetrics: .default)
        setDividerImage(
            image,
            forLeftSegmentState: .normal,
            rightSegmentState: .normal,
            barMetrics: .default)
    }
}
