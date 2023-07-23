//
//  Primitive+Random.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 4/19/23.
//

import Foundation

protocol Randomizable {
    static var random: Self { get }
}

extension Int: Randomizable {
    static var random: Self { Self.random(in: 0...20) }
}

extension Double: Randomizable {
    static var random: Self { Self.random(in: 0...20) }
}

extension Float: Randomizable {
    static var random: Self { Self.random(in: 0...20) }
}

extension Bool: Randomizable {
    static var random: Self { Self.random() }
}

extension Optional: Randomizable where Wrapped: Randomizable {
    static var random: Self {
        Bool.random ? Wrapped.random : .none
    }
}

extension Character: Randomizable {
    static var random: Self {
        "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM".randomElement()!
    }
}

extension String: Randomizable {
    static var random: String {
        let interval = Int.random(in: 0...5)...Int.random(in: 6...15)
        let charArray = interval.map { _ in Character.random }
        return String(charArray)
    }
    
    static var randomName: String {
        return "\(randomFirstName) \(randomLastName)"
    }
    
    static var randomURL: String {
        [
            "https://steepmen.ru/wp-content/uploads/2021/11/32dw.jpg",
            "https://i1.sndcdn.com/avatars-5ORkLXa9XxPQWcO6-uqNm2Q-t500x500.jpg",
            "https://e0.pxfuel.com/wallpapers/527/455/desktop-wallpaper-eva-elfie.jpg",
            "https://voprosfen.com/wp-content/uploads/2022/08/2233-448x400.png",
            "https://virtus-img.cdnvideo.ru/images/as-is/plain/f7/f700e0f1-78d4-42c2-b341-4a21ba031008.jpg@jpg",
            "https://sun9-10.userapi.com/impg/3f5diGVVsuY2S1yuWkJuIPfvOsExU8pUJMUlkA/4Aa3_rSBBIk.jpg?size=604x604&quality=95&sign=028d66b5b284b81a8a6e78bea8cc7bad&type=album",
            "https://i0.wp.com/globalzonetoday.com/wp-content/uploads/2020/08/Eva-Elfie.jpg?fit=1080%2C643&ssl=1",
            "https://fsb.zobj.net/crop.php?r=_yYdbhwamo_3rPmixUqEMCsw63M2sRWuNzFE7Y6VFBRQzqVcTH7g7ZqD2TOaDKUW_DCQ6fMM819IhVsC2RmDqXcwIjRaJhzpyd-7YZsFqqlobwk_Y5XOA_n6nvbJ82i1WvTZzjpRMsd3gGVQr7YlIHSoYVasK1HTVQZztuIHQiR_tRzXuncnZ3sIzJYRqoj-S2Ayb_keO2J2F_bq",
            "https://everipedia-storage.s3.amazonaws.com/ProfilePicture/lang_en/eva-elfie/mainphoto_medium.webp",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHTi8eWfWqOgzXaOtV9vA2wg8WiYNXReARfCqeR8Wtfm3GSQV9Ehs0d1QFhF-I8D2ZbE4&usqp=CAU",
            "https://coub-attachments.akamaized.net/coub_storage/coub/simple/cw_timeline_pic/caba6557ec4/8e8f949e2b14ef64d45ac/med_1617120514_image.jpg",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRQ-3qgHlKJiF8MWxuW45rY7xyz2zc0HL215A&usqp=CAU",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQvrw1La-3HO6cru35o6mWnZR8s0oIBWPZxg&usqp=CAU",
            "https://celebzbiography.com/wp-content/uploads/2022/07/Eva-Elfie-Wiki-celebzbiography.com_.webp"
            
        ].randomElement()!
    }
    
    private static var randomFirstName: String {
        ["Olivia","Emma","Charlotte","Amelia","Ava","Sophia","Isabella","Mia","Evelyn","Harper","Luna","Camila","Gianna","Elizabeth","Eleanor","Ella","Abigail","Sofia","Avery","Scarlett","Emily","Aria","Penelope","Chloe","Layla","Mila","Nora","Hazel","Madison","Ellie","Lily","Nova","Isla","Grace","Violet","Aurora","Riley","Zoey","Willow","Emilia","Stella","Zoe","Victoria","Hannah","Addison","Leah"].randomElement()!
    }
    
    private static var randomLastName: String {
        ["Jones","Smith","Garcia","Edwards","Brown","Thompson","Sullivan","Rodriguez","Williams","Johnson","Martinez","Gregory","Wilson","Burke","Hayden","Lopez","Wilkins","Mullin","Lee","Campbell","King"].randomElement()!
    }
}
