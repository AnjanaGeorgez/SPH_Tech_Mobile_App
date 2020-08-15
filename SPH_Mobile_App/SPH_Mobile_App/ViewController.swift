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
    fileprivate let cardIdentifier = "verticalCard"
    @IBOutlet weak var cardContainerWithView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardViewList = CardViewList()
        self.cardViewList.delegete = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getDataUsageInfo()
        
        var cardViews = [UIView]()
        for _ in 1 ... 25 {
            let cardView = CardView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            cardViews.append(cardView)
        }
        self.cardViewList.animationScroll = .scaleBounce
        self.cardViewList.isClickable = true
        self.cardViewList.clickAnimation = .bounce
        self.cardViewList.cardSizeType = .autoSize
        self.cardViewList.grid = 1
        self.cardViewList.generateCardViewList(containerView: cardContainerWithView, views: cardViews, listType: .vertical, identifier: "CardWithUIViews1")
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
                        print(dataUsageInfo.result!.records!)
                    } catch let error {
                        print("\(error.localizedDescription)")
                    }
                }else {
                    
                }
            case let .failure(error):
                // this means there was a network failure - either the request
                // wasn't sent (connectivity), or no response was received (server
                // timed out).  If the server responds with a 4xx or 5xx error, that
                // will be sent as a ".success"-ful response.
                print("Fail")
            }
        }
    }
    
    func cardView(willDisplay scrollView: UIScrollView, identifierCards identifier: String) {
    }
    
    // You can control CardView from here
    func cardView(_ scrollView: UIScrollView, willAttachCardView cardView: UIView, identifierCards identifier: String, index: Int) {
        //print(cardView.frame)
    }
    
    func cardView(_ scrollView: UIScrollView, willAttachCardViewController cardViewController: UIViewController, identifierCards identifier: String, index: Int) {
    }
    
    func cardView(_ scrollView: UIScrollView, didFinishDisplayCardViews cardViews: [UIView], identifierCards identifier: String) {
        //print(cardViews.count)
    }
    
    func cardView(_ scrollView: UIScrollView, didFinishDisplayCardViewControllers cardViewsController: [UIViewController], identifierCards identifier: String) {
    }
    
    func cardView(_ scrollView: UIScrollView, didSelectCardView cardView: UIView, identifierCards identifier: String, index: Int) {
        //        if identifier == horizontalCardIdentifier {
        //            print("Horizontal card view finish display!")
        //        }
    }
    
    func cardView(_ scrollView: UIScrollView, didSelectCardViewController cardViewController: UIViewController, identifierCards identifier: String, index: Int) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
