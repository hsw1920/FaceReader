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
    
    private let titleLabel1 = UILabel()
    private let titleLabel2 = UILabel()
    private let titleLabel3 = UILabel()
    private let imageView = UIImageView()
    let textView = UITextView()
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
        self.navigationController?.isNavigationBarHidden = true
        
        titleLabel1.do {
            $0.text = "당신"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textAlignment = .center
        }
        titleLabel2.do {
            $0.text = "과 닮은 연예인"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 3)
            $0.textAlignment = .center
        }
        titleLabel3.do {
            $0.text = "의 관상"
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
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 16)
            $0.textAlignment = .center
            $0.isScrollEnabled = true
            $0.isEditable = false
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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
        [titleLabel1, titleLabel2, titleLabel3, imageView, textView, backButton].forEach { view.addSubview($0)
        }
        
        titleLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(91)
            $0.leading.equalToSuperview().inset(120)
        }
        titleLabel2.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel1)
            $0.leading.equalTo(titleLabel1.snp.trailing)
        }
        titleLabel3.snp.makeConstraints {
            $0.top.equalTo(titleLabel1)
            $0.leading.equalTo(titleLabel2.snp.trailing)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel1.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
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
