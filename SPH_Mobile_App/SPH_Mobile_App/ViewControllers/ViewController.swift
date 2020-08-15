//
//  ViewController.swift
//  SPH_Mobile_App
//
//  Created by Anjana George on 15/8/20.
//  Copyright © 2020 Anjana George. All rights reserved.
//
import UIKit
import CardViewList
import Moya

class ViewController: UIViewController, CardViewListDelegete {
    
    fileprivate var cardViewList: CardViewList!
    @IBOutlet weak var cardContainerWithView: UIView!
    
    var dropInUsageMsg: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardViewList = CardViewList()
        self.cardViewList.delegete = self
        
        self.getDataUsageInfo()
    }
    
    func getDataUsageInfo() {
        let provider = MoyaProvider<Service>()
        provider.request(.getData) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        let dataUsageInfo = try JSONDecoder().decode(DataUsage.self, from: data)
                        
                        if let result = dataUsageInfo.result, let records = result.records {
                            self.setUpCard(records : records)
                            self.saveData(records: records)
                        }
                    } catch let error {
                        self.showAlert(title: "Error \(statusCode)", message: "Something went wrong while retrieving data online!\(error.localizedDescription) Data shown in this app is locally saved data.")
                        self.showLocalData()
                    }
                }else {
                    //If the server responds with a 4xx or 5xx error
                    self.showAlert(title: "Error \(statusCode)", message: "Something went wrong while retrieving data online!")
                    self.showLocalData()
                }
            case let .failure(error):
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).
                self.showAlert(title: "Network Failure", message: "\(error.localizedDescription) Data shown in this app is locally saved data.")
                self.showLocalData()
            }
        }
    }
    
    func showLocalData(){
        if let data = UserDefaults.standard.value(forKey:"dataUsageRecord") as? Data {
            if let records = try? PropertyListDecoder().decode(Array<Record>.self, from: data) {
                self.setUpCard(records : records)
            }
        }
    }
    
    func saveData(records : [Record]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(records), forKey:"dataUsageRecord")
    }
    
    func setUpCard(records: [Record]) {
        var cardViews = [UIView]()
        var year = ""
        var totalYearUsage: Float = 0.0
        var yearUsageArr: [Float] = []
        for record in records {
            let recordYear = String(record.quarter.prefix(4))
            if Int(recordYear)! > 2007 {
                if year == "" || recordYear == year {
                    //If quarter in same year add  to totalYearUsage
                    year = recordYear
                    if let dataUsage = Float(record.volume_of_mobile_data) {
                        totalYearUsage += dataUsage
                        yearUsageArr.append(dataUsage)
                    }
                }else {
                    let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
                    cardView.volumeLabel.text = "Yearly Usage : \(totalYearUsage) PB"
                    cardView.yearLabel.text = year
                    
                    //setup clickable image in the entry if any quarter in a year demonstrates a decrease in volume data.
                    if let minValue = yearUsageArr.min() {
                        if (yearUsageArr.firstIndex(of: minValue) != 0){
                            cardView.dropImageView.isHidden = false
                            dropInUsageMsg.append("There is a drop in usage (\(minValue)) PB in \(year) quarter \(yearUsageArr.firstIndex(of: minValue)! + 1)")
                        }else {
                            cardView.dropImageView.isHidden = true
                            dropInUsageMsg.append("")
                        }
                    }
                    cardViews.append(cardView)
                    
                    //If quarter in new year
                    year = recordYear
                    if let dataUsage = Float(record.volume_of_mobile_data) {
                        totalYearUsage = dataUsage
                        yearUsageArr = [dataUsage]
                    }
                    
                }
            }
        }
        self.cardViewList.animationScroll = .scaleBounce
        self.cardViewList.isClickable = true
        self.cardViewList.clickAnimation = .bounce
        self.cardViewList.cardSizeType = .autoSize
        self.cardViewList.grid = 1
        self.cardViewList.generateCardViewList(containerView: self.cardContainerWithView, views: cardViews, listType: .vertical, identifier: "card")
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func cardView(_ scrollView: UIScrollView, didSelectCardView cardView: UIView, identifierCards identifier: String, index: Int) {
        if (dropInUsageMsg[index] != ""){
            self.showAlert(title: "Decrease in volume data", message: "\(dropInUsageMsg[index])")
        }
    }
    
}
