//
//  SettingInteractor.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//



import Foundation
import RxSwift
import RxRelay
import LocalAuthentication
import UIKit

protocol SettingBusinessLogic {
    func fetchSettings(request: Setting.FetchSettings.Request)
    func handleAppLock(request: Setting.AppLock.Request)
    func handleAppLockValidation(request: Setting.AppLockValidation.Request)
    func handleTheme(request: Setting.Theme.Request)
}

protocol SettingDataStore {
    var appLockState: Bool { get set }
    var isLightMode: Bool { get set }
}

protocol SettingInteractorProtocol {
    func checkIfBioMetricsAvailable() -> Bool
    func getAppLockState() -> Bool
    func enableAppLock()
    func disableAppLock()
}

class SettingInteractor: SettingBusinessLogic, SettingDataStore, SettingInteractorProtocol {
    var presenter: SettingPresentationLogic?
    var appLockState: Bool = false
    var isLightMode: Bool = false
    private let disposeBag = DisposeBag()
    private let worker: SettingWorkerProtocol
    
    init(worker: SettingWorkerProtocol = SettingWorker()) {
        self.worker = worker
    }
    
    func checkIfBioMetricsAvailable() -> Bool {
        return worker.checkIfBioMetricsAvailable()
    }
    
    func getAppLockState() -> Bool {
        return worker.getAppLockState()
    }
    
    func enableAppLock() {
        worker.enableAppLock()
    }
    
    func disableAppLock() {
        worker.disableAppLock()
    }
    
    func fetchSettings(request: Setting.FetchSettings.Request) {
        let sections = [
            SettingSection(header: "App Settings", items: [
                .titleCellWithSwitch(title: "Authentication"),
                .titleCellInit(title: "Favorites"),
                .titleCellWithSwitch(title: "Light Mode")
            ])
        ]
        
        let response = Setting.FetchSettings.Response(sections: sections)
        presenter?.presentSettings(response: response)
    }
    
    func handleAppLock(request: Setting.AppLock.Request) {
        worker.setAppLockState(request.isEnabled)
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.appLockState = request.isEnabled
                    let response = Setting.AppLock.Response(isEnabled: request.isEnabled, error: nil)
                    self.presenter?.presentAppLockState(response: response)
                } else {
                    let response = Setting.AppLock.Response(isEnabled: self.appLockState, error: NSError(domain: "Setting", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to set app lock state"]))
                    self.presenter?.presentAppLockState(response: response)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handleAppLockValidation(request: Setting.AppLockValidation.Request) {
        worker.validateAppLock()
            .subscribe(onNext: { [weak self] success in
                guard let self = self else { return }
                let response = Setting.AppLockValidation.Response(isValid: success)
                self.presenter?.presentAppLockValidation(response: response)
            })
            .disposed(by: disposeBag)
    }
    
    func handleTheme(request: Setting.Theme.Request) {
        isLightMode = request.isLightMode
        let response = Setting.Theme.Response(isLightMode: request.isLightMode, error: nil)
        presenter?.presentTheme(response: response)
    }
} 
