//
//  SettingWorker.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//


import Foundation
import LocalAuthentication
import UIKit
import RxSwift

protocol SettingWorkerProtocol {
    func checkIfBioMetricsAvailable() -> Bool
    func setAppLockState(_ isEnabled: Bool) -> Observable<Bool>
    func validateAppLock() -> Observable<Bool>
    func getAppLockState() -> Bool
    func enableAppLock()
    func disableAppLock()
}

class SettingWorker: SettingWorkerProtocol {
    private let disposeBag = DisposeBag()
    private var appBeingUnlocked: Bool = false
    private var enrollmentError: Bool = false
    
    func checkIfBioMetricsAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if let error = error {
            print(error.localizedDescription)
        }
        
        let isBiometricAvailable = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if isBiometricAvailable {
            enrollmentError = false
        } else {
            enrollmentError = true
        }
        
        return isBiometricAvailable
    }
    
    func setAppLockState(_ isEnabled: Bool) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let laContext = LAContext()
            
            if self.checkIfBioMetricsAvailable() {
                let reason = isEnabled ? 
                    "Provide Touch ID/Face ID to enable App Lock" : 
                    "Provide Touch ID/Face ID to disable App Lock"
                
                laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    if success {
                        if isEnabled {
                            self.enableAppLock()
                        } else {
                            self.disableAppLock()
                        }
                        observer.onNext(success)
                    } else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                }
            } else {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func getAppLockState() -> Bool {
        appBeingUnlocked = UserDefaults.standard.bool(forKey: "appLockEnabled")
        return UserDefaults.standard.bool(forKey: "appLockEnabled")
    }
    
    func enableAppLock() {
        UserDefaults.standard.set(true, forKey: "appLockEnabled")
        appBeingUnlocked = true
    }
    
    func disableAppLock() {
        UserDefaults.standard.set(false, forKey: "appLockEnabled")
        appBeingUnlocked = false
    }
    
    func validateAppLock() -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let laContext = LAContext()
            if self.checkIfBioMetricsAvailable() {
                let reason = "Validate App Lock"
                laContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    if success {
                        observer.onNext(true)
                    } else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                }
            } else {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
} 
