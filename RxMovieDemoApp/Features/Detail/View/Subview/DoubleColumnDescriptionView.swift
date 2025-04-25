//
//  DoubleColumnDescriptionView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import UIKit

class DoubleColumnDescriptionView: UIView {

    lazy var leftDescription = MovieDescriptionView()
    lazy var rightDescription = MovieDescriptionView()

    lazy var columnStack:UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(leftDescription)
        stackView.addArrangedSubview(rightDescription)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        addSubview(columnStack)

        columnStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


}
