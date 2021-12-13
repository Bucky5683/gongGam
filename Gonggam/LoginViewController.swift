//
//  LoginViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: ViewController{
    @IBOutlet weak var logo: UIImageView!
    //@IBOutlet weak var onNickfield: UITextField!
    @IBOutlet weak var onNickfield: UITextField!
    //@IBOutlet weak var onIDfield: UITextField!
    @IBOutlet weak var onIDfield: UITextField!
    //@IBOutlet weak var onPWfield: UITextField!
    @IBOutlet weak var onPWfield: UITextField!
    @IBOutlet weak var onChangebtn: UIButton!
    @IBOutlet weak var onCheckbtn: UIButton!
    
    var loginCheck: Bool = true; //현재 로그인 상태인지 아닌지 확인하는 변수 true = 로그인화면, false = 회원가입화면
    var CheckClicked: Bool = false; //check button이 눌렸는지 안눌렸는지 확인
    var Nickname: String = "";
    var ID: String = "";
    var PW: String = "";
    var ref : DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        onCheckbtn.layer.cornerRadius = 10
        super.viewDidLoad()
        keyboard_action()
        if Auth.auth().currentUser != nil {
            storeUserinfo()
            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") else { return }
            self.navigationController?.pushViewController(homeVC, animated: true)
        }

        onNickfield.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        onIDfield.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        onPWfield.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        onCheckbtn.addTarget(self, action: #selector(didEndOnExit), for: UIControl.Event.editingDidEndOnExit)
        // Do any additional setup after loading the view.
    }
    func storeUserinfo(){
        let user = Auth.auth().currentUser
        if let user = user{
            UserModel.shared.myInfo.email = String(user.email!)
            UserModel.shared.myInfo.uid = String(user.uid)
            findMoreInfo(uid: UserModel.shared.myInfo.uid)
            print("Gonggam: email = \(UserModel.shared.myInfo.email)")
            print("Gonggam: uid = \(UserModel.shared.myInfo.uid)")
            print("Gonggam: nickname = \(UserModel.shared.myInfo.nickname)")
        }
        
    }
    func findMoreInfo(uid: String){
        ref.child("user").child(UserModel.shared.myInfo.uid).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            UserModel.shared.myInfo.nickname = value?["name"] as? String ?? "No string"
        })
        ref.child("total_time").child(UserModel.shared.myInfo.uid).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            UserModel.shared.myInfo.timer = value?["total_time"] as? Double ?? 0.0
            UserModel.shared.myInfo.watch_timer = value?["watch_time"] as? Int ?? 0
            UserModel.shared.myInfo.ai_timer = value?["ai_time"] as? Int ?? 0
        })
        ref.child("picture_count").child(UserModel.shared.myInfo.uid).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            UserModel.shared.myInfo.picture = value?[UserModel.shared.myInfo.uid] as? Int ?? 0
        })
    }
    
    func keyboard_action(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification ,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(_:)),
            name: UIResponder.keyboardWillHideNotification ,
            object: nil
        )
    }
    @IBAction func ChangeLS() {
        LS()
    }
    func LS(){
        if loginCheck == true{
            onNickfield.isHidden = false
            loginCheck = false
            onChangebtn.setTitle("계정이 있다면?", for: .normal)
            onCheckbtn.setTitle("회원가입", for: .normal)
        }
        else{
            onNickfield.isHidden = true
            loginCheck = true
            onChangebtn.setTitle("아직 계정이 없다면?", for: .normal)
            onCheckbtn.setTitle("로그인", for: .normal)
        }
    }
    
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
             }, completion: { _ in
                 UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 10
                })
            })
        })
    }
    
    @objc func didEndOnExit(_ sender: UITextField) {
        if onNickfield.isFirstResponder {
            onIDfield.becomeFirstResponder()
        }
        if onIDfield.isFirstResponder {
            onPWfield.becomeFirstResponder()
        }
    }
    
    @IBAction func GoMain(_ sender: Any) {
        if loginCheck == true{
            Auth.auth().signIn(withEmail: onIDfield.text!, password: onPWfield.text!){ (user, error) in
                if user != nil{
                    
                    print("login success")
                    if let removable = self.view.viewWithTag(102) {
                        removable.removeFromSuperview()
                    }
                    //self.performSegue(withIdentifier: "MainViewController", sender: self)
                    self.storeUserinfo()
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") else { return }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
                else{
                    print("login fail")
                    self.shakeTextField(textField: self.onIDfield)
                    self.shakeTextField(textField: self.onPWfield)
                    self.showToast(message: "이메일 또는 비밀번호를 확인해주세요")
                }
            }
        }
        else{
            Auth.auth().createUser(withEmail: onIDfield.text!, password: onPWfield.text!){ (authResult, error) in
                if authResult != nil{
                    
                    print("sigin/login success")
                    //유저정보 저장
                    UserModel.shared.myInfo.nickname = self.onNickfield.text!
                    UserModel.shared.myInfo.uid = Auth.auth().currentUser!.uid
                    UserModel.shared.myInfo.email = self.onIDfield.text!
                    UserModel.shared.myInfo.timer = 0.0
                    UserModel.shared.myInfo.watch_timer = 0
                    UserModel.shared.myInfo.ai_timer = 0
                    UserModel.shared.myInfo.picture = 0
                    //Firebase에 유저정보 업로드
                    self.ref.child("user").child(UserModel.shared.myInfo.uid).setValue(["name": UserModel.shared.myInfo.nickname])
                    
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController") else { return }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    
                }
                else{
                    print("signin/login fail")
                }
                
            }
        }
    }
    
    @IBAction func tapAction(_ sender: Any) {
        print("tapped!")
        self.view.endEditing(true)
    }
    @objc func keyboardWillAppear(_ sender: Notification){
        self.view.frame.origin.y = -130

    }
    @objc func keyboardWillDisappear(_ sender: Notification){
        self.view.frame.origin.y = 0
    }
}
