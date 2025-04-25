//
//  SetItemWithImgCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/1.
//

import UIKit
import SnapKit
import RxTheme

class SetItemWithImgCell: UITableViewCell {

    var itemTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white.withAlphaComponent(0.5)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setSettingItems(itemName:String){
        itemTitle.text = itemName
    }


    private func setLayout() {

        contentView.addSubview(itemTitle)

        itemTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().offset(-25)
        }

    }
}
