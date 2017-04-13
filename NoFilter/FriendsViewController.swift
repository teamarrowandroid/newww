//
//  FriendsViewController.swift
//  NoFilter
//
//  Created by Basil on 2017-03-28.
//  Copyright © 2017 mapd.centennial.proapptive. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var suggestedFriends = [UserProfile]()
    
    var friends:[String] = ["1","2","3"]
    
    var sfCellPosts = UserProfile()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("fetching useres")
        fetchUsers();
       
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return suggestedFriends.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ImageTableViewCell
        let user=cell.viewWithTag(2) as! UILabel
        let imgView=cell.viewWithTag(1) as! UIImageView
        
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            
            sfCellPosts = suggestedFriends[indexPath.row]
            print("postrow",sfCellPosts)
            user.text = sfCellPosts.fullName
            let imgurl = sfCellPosts.profileImage
            cell.addAsFriend.isHidden = false
            cell.uId = self.sfCellPosts.uId
            
            let url = NSURL(string: imgurl)
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                imgView.image = UIImage(data: data! as Data)
            }
            
            break
        case 1:
//            user.text = friends[indexPath.row]
//            cell.addAsFriend.isHidden = true
            break
        default:
            break
        }
        return cell
    }
    
    var array = [String]()
    func fetchUsers(){
        for i in array
        {
            
        let eref = FIRDatabase.database().reference().child("users")
            let eref = query.queryEqual(toValue: i)
            eref.observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children
                {
                    var item = UserProfile()
                    if (child as AnyObject).hasChild("fullName") {
                        item.fullName = ((snapshot.value as! NSDictionary)["fullName"] as? String)!
                    }
                    if (child as AnyObject).hasChild("profileImage") {
                        item.profileImage = ((snapshot.value as! NSDictionary)["profileImage"] as? String)!
                    }
                    if (child as AnyObject).hasChild("uId") {
                        item.uId = ((snapshot.value as! NSDictionary)["uId"] as? String)!
                    }
                    self.suggestedFriends.append(item)
                    self.tableView.reloadData()
                    print("Item: \(self.suggestedFriends.map { $0.fullName})")
                }
            })
        }
}

