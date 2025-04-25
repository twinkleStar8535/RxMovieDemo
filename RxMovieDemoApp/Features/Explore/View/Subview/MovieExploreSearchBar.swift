//
//  MovieExploreSearchBar.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/6.
//

import UIKit

class MovieExploreSearchBar: UISearchBar {
    private let EXPLOREBARHeight: CGFloat = 60.0
    private let EXPLOREBARPaddingTop: CGFloat = 8.0

    override func layoutSubviews() {
        super.layoutSubviews()
        setCustomBarStyle()
    }

    func setCustomBarStyle() {
        if let textField = self.value(forKey: "searchField") as? UITextField {
            if #available(iOS 11.0, *) {
                let textFieldHeight = EXPLOREBARHeight - EXPLOREBARPaddingTop * 2
                textField.frame = CGRect(x: textField.frame.origin.x, y: EXPLOREBARPaddingTop, width: textField.frame.width, height: textFieldHeight)
            }

            textField.backgroundColor = AppConstant.EXPLOREBAR_TEXTFIELD_BACKGROUND_COLOR
            textField.tintColor = AppConstant.EXPLOREBAR_TEXTFIELD_TINT_COLOR
            textField.font = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: AppConstant.EXPLOREBAR_TEXTFIELD_FONT_SIZE)

            if let label = textField.value(forKey: "placeholderLabel") as? UILabel {
                label.textColor = AppConstant.EXPLOREBAR_PLACEHOLDER_TINT_COLOR
                label.font = UIFont(name: AppConstant.COMMON_FONT_NORMAL, size: AppConstant.EXPLOREBAR_PLACEHOLDER_FONT_SIZE)
            }
        }
    }
}
