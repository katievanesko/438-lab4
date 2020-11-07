//
//  ViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct APIResults:Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }
    
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String
        let vote_average: Double
        let overview: String
        let vote_count:Int!
    }
    
    var theData : [Movie] = []
    var theImageCache : [UIImage] = []
    
    @IBOutlet weak var movieCV: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        setUpTableView()
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            self.fetchDataForTableView()
        //            self.cacheImages()
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        }
        print("hello0")
        movieCV.delegate = self
        movieCV.dataSource = self
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&primary_release_year=2010&sort_by=vote_average.desc"
        //        let api_key = "bc86ebc978bfb13bc0c142825c1417b1"
        getData(from:url)
    }

    private func getData(from url: String) {
            print("getting data")
            URLSession.shared.dataTask(with: (URL(string: url))!, completionHandler: {data, response, error in
                
                guard let data = data, error == nil else {
                    print("bad things oops")
                    return
                }
                
                var results: APIResults?
                do {
                    results = try JSONDecoder().decode(APIResults.self, from: data)
                }
                catch {
                    print("failed to convert \(error.localizedDescription)")
                }
                
                guard let json = results else {
                    return
                }
                print(json.results[0].overview)
                }).resume()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return theData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    //        cell.textLabel!.text = theData[indexPath.row.title]
    //        cell.imageView?.image = theImageCache[indexPath.row]
            return cell
        }
        
        func setUpTableView() {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        
        func fetchDataForTableView(){
    //        let url = URL(string: "https://api.themoviedb.org/3/movie/550?api_key=bc86ebc978bfb13bc0c142825c1417b1") ?? <#default value#>
    //        let data = try! Data(contentsOf: url) //dont use !
    //        theData = try! JSONDecoder().decode([APIResults].self,from:data)
            
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let detailedVC = DetailedViewController()
//            detailedVC.image = theImageCache[indexPath.row]
//            detailedVC.imageName = theData[indexPath.row].title
//            
//            navigationController?.pushViewController(detailedVC, animated: true)
        }
        
        func cacheImages(){
            //look to 26:00 in lecture 10 for filling out function
    //        for item in theData {
    //            let url = URL(string:item.imge_url)
    //        }
        }

    
    
}

