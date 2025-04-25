//
//  SettingsViewController.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources
import LocalAuthentication
import JGProgressHUD
import RxTheme

class SettingsViewController: UIViewController, SettingDisplayLogic {
    private let disposeBag = DisposeBag()
    private var interactor: SettingBusinessLogic!
    private var presenter: SettingPresentationLogic!
    private var router: SettingRouterProtocol!
    
    private let hud: JGProgressHUD = {
        let hud = JGProgressHUD()
        return hud
    }()
    
    private var iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppIcon")
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Demo Name"
        label.textColor = .white
        label.font = .systemFont(ofSize: 19, weight: .medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let settingView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SetItemWithImgCell.self, forCellReuseIdentifier: "SetItemWithImgCell")
        tableView.register(SetItemWithSwitchCell.self, forCellReuseIdentifier: "SetItemWithSwitchCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var aboutView: MovieDescriptionView = {
        let overallView = MovieDescriptionView()
        overallView.titleLabel.text = "Tech Stack"
        overallView.titleLabel.theme.textColor = themeService.attribute { $0.textColor }
        overallView.contentLabel.text = """
                                  - RxSwift / RxTheme / RxDataSource
                                  - VIP pattern (Clean Swift)
                                  - Snapkit / Alamofire / Kingfisher
                                  - Compositional Layout
                                  - LAContext (Face Authentication)
                                  """
        return overallView
    }()
    
    lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "MIT License | Copyright (c) 2024 YcLin"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.theme.textColor = themeService.attribute { $0.textColor }
        return label
    }()
    
    private var settingViewDataSource: RxTableViewSectionedReloadDataSource<SettingSection>?
    private var saveSelectPath: [Int] = []
    private let saveSelectpathKey = "SelectPathKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVIP()
        setLayout()
        setupBindings()
        setupTheme()
        
        // 初始化時獲取設置
        interactor.fetchSettings(request: Setting.FetchSettings.Request())
    }
    
    // MARK: - Setup
    private func setupVIP() {
        let worker = SettingWorker()
        let interactor = SettingInteractor(worker: worker)
        let presenter = SettingPresenter()
        let router = SettingRouter(viewController: self)
        
        interactor.presenter = presenter
        presenter.viewController = self
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
    }
    
    private func setLayout() {
        settingView.rx.setDelegate(self).disposed(by: disposeBag)
        
        view.addSubview(iconView)
        view.addSubview(nameLabel)
        view.addSubview(settingView)
        view.addSubview(aboutView)
        view.addSubview(copyrightLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(90)
            make.height.equalTo(90)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        settingView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.33)
        }
        
        copyrightLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.left.right.equalToSuperview()
        }
        
        aboutView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.bottom.equalTo(copyrightLabel.snp.top).inset(30)
        }
    }
    
    private func setupBindings() {
        settingViewDataSource = createDataSource()
        
        if let dataSource = settingViewDataSource {
            presenter.settingItems
                .observe(on: MainScheduler.instance)
                .bind(to: settingView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
        
        settingView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.handleCellSelection(at: indexPath)
            })
            .disposed(by: disposeBag)
    }
    
    private func createDataSource() -> RxTableViewSectionedReloadDataSource<SettingSection> {
        return RxTableViewSectionedReloadDataSource<SettingSection>(
            configureCell: { [weak self] (_, tableView, indexPath, item) -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                
                switch item {
                case .titleCellInit(let title):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SetItemWithImgCell", for: indexPath) as! SetItemWithImgCell
                    cell.theme.backgroundColor = themeService.attribute { $0.tableViewThemeColor }
                    cell.selectionStyle = .none
                    cell.itemTitle.theme.textColor = themeService.attribute { $0.textColor }
                    cell.setSettingItems(itemName: title)
                    return cell
                    
                case .titleCellWithSwitch(let title):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SetItemWithSwitchCell", for: indexPath) as! SetItemWithSwitchCell
                    cell.theme.backgroundColor = themeService.attribute { $0.tableViewThemeColor }
                    cell.delegate = self
                    
                    if let savedIndices = UserDefaults.standard.array(forKey: self.saveSelectpathKey) as? [Int] {
                        self.saveSelectPath = savedIndices
                    }
                    
                    let isOn = self.saveSelectPath.contains(indexPath.row)
                    cell.setSettingItems(itemName: title, isOn: isOn)
                    cell.itemTitle.theme.textColor = themeService.attribute { $0.textColor }
                    cell.selectionStyle = .none
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
            }
        )
    }
    
    // MARK: - SettingDisplayLogic
    func displaySettings(viewModel: Setting.FetchSettings.ViewModel) {
        // 更新 UI
    }
    
    func displayAppLockState(viewModel: Setting.AppLock.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            displayError(message: errorMessage)
        } else {
            updateAppLockState(viewModel.isEnabled)
        }
    }
    
    func displayAppLockValidation(viewModel: Setting.AppLockValidation.ViewModel) {
        if !viewModel.isValid {
            showAppLockError()
        }
    }
    
    func displayTheme(viewModel: Setting.Theme.ViewModel) {
        
        if viewModel.isLightMode {
            themeService.switch(.light)
            selectedTheme = .light
        } else {
            themeService.switch(.dark)
            selectedTheme = .dark
        }
        
        if let errorMessage = viewModel.errorMessage {
            displayError(message: errorMessage)
        }
    }
    
    func displayError(message: String) {
        hud.textLabel.text = message
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateAppLockState(_ isEnabled: Bool) {
        if let cell = settingView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetItemWithSwitchCell {
            cell.setSettingItems(itemName: "Authentication", isOn: isEnabled)
        }
    }
    
    private func showAppLockError() {
        displayError(message: "Authentication Failed")
    }
    
    private func handleCellSelection(at indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            router.navigateToFavorites()
        default:
            break
        }
    }
    
    private func appendNeedSavePath(index: Int) {
        if !saveSelectPath.contains(index) {
            saveSelectPath.append(index)
        }
    }
    
    private func removeSelectedPath(index: Int) {
        if let index = saveSelectPath.firstIndex(of: index) {
            saveSelectPath.remove(at: index)
        }
    }
    
    private func saveSelectedIndices() {
        UserDefaults.standard.set(saveSelectPath, forKey: saveSelectpathKey)
    }
    
    private func removeDuplicateIndices() {
        if let savedIndices = UserDefaults.standard.array(forKey: saveSelectpathKey) as? [Int] {
            let uniqueIndices = Set(savedIndices)
            let uniqueArray = Array(uniqueIndices)
            UserDefaults.standard.set(uniqueArray, forKey: saveSelectpathKey)
        }
    }
}

extension SettingsViewController: SetItemWithSwitchCellDelegate {
    func toggleStatusDidChange(_ cell: SetItemWithSwitchCell, isOn: Bool) {
        guard let indexPath = settingView.indexPath(for: cell) else { return }
        
        switch indexPath.row {
        case 0: // Authentication
            interactor.handleAppLock(request: Setting.AppLock.Request(isEnabled: isOn))
        case 2: // Light Mode
            interactor.handleTheme(request: Setting.Theme.Request(isLightMode: isOn))
        default:
            break
        }
        
        if isOn {
            appendNeedSavePath(index: indexPath.row)
        } else {
            removeSelectedPath(index: indexPath.row)
        }
        saveSelectedIndices()
        removeDuplicateIndices()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let titleLabel = UILabel()
        
        if let dataSource = settingViewDataSource {
            titleLabel.text = dataSource[section].header
        }
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.theme.textColor = themeService.attribute { $0.textColor }
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension SettingsViewController: ThemeChangeDelegate {
    func setupTheme() {
        view.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        settingView.theme.backgroundColor = themeService.attribute { $0.backgroundColor }
        nameLabel.theme.textColor = themeService.attribute { $0.textColor }
    }
}
