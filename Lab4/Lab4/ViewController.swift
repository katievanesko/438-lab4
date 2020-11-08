//
//  ViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    
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
    }
    
    var theData : [Movie] = []
    var theImageCache : [UIImage] = []
    var filteredData:[Movie]!
    
    @IBOutlet weak var movieCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        searchBar.delegate = self
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
    
    func fetchFilteredDataForCollectionView(from url:URL) {
        print("getting filtered data...")
        let data = try? Data(contentsOf: url)
        let json:APIResults = try! JSONDecoder().decode(APIResults.self, from: data!)

        self.theData = json.results
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
                let ciImage = CIImage.empty()
                let uiImage = UIImage(ciImage: ciImage)
                self.theImageCache.append(uiImage)
            }
        }
        print("images cached")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.theData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell for item at")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: theImageCache[indexPath.row], title: theData[indexPath.row].title)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.movie_title = theData[indexPath.row].title
        detailedVC.overview = theData[indexPath.row].overview
        detailedVC.release_date = theData[indexPath.row].release_date
        detailedVC.vote_average = theData[indexPath.row].vote_average
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.fetchDataForCollectionView()
            self.cacheImages()
        }
        else {
            let base_url = "https://api.themoviedb.org/3/search/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&language=en-US&query="
            let end_url = "&page=1&include_adult=false"
            let query_url = URL(string: base_url + searchText + end_url)
            print(query_url)
            self.fetchFilteredDataForCollectionView(from: query_url!)
            self.cacheImages()
        }
        DispatchQueue.main.async {
            self.movieCV.reloadData()
            print("reloading data")
        }
        
    }
}

