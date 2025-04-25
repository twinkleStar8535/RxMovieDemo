//
//  AppConstant.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/3/31.
//

import Foundation
import UIKit

struct AppConstant {

// MARK: UI Related
    static let COMMON_FONT_NORMAL: String = "Helvetica"
    static let COMMON_FONT_BOLD: String = "Helvetica-Bold"

    static let LIGHT_MAIN_COLOR: UIColor = .white
    static let LIGHT_SUB_COLOR: UIColor = .red
    static let LIGHT_TXT_COLOR: UIColor = .black

    static let DARK_MAIN_COLOR: UIColor = .black // UIColor.init(hex: "0E2440")
    static let DARK_SUB_COLOR: UIColor = UIColor(hex: "#F2C069")

    static let COMMON_NAVIGATION_FONT_SIZE: CGFloat = 14.0

    static let EXPLOREBAR_TEXTFIELD_BACKGROUND_COLOR: UIColor = UIColor(hex: "EBEBEB")
    static let EXPLOREBAR_TEXTFIELD_TINT_COLOR: UIColor = UIColor(hex: "#666666")
    static let EXPLOREBAR_TEXTFIELD_FONT_SIZE: CGFloat = 13.0
    static let EXPLOREBAR_PLACEHOLDER_TINT_COLOR: UIColor = .lightGray
    static let EXPLOREBAR_PLACEHOLDER_FONT_SIZE: CGFloat = 13.0

    static let TOAST_TINT_COLOR: UIColor = .white
    static let TOAST_FONT_TITLE_SIZE: CGFloat = 12.0
    static let TOAST_FONT_MESSAGE_SIZE: CGFloat = 12.0

// MARK: API Related

    static let CONTENTTYPE_JSON = "application/json"

    static let SESSION_BASEURL = "https://favqs.com/api/session"
    static let SIGNUP_BASEURL = "https://favqs.com/api/users"
    
    static let LOGIN_TOKEN = "174c911c47229799a204b550231614ab"


    static let MOVIE_API_BASEURL = "https://api.themoviedb.org/3/movie/"
    static let MOVIE_EXPLORE_BASEURL = "https://api.themoviedb.org/3/search/movie?query="
    static let TMDB_IMG_BASEURL = "https://image.tmdb.org/t/p/original"
    static let TMDB_API_KEY = "c0bcbdbbf7821528df222b45e781afa3"

    static let AIRTABLE_API_BASEURL = "https://api.airtable.com/v0/appJI9LhWPxsnh7f3/movieItems"
    static let AIRTABLE_TOKEN = "patxhIM5T50XpvgCV.b6b0dd9bc28025f21f2da81d14a0e83d5bf44356869224713946a48d26d5fe3c"
}
