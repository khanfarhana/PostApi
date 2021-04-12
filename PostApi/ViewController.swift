//
//  ViewController.swift
//  PostApi
//
//  Created by Farhana Khan on 30/03/21.
//
import Kingfisher
import UIKit

class ViewController: UIViewController {
    var holidays = [NSDictionary]()
    var imageV = UIImage.self
    var ColorArr = UIColor()
    @IBOutlet weak var TV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()    }
    func  apiCall()  {
        let url = URL(string: "http://mahindralylf.com/apiv1/getholidays")
        let urlReq = URLRequest(url: url!)
        URLSession.shared.dataTask(with: urlReq) { (data, resp, err) in
            
            if let error = err{
                print("\(error.localizedDescription)")
            }
            else if let dataRes = data{
                do{
                    let jsonRes = try JSONSerialization.jsonObject(with: dataRes, options: .mutableContainers) as! NSDictionary
                    print("\(jsonRes)")
                    self.holidays = jsonRes.value(forKey: "holidays") as! [NSDictionary]
                    //                    let detailsArr = self.holidays.value(forKey: "details") as! [NSDictionary]
                    //                    self.imageV = holidays.va
                    DispatchQueue.main.async {
                        self.TV.reloadData()
                    }
                }
                catch{
                    print("exception")
                }
            }
        }.resume()
    }
    
    
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return holidays.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let detailsArr = holidays[section].value(forKey: "details") as! [NSDictionary]
        return detailsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTVC
        
        let detailsArr = holidays[indexPath.section]["details"] as! [NSDictionary]
        let dict = detailsArr[indexPath.row].value(forKey: "title") as? String ?? ""
        let date = detailsArr[indexPath.row].value(forKey: "date") as? String ?? ""
        cell.lb2.text = dict
        cell.lbl.text = date
        var color = detailsArr[indexPath.row].value(forKey: "color") as! String
        if color.hasPrefix("#"){
            color.removeFirst()
        }
        ColorArr = UIColor(named: "\(color)", in: nibBundle, compatibleWith: nil) ?? UIColor.black
        print("color \(color)")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! CustomHeader
        header.backgroundColor = UIColor.darkGray
        let dict = holidays[section]
        let months = dict.value(forKey: "month") as! String
        let img = dict.value(forKey: "image") as! String
        print("\(img)")
        if let imgurl = URL(string: img){
            header.imgV.kf.setImage(with: imgurl)
            
        }else{
            header.imgV.backgroundColor = UIColor.red
        }
        header.imgV.image = UIImage(named: img)
        header.lbl.text = months
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
class CustomHeader: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
}
class CustomTVC: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var lb2: UILabel!
}
