//
//  IconLabelView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/20.
//

import UIKit
import SnapKit

class IconLabelView: UIView {

    lazy var icon : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()

    lazy var itemLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()


    lazy var stack : UIStackView = {
        let stackview = UIStackView()
        stackview.addArrangedSubview(icon)
        stackview.addArrangedSubview(itemLabel)
        icon.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.width.equalTo(icon.snp.height)
        }
        stackview.axis = .horizontal
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 3
        return stackview
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
      self.addSubview(stack)

      stack.snp.makeConstraints { make in
          make.edges.equalToSuperview()
      }
    }
}
