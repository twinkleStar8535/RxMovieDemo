//
//  MovieDescriptionView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import UIKit

class MovieDescriptionView: UIView {

    lazy var topDivider =  UIView()

    lazy var titleLabel :UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.minimumScaleFactor = 10
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    lazy var contentLabel :UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    lazy var stackView : UIStackView = {
        let stackview = UIStackView()
        stackview.addArrangedSubview(titleLabel)
        stackview.addArrangedSubview(contentLabel)
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 3
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return stackview
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTheme()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        topDivider.backgroundColor = .gray

        self.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Add Divider Line
        self.addSubview(topDivider)

        topDivider.snp.makeConstraints { make in
            make.height.equalTo(0.4)
            make.centerY.equalTo(self.snp.top)
            make.left.right.equalToSuperview()
        }
    }
}



extension MovieDescriptionView:ThemeChangeDelegate {
    func setupTheme() {
        self.titleLabel.theme.textColor = themeService.attribute {$0.textColor}
    }
}

