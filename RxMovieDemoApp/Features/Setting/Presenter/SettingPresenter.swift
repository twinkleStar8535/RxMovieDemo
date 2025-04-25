//
//  SettingPresenter.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//



import Foundation
import RxSwift
import RxRelay

protocol SettingPresentationLogic: AnyObject {
    var settingItems: Observable<[SettingSection]> { get }
    var appLockState: Observable<Bool> { get }
    var appLockValidationResult: Observable<Bool> { get }
    
    func presentSettings(response: Setting.FetchSettings.Response)
    func presentAppLockState(response: Setting.AppLock.Response)
    func presentAppLockValidation(response: Setting.AppLockValidation.Response)
    func presentTheme(response: Setting.Theme.Response)
}

protocol SettingDisplayLogic: AnyObject {
    func displaySettings(viewModel: Setting.FetchSettings.ViewModel)
    func displayAppLockState(viewModel: Setting.AppLock.ViewModel)
    func displayAppLockValidation(viewModel: Setting.AppLockValidation.ViewModel)
    func displayTheme(viewModel: Setting.Theme.ViewModel)
    func displayError(message: String)
}

class SettingPresenter: SettingPresentationLogic {
    weak var viewController: SettingDisplayLogic?
    private let disposeBag = DisposeBag()
    
    private let settingItemsRelay = BehaviorRelay<[SettingSection]>(value: [])
    var settingItems: Observable<[SettingSection]> {
        return settingItemsRelay.asObservable()
    }
    
    private let appLockStateRelay = BehaviorRelay<Bool>(value: false)
    var appLockState: Observable<Bool> {
        return appLockStateRelay.asObservable()
    }
    
    private let appLockValidationResultRelay = BehaviorRelay<Bool>(value: false)
    var appLockValidationResult: Observable<Bool> {
        return appLockValidationResultRelay.asObservable()
    }
    
    func presentSettings(response: Setting.FetchSettings.Response) {
        let viewModel = Setting.FetchSettings.ViewModel(sections: response.sections)
        viewController?.displaySettings(viewModel: viewModel)
        settingItemsRelay.accept(response.sections)
    }
    
    func presentAppLockState(response: Setting.AppLock.Response) {
        let viewModel = Setting.AppLock.ViewModel(
            isEnabled: response.isEnabled,
            errorMessage: response.error?.localizedDescription
        )
        viewController?.displayAppLockState(viewModel: viewModel)
        appLockStateRelay.accept(response.isEnabled)
    }
    
    func presentAppLockValidation(response: Setting.AppLockValidation.Response) {
        let viewModel = Setting.AppLockValidation.ViewModel(isValid: response.isValid)
        viewController?.displayAppLockValidation(viewModel: viewModel)
        appLockValidationResultRelay.accept(response.isValid)
    }
    
    func presentTheme(response: Setting.Theme.Response) {
        let viewModel = Setting.Theme.ViewModel(
            isLightMode: response.isLightMode,
            errorMessage: response.error?.localizedDescription
        )
        viewController?.displayTheme(viewModel: viewModel)
    }
}
