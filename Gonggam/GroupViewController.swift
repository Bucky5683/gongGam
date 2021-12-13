//
//  GroupViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/25.
//

import UIKit
import Firebase
import FirebaseAuth

class GroupViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var myBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var ref : DatabaseReference! = Database.database().reference()
    var testGroupname : [String] = []
    var testtPeoplenumber : [Int] = []
    var testGroupmaxnum : [Int] = []
    var privateGroup : [Int] = []
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupTableView.dataSource = self
        self.groupTableView.delegate = self
        self.searchBar.delegate = self
        self.filteredData = testGroupname
        groupTableView.backgroundColor = UIColor.white
        recommendGroup("")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = searchText.isEmpty ? testGroupname : testGroupname.filter { (item: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            groupTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        self.filteredData = self.testGroupname
        groupTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredData = self.testGroupname
        groupTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! CustomCell
        //print("testItems.keys type: ", type(of: testItems.keys))
        //print("testItems.values type: ", type(of: testItems.values))
        cell.groupName.text = filteredData[indexPath.row]
        cell.peopleNumber.text = String(testtPeoplenumber[indexPath.row]) + " / " + String(testGroupmaxnum[indexPath.row])
        if(privateGroup[indexPath.row] == 1){
            cell.privateYN.isHidden = false
        }
        else{
            cell.privateYN.isHidden = true
        }
         return cell
    }
    
    //추천 그룹 리스트 띄우기
    func recommendGrouplist(){
        self.filteredData.removeAll()
        self.testGroupmaxnum.removeAll()
        self.testtPeoplenumber.removeAll()
        self.testGroupname.removeAll()
        self.privateGroup.removeAll()
        let num = ref.child("group").observe(.value, with: {snapshot in
            let listGroup = snapshot.value as! [String:Any]
            let groupNames = Array(listGroup.keys)
            let groupsValues = Array(listGroup.values)
            self.testGroupname = groupNames
            //print(self.testGroupname)
            //print("type: ", type(of:groupsValues))
            for i in 0...(groupNames.count - 1){
                print(i)
                let groupInfo = groupsValues[i] as! NSDictionary
                print(groupInfo)
                print("type: ", type(of: groupInfo))
                self.testtPeoplenumber.append(groupInfo.value(forKey: "people") as! Int)
                self.testGroupmaxnum.append(groupInfo.value(forKey: "size") as! Int)
                self.privateGroup.append(groupInfo.value(forKey: "public") as! Int)
                DispatchQueue.main.async {
                    self.groupTableView.reloadData();
                }
            }
            self.filteredData = self.testGroupname
            print(self.filteredData)
        })
        ref.removeObserver(withHandle: num)
    }
    
    //추천 그룹 버튼
    @IBAction func recommendGroup(_ sender: Any) {
        print("=====recommendGroup=====")
        recommendGrouplist()
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "추천 그룹", attributes: underlineAttribute)
        let aa = NSMutableAttributedString(string: "나의 그룹")
        //버튼에 적용
        self.recommendBtn.setAttributedTitle(underlineAttributedString, for: .normal)
        self.myBtn.setAttributedTitle(aa, for: .normal)
    }
    //나의 그룹 버튼
    @IBAction func myGroup(_ sender: Any) {
        print("=====myGroup=====")
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "나의 그룹", attributes: underlineAttribute)
        let aa = NSMutableAttributedString(string: "추천 그룹")
        //버튼에 적용
        self.myBtn.setAttributedTitle(underlineAttributedString, for: .normal)
        self.recommendBtn.setAttributedTitle(aa, for: .normal)
    }
    
}

class CustomCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var privateYN: UIImageView!
    @IBOutlet weak var peopleNumber: UILabel!
}
