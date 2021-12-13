//
//  UserID.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/23.
//

import UIKit
import Firebase
import FirebaseDatabase

final class UserModel {
    struct User {
        var uid: String
        var email: String
        var nickname: String
        var timer: Double
        var watch_timer: Int       //스탑워치
        var ai_timer: Int          //AI
        var picture: Int           //사진 업로드 횟수
    }
    struct DuetUser {
        let nickname: String
        let email: String
        
        var safeEmail: String{
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
    }
    var ref : DatabaseReference! = Database.database().reference()
    static let shared: UserModel = UserModel()
   /* var users: [User] = [
        User(email: "abc1234@naver.com", password: "qwerty1234", nickname: "Alpa", timer: 0.0),
        User(email: "dazzlynnnn@gmail.com", password: "asdfasdf5678",nickname: "Beta", timer: 0.0)
    ]*/
    var myInfo = User(uid: "",email: "",nickname: "",timer: 0.0, watch_timer: 0, ai_timer: 0, picture: 0)
    
} // end of UserModel
