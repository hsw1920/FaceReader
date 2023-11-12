//
//  ResultVC.swift
//  FaceReader
//
//  Created by 홍승완 on 2023/11/12.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class ResultVC: UIViewController {

    var selectedImage: UIImage?
    
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let textView = UIView()
    let textLabel = UILabel()
    private let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let selectedImage = selectedImage {
            imageView.image = selectedImage
        }
        
        setupAttribute()
        setupLayout()
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.text = "얼굴 선택"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textAlignment = .center
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 32
        }

        
        textView.do {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
        }
        
        textLabel.do {
            $0.numberOfLines = 0
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        backButton.do {
            $0.setTitle("메인으로 돌아가기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        [titleLabel, imageView, textView, backButton].forEach { view.addSubview($0)
        }
        textView.addSubview(textLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(91)
            $0.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        textLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(60)
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
