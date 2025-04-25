//
//  MockDataClass.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/18.
//

import Foundation

struct MockSuccessDataClass :Codable {
    
    let category:String
    let drinks:[MockDrinks]
    
    struct MockDrinks:Codable {
        
        let name:String
        let prices:MockPrices
        let img:String
        
        struct MockPrices: Codable {
            let lPrice: Int
            let mPrice: Int?
        }
    }
}


struct MockFailDataClass :Codable {
    
    let category:String
    let drinks:String
}

