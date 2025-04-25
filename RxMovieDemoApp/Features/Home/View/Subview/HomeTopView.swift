//
//  HomeTopView.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/6.
//

import UIKit


class HomeTopView: UIView {

    var didLatterRightBtn:(()->())?

    var didFormerRightBtn:(()->())?

    var logoImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    var rightBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "person"), for: .normal)
        return btn
    }()

    var rightBtnNo2: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "play.rectangle"), for: .normal)
        return btn
    }()



    // MARK: - Autolayout

    private func autoLayout() {
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        logoImgView.topAnchor.constraint(equalTo: self.topAnchor,constant : 10).isActive = true
        logoImgView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 10).isActive = true
        logoImgView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        logoImgView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        rightBtn.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.centerYAnchor.constraint(equalTo: logoImgView.centerYAnchor).isActive = true
        rightBtn.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true

        rightBtnNo2.translatesAutoresizingMaskIntoConstraints = false
        rightBtnNo2.centerYAnchor.constraint(equalTo: logoImgView.centerYAnchor).isActive = true
        rightBtnNo2.rightAnchor.constraint(equalTo: rightBtn.leftAnchor,constant: -10).isActive = true
    }



    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(logoImgView)
        addSubview(rightBtn)
        addSubview(rightBtnNo2)
        rightBtn.addTarget(self, action: #selector(handleRightBtn), for: .touchUpInside)
        rightBtnNo2.addTarget(self, action: #selector(handleRightBtnNo2), for: .touchUpInside)
        setupTheme()
    }

    override func layoutSubviews() {
        autoLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    @objc func handleRightBtn() {
        didLatterRightBtn?()
    }

    @objc func handleRightBtnNo2() {
        didFormerRightBtn?()
    }
}



extension HomeTopView:ThemeChangeDelegate {
    func setupTheme() {
        self.theme.backgroundColor = themeService.attribute {$0.backgroundColor}
        self.rightBtn.theme.tintColor = themeService.attribute {$0.textColor}
        self.rightBtnNo2.theme.tintColor = themeService.attribute {$0.textColor}
    }
}
