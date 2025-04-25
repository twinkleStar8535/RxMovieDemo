//
//  SettingModels.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//

import Foundation
import RxDataSources

enum SectionItem {
    case titleCellInit(title: String)
    case titleCellWithSwitch(title: String)
}

struct SettingSection {
    var header: String
    var items: [SectionItem]
}

extension SettingSection: SectionModelType {
    typealias Items = SectionItem
    
    init(original: SettingSection, items: [Items]) {
        self = original
        self.items = items
    }
}

enum Setting {
    enum FetchSettings {
        struct Request { }
        
        struct Response {
            let sections: [SettingSection]
        }
        
        struct ViewModel {
            let sections: [SettingSection]
        }
    }
    
    enum AppLock {
        struct Request {
            let isEnabled: Bool
        }
        
        struct Response {
            let isEnabled: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let isEnabled: Bool
            let errorMessage: String?
        }
    }
    
    enum AppLockValidation {
        struct Request { }
        
        struct Response {
            let isValid: Bool
        }
        
        struct ViewModel {
            let isValid: Bool
        }
    }
    
    enum Theme {
        struct Request {
            let isLightMode: Bool
        }
        
        struct Response {
            let isLightMode: Bool
            let error: Error?
        }
        
        struct ViewModel {
            let isLightMode: Bool
            let errorMessage: String?
        }
    }
    
    enum Navigation {
        case favorites
        case watchList
    }
} 
