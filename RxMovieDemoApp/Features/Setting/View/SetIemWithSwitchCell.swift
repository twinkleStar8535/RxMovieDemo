//
//  SetIemWithSwitchCell.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/25.
//
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SnapKit
import RxTheme

protocol SetItemWithSwitchCellDelegate: AnyObject {
    func toggleStatusDidChange(_ cell: SetItemWithSwitchCell, isOn: Bool)
}


class SetItemWithSwitchCell: UITableViewCell {

    weak var delegate: SetItemWithSwitchCellDelegate?

    private var itemImage = UIImageView()
    private let disposeBag = DisposeBag()

    var itemTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private var toggleSwitch = UISwitch()
    private let toggleStatusRelay = BehaviorRelay<Bool>(value: false)

    var toggleStatus: Observable<Bool> {
        return toggleStatusRelay.asObservable()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        toggleSwitch.rx.isOn
            .subscribe(onNext: { [weak self] isOn in
                self?.delegate?.toggleStatusDidChange(self!, isOn: isOn)
            })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSettingItems(itemName:String,isOn:Bool) {
        itemTitle.text = itemName
        toggleSwitch.isOn = isOn
    }

    private func setLayout() {
        contentView.addSubview(itemImage)
        contentView.addSubview(itemTitle)
        contentView.addSubview(toggleSwitch)

        itemImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(20)
        }

        toggleSwitch.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-40)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(20)
        }

        itemTitle.snp.makeConstraints { make in
            make.left.equalTo(itemImage).offset(20)
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalTo(toggleSwitch).offset(-30)
        }

    }


}
