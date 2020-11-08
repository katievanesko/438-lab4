//
//  ViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
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

    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
       
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchDataForCollectionView()
            self.cacheImages()
            DispatchQueue.main.async {
                self.movieCV.reloadData()
            }
        }
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 170)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        layout.scrollDirection = .vertical
        movieCV.collectionViewLayout = layout
        movieCV.alwaysBounceVertical = true
        movieCV.bounces = true
        
        movieCV.delegate = self
        movieCV.dataSource = self

        movieCV.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func fetchDataForCollectionView(){
        print("getting data...")
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&sort_by=popularity.desc")
        let data = try? Data(contentsOf: url!)
        let json:APIResults = try! JSONDecoder().decode(APIResults.self, from: data!)

        self.theData = json.results
    }
    
    func cacheImages(){
        let base_url = "https://image.tmdb.org/t/p/w500"
        for movie in self.theData {
            let image_url = base_url + movie.poster_path!
            let url = URL(string: image_url)
            let data = try? Data(contentsOf: url!)
            let img = UIImage(data: data!)
            self.theImageCache.append(img!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: theImageCache[indexPath.row], title: theData[indexPath.row].title)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("selected item")
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.movie_title = theData[indexPath.row].title
        detailedVC.overview = theData[indexPath.row].overview
        detailedVC.release_date = theData[indexPath.row].release_date
        detailedVC.vote_average = theData[indexPath.row].vote_average
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }

    
}

