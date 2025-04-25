//
//  ThemeManager.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/9.
//
import RxSwift
import RxTheme

protocol ThemeChangeDelegate {
    func setupTheme()
}

typealias Atttibutes = [NSAttributedString.Key:Any]

protocol ThemeManager {
    var backgroundColor:UIColor {get}
    var textColor:UIColor {get}
    var tabBarSelectColor:UIColor {get}
    var tabBarNormalColor:UIColor {get}
    var segmentSelectColor:UIColor {get}
    var segmentNormalColor:UIColor {get}
    var backButtonColor:UIColor {get}
    var tableViewThemeColor:UIColor {get}
}


struct LightTheme :ThemeManager {
    var backgroundColor: UIColor = AppConstant.LIGHT_MAIN_COLOR
    var textColor: UIColor = AppConstant.LIGHT_TXT_COLOR
    var tabBarSelectColor: UIColor = AppConstant.LIGHT_SUB_COLOR
    var tabBarNormalColor: UIColor = .gray
    var segmentSelectColor: UIColor =  AppConstant.LIGHT_SUB_COLOR
    var segmentNormalColor: UIColor = .black
    var backButtonColor: UIColor = AppConstant.LIGHT_TXT_COLOR
    var tableViewThemeColor:UIColor = .lightGray.withAlphaComponent(0.05)
}


struct DarkTheme :ThemeManager {
    var backgroundColor: UIColor = AppConstant.DARK_MAIN_COLOR
    var textColor: UIColor = .white
    var tabBarSelectColor: UIColor = AppConstant.DARK_SUB_COLOR
    var tabBarNormalColor: UIColor = .white
    var segmentSelectColor: UIColor = AppConstant.DARK_SUB_COLOR
    var segmentNormalColor: UIColor = .white
    var backButtonColor: UIColor = .white
    var tableViewThemeColor:UIColor  = .lightGray.withAlphaComponent(0.1)
}


enum ThemeType:String, ThemeProvider {
    case light,dark

    var associatedObject: ThemeManager {
        switch self {
          case .light:
            return LightTheme()
          case .dark:
            return DarkTheme()
        }
    }
}

struct ThemeService {
    static var currentTheme: ThemeType {
        get {
            if let savedTheme = UserDefaults.standard.string(forKey: "SelectedTheme"),
               let themeType = ThemeType(rawValue: savedTheme) {
                return themeType
            } else {
                return .dark
            }
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "SelectedTheme")
        }
    }
}

var selectedTheme: ThemeType {
    get {
        return ThemeService.currentTheme
    }
    set {
        ThemeService.currentTheme = newValue
    }
}


var themeService = ThemeType.service(initial: selectedTheme)
