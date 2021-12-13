//
//  StopwatchViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/27.
//

import UIKit
import Firebase
import FirebaseAuth

class StopwatchViewController: ViewController {
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var statusText: UILabel!
    
    var status = true  // true : 측정중, false : 일시정지
    var count = 0
    var TimerCheck = Timer()
    var ref : DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        start()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionForUnwindButton(sender: AnyObject) {
        
        //UserModel.shared.users[0].timer = Double(count)
        print("actionForUnwindButton")
        UserModel.shared.myInfo.timer += Double(count)
        UserModel.shared.myInfo.watch_timer += count
        self.ref.child("total_time").child(UserModel.shared.myInfo.uid).child("watch_time").setValue(UserModel.shared.myInfo.watch_timer)
        self.ref.child("total_time").child(UserModel.shared.myInfo.uid).child("total_time").setValue(UserModel.shared.myInfo.timer)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func Checking(sender: Any) {
        if status == true{
            pause()
        }
        else{
            start()
        }
    }
    
    @objc func add(){
        count += 1
        timer.text = String(format: "%02d",count/3600) + ":" + String(format: "%02d",(count - (count/3600)*3600)/60) + ":" + String(format: "%02d",(count - (count/3600)*3600)%60)
    }
    
    func start(){
        TimerCheck = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(add), userInfo: nil, repeats: true)
        timer.text = String(format: "%02d",count/3600) + ":" + String(format: "%02d",(count - (count/3600)*3600)/60) + ":" + String(format: "%02d",(count - (count/3600)*3600)%60)
        status = true
        statusText.text = "측정 중..."
        statusText.textColor = .blue
    }
    
    func pause(){
        TimerCheck.invalidate()
        status = false
        statusText.text = "일시정지"
        statusText.textColor = .red
    }
}
