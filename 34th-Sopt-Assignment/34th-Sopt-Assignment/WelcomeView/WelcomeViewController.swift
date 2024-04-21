//
//  WelcomeViewController.swift
//  34th-Sopt-Assignment
//
//  Created by 정민지 on 4/15/24.
//


import Foundation
import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    // MARK: - Properties
    var id: String?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .tvingLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "???님\n반가워요!"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .pretendard(to: .bold, size: 23)
        return label
    }()
    
    
    private lazy var goMainButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red1
        button.setTitle("메인으로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(to: .semiBold, size: 14)
        button.addTarget(self, action: #selector(goMainButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = 3
        return button
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setLayout()
        bindID()
    }
    
    // MARK: - SetLayout
    private func setLayout() {
        [logoImageView, welcomeLabel, goMainButton].forEach {
            self.view.addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(58)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(210.94)
        }
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(67.06)
            $0.leading.trailing.equalToSuperview().inset(65)
        }
        goMainButton.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-66)
        }
    }
    
    // MARK: - Action
    @objc private func goMainButtonDidTap() {
        let MainViewController = MainViewController()
    
        self.navigationController?.pushViewController(MainViewController, animated: true)
    }
    private func bindID() {
        guard let idText = id else { return }
        self.welcomeLabel.text = "\(idText)님 \n반가워요!"
    }
    func setLabelText(id: String?) {
        self.id = id
    }
}
