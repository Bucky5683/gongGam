//
//  RankingViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/25.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreMedia

class RankingViewController: ViewController {
    //My Rank
    @IBOutlet weak var UserNickname: UILabel!
    @IBOutlet weak var UserRank: UILabel!
    //User Rank
    @IBOutlet weak var FirstNic: UILabel!
    @IBOutlet weak var FirstTime: UILabel!
    @IBOutlet weak var SecondNic: UILabel!
    @IBOutlet weak var SecondTime: UILabel!
    @IBOutlet weak var ThirdNic: UILabel!
    @IBOutlet weak var ThirdTime: UILabel!
    @IBOutlet weak var FourthNic: UILabel!
    @IBOutlet weak var FourthTime: UILabel!
    @IBOutlet weak var FifthNic: UILabel!
    @IBOutlet weak var FifthTime: UILabel!
    @IBOutlet weak var SixthNic: UILabel!
    @IBOutlet weak var SixthTime: UILabel!
    @IBOutlet weak var SeventhNic: UILabel!
    @IBOutlet weak var SeventhTime: UILabel!
    @IBOutlet weak var EighthNic: UILabel!
    @IBOutlet weak var EighthTime: UILabel!
    @IBOutlet weak var NinethNic: UILabel!
    @IBOutlet weak var NinethTime: UILabel!
    @IBOutlet weak var TenthNic: UILabel!
    @IBOutlet weak var TenthTime: UILabel!
    //button Outlet
    @IBOutlet weak var studyTimer: UIButton!
    @IBOutlet weak var studyDays: UIButton!
    
    
    var ref : DatabaseReference! = Database.database().reference()
    var sortTimeTopTen : Array<(key: String, value: Int)> = []
    var sortDaysTopTen : Array<(key: String, value: Int)> = []
    var rank : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNickname.text = UserModel.shared.myInfo.nickname
        //랭킹 초기화
        NicTimeRefresh()
        takeObserve()
        //ShowTimer("nil")
    }
    
    //공부시간 버튼 터치
    @IBAction func ShowTimer(_ sender: Any) {
        takeTopTen()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "공부시간", attributes: underlineAttribute)
        let aa = NSMutableAttributedString(string: "공부일수")
        //버튼에 적용
        self.studyTimer.setAttributedTitle(underlineAttributedString, for: .normal)
        self.studyDays.setAttributedTitle(aa, for: .normal)
        
    }
    
    //옵저버 선언ㅋ
    func takeObserve(){
        var sortedTimeTopTen : Array<(key: String, value: Int)> = []
        var sortedDaysTopTen : Array<(key: String, value: Int)> = []
        
        //공부일수 옵저버
        let topTenDays = ref.child("picture_count").queryOrderedByValue().queryLimited(toLast: 10)
        let num = topTenDays.observe(.value, with: {snapshot in
            let topUsers = snapshot.value as! [String:Int]
            sortedDaysTopTen = topUsers.sorted{(first, second) -> Bool in
                return first.value > second.value
            }
        })
        ref.removeObserver(withHandle: num)
        
        //공부시간 옵저버
        let topTen = ref.child("total_time").queryOrdered(byChild: "total_time").queryLimited(toLast: 10)
        let num3 = topTen.observe(.value, with: { snapshot in
            var count = 0
            let topUsers = snapshot.value as? [String:Any]
            let topUsersKey = Array(topUsers!.keys)
            let topUsersValues = topUsers!.values
            var topUsersTotalTime = [String:Int]()
            for keyss in topUsersValues{
                let dict = keyss as? [String:Int]
                topUsersTotalTime[topUsersKey[count]] = dict!["total_time"]
                count+=1
            }
            sortedTimeTopTen = topUsersTotalTime.sorted{(first, second) -> Bool in
                return first.value > second.value
            }
          }
        )
        ref.removeObserver(withHandle: num3)
        
        
        
        //공부일수 유저닉네임 옵저버
        let num2 = ref.child("user").observe(.value, with: { snapshot in
            let us = snapshot.value as! [String:Any]
            var reDaysTopTen : Dictionary<String, Int> = [:]
            var reTopTen : Dictionary<String, Int> = [:]
            for USERS in us{
                //일수
                for i in 0...(sortedDaysTopTen.count-1){
                    if(USERS.key == sortedDaysTopTen[i].key){
                        let nic = USERS.value as! [String:String]
                        reDaysTopTen.updateValue(sortedDaysTopTen[i].value, forKey: String(nic["name"] ?? "N"))
                    }
                }
                //시간
                for i in 0...(sortedTimeTopTen.count-1){
                    if(USERS.key == sortedTimeTopTen[i].key){
                        let nic = USERS.value as! [String:String]
                        reTopTen.updateValue(sortedTimeTopTen[i].value, forKey: String(nic["name"] ?? "N"))
                    }
                }
            }
            if(reDaysTopTen.count < 10){
                for i in 1...(10 - sortedDaysTopTen.count){
                    reDaysTopTen.updateValue(0, forKey:"N\(i)")
                }
            }
            if(reTopTen.count < 10){
                for i in 1...(10 - sortedTimeTopTen.count){
                    reTopTen.updateValue(0, forKey: "N\(i)")
                }
            }
            self.sortDaysTopTen = reDaysTopTen.sorted(by: {$0.1 > $1.1})
            self.sortTimeTopTen = reTopTen.sorted(by: {$0.1 > $1.1})
        })
        ref.removeObserver(withHandle: num2)
    }
    
    //공부일수 버튼 터치
    @IBAction func ShowDays(_ sender: Any) {
        takeTopTenDays()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "공부일수", attributes: underlineAttribute)
        let aa = NSMutableAttributedString(string: "공부시간")
        //버튼에 적용
        self.studyTimer.setAttributedTitle(aa, for: .normal)
        self.studyDays.setAttributedTitle(underlineAttributedString, for: .normal)
    }
    
    //공부 일수 탑텐 알아보기
    func takeTopTenDays(){
        print("=====takeTopTenDays=====")
        self.rank = 1
        //공부일수 개인 순위 옵저버
        let num4 = ref.child("picture_count").queryOrderedByValue().observe(.value, with: { snapshot in
            let topUsers = snapshot.value as! [String:Int]
            for userss in (topUsers.sorted{(first, second) -> Bool in
                return first.value > second.value
            }){
                if(userss.key != UserModel.shared.myInfo.uid){
                    self.rank += 1
                }
                else{
                    break
                }
            }
            self.UserRank.text = self.rankTextChange(rank: self.rank)
        })
        print("Days Rank : \(self.rank)")
        ref.removeObserver(withHandle: num4)
        pushTopTenDays()
    }
    
    //공부 시간 탑텐 알아보기
    func takeTopTen(){
        print("=====takeTopTen=====")
        self.rank = 1
        //공부시간 개인 순위 옵저버
        let num5 = ref.child("total_time").queryOrdered(byChild: "total_time").observe(.value, with: { snapshot in
            var sortedTimeTopTen : Array<(key: String, value: Int)> = []
            var count : Int = 0
            let topUsers = snapshot.value as! [String:Any]
            let topUsersKey = Array(topUsers.keys)
            let topUsersValues = topUsers.values
            var topUsersTotalTime = [String:Int]()
            for keyss in topUsersValues{
                let dict = keyss as? [String:Int]
                topUsersTotalTime[topUsersKey[count]] = dict!["total_time"]
                count+=1
            }
            sortedTimeTopTen = topUsersTotalTime.sorted{(first, second) -> Bool in
                return first.value > second.value
            }
            for userss in sortedTimeTopTen{
                if(userss.key != UserModel.shared.myInfo.uid){
                    self.rank += 1
                }
                else{
                    break
                }
            }
            self.UserRank.text = self.rankTextChange(rank: self.rank)
        })
        print("Time Rank : \(self.rank)")
        ref.removeObserver(withHandle: num5)
        pushTopTen()
    }
    
    //랭킹 초기화
    func NicTimeRefresh(){
        FirstNic.text = "N"
        SecondNic.text = "N"
        ThirdNic.text = "N"
        FourthNic.text = "N"
        FifthNic.text = "N"
        SixthNic.text = "N"
        SeventhNic.text = "N"
        EighthNic.text = "N"
        NinethNic.text = "N"
        TenthNic.text = "N"
        
        FirstTime.text = "00:00:00"
        SecondTime.text = "00:00:00"
        ThirdTime.text = "00:00:00"
        FourthTime.text = "00:00:00"
        FifthTime.text = "00:00:00"
        SixthTime.text = "00:00:00"
        SeventhTime.text = "00:00:00"
        EighthTime.text = "00:00:00"
        NinethTime.text = "00:00:00"
        TenthTime.text = "00:00:00"
    }
    
    //공부일수 랭킹 표시
    func pushTopTenDays(){
        FirstNic.text = self.sortDaysTopTen[0].key
        SecondNic.text = self.sortDaysTopTen[1].key
        ThirdNic.text = self.sortDaysTopTen[2].key
        FourthNic.text = self.sortDaysTopTen[3].key
        FifthNic.text = self.sortDaysTopTen[4].key
        SixthNic.text = self.sortDaysTopTen[5].key
        SeventhNic.text = self.sortDaysTopTen[6].key
        EighthNic.text = self.sortDaysTopTen[7].key
        NinethNic.text = self.sortDaysTopTen[8].key
        TenthNic.text = self.sortDaysTopTen[9].key
        
        FirstTime.text = "\(self.sortDaysTopTen[0].value) / 30"
        SecondTime.text = "\(self.sortDaysTopTen[1].value) / 30"
        ThirdTime.text = "\(self.sortDaysTopTen[2].value) / 30"
        FourthTime.text = "\(self.sortDaysTopTen[3].value) / 30"
        FifthTime.text = "\(self.sortDaysTopTen[4].value) / 30"
        SixthTime.text = "\(self.sortDaysTopTen[5].value) / 30"
        SeventhTime.text = "\(self.sortDaysTopTen[6].value) / 30"
        EighthTime.text = "\(self.sortDaysTopTen[7].value) / 30"
        NinethTime.text = "\(self.sortDaysTopTen[8].value) / 30"
        TenthTime.text = "\(self.sortDaysTopTen[9].value) / 30"
    }
    
    //공부시간 랭킹 표시
    func pushTopTen(){
        FirstNic.text = self.sortTimeTopTen[0].key
        SecondNic.text = self.sortTimeTopTen[1].key
        ThirdNic.text = self.sortTimeTopTen[2].key
        FourthNic.text = self.sortTimeTopTen[3].key
        FifthNic.text = self.sortTimeTopTen[4].key
        SixthNic.text = self.sortTimeTopTen[5].key
        SeventhNic.text = self.sortTimeTopTen[6].key
        EighthNic.text = self.sortTimeTopTen[7].key
        NinethNic.text = self.sortTimeTopTen[8].key
        TenthNic.text = self.sortTimeTopTen[9].key
        
        
        FirstTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[0].value))
        SecondTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[1].value))
        ThirdTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[2].value))
        FourthTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[3].value))
        FifthTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[4].value))
        SixthTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[5].value))
        SeventhTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[6].value))
        EighthTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[7].value))
        NinethTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[8].value))
        TenthTime.text = timerTextChange(tiemr: Double(self.sortTimeTopTen[9].value))
    }
}
