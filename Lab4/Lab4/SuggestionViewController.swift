//
//  SuggestionViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/8/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {

    struct APIResults:Decodable {
        let page: Int
        let results: [Movie]
    }
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String?
        let vote_average: Double?
        let overview: String?
    }
    
    var suggested_id: Int?
    var theData : [Movie] = []
    var theImageCache : [UIImage] = []
    var suggestionCV : UICollectionView?
    var spinner: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in suggestion view")
        view.backgroundColor = .white
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (110), height: 170)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        let CVFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        suggestionCV = UICollectionView(frame: CVFrame, collectionViewLayout: layout)
        setUpCollectionView()
        view.addSubview(suggestionCV!)
        spinner = UIActivityIndicatorView()
        spinner?.hidesWhenStopped = true
        suggestionCV!.addSubview(spinner!)
        
        let fr = CGRect(x: 0, y: 100, width: view.frame.width, height: 60)
        let not_avail = UILabel(frame: fr)
        not_avail.textAlignment = .center
        not_avail.font.withSize(15)
        not_avail.layer.zPosition = 1
        self.view.addSubview(not_avail)
        self.spinner?.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.fetchDataForCollectionView()
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.suggestionCV!.reloadData()
                if self.theData.count == 0 {
                    print("none")
                    not_avail.text = "No similar movies available"
                }
//                self.spinner?.stopAnimating()
            }
        }
    }
    
    func setUpCollectionView(){
        suggestionCV?.backgroundColor = .white
        suggestionCV!.delegate = self
        suggestionCV!.dataSource = self
        suggestionCV!.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func fetchDataForCollectionView(){
        print("getting data...")
        let base_url = "https://api.themoviedb.org/3/movie/"
        let end_url = "/similar?api_key=bc86ebc978bfb13bc0c142825c1417b1&language=en-US&page=1"
        print(suggested_id)
        let movie_num = suggested_id! as NSNumber
        let movie_id =  movie_num.stringValue
        let url = URL(string: base_url + movie_id + end_url)
        print(movie_id)
        do {
            let data = try Data(contentsOf: url!)
            let json:APIResults = try JSONDecoder().decode(APIResults.self, from: data)
            self.theData = json.results
        }
        catch {
            print("error collecting data for collection view")
            self.theData = []
        }
        
        
    }
    
    func cacheImages(){
        theImageCache = []
        let base_url = "https://image.tmdb.org/t/p/w500"

        for movie in self.theData {
            if let poster_img = movie.poster_path {
                let image_url = base_url + poster_img
                let url = URL(string: image_url)
                let data = try? Data(contentsOf: url!)
                let img = UIImage(data: data!)
                self.theImageCache.append(img!)
            }
            else{
                let image = UIImage(named: "poster_not_avail")
                self.theImageCache.append(image!)
            }
        }
        print("images cached")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: theImageCache[indexPath.row], title: theData[indexPath.row].title)
        return cell
    }
    
    
}
