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
    var searchQuery: String = ""
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var movieCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
       searchBtn.layer.borderColor = UIColor.systemBlue.cgColor
       searchBtn.layer.cornerRadius = 5.0
       searchBtn.layer.borderWidth = 1
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.fetchDataForCollectionView()
            self.cacheImages()
            DispatchQueue.main.async {
                self.movieCV.reloadData()
                self.stopSpinner()
            }
        }
        searchBar.delegate = self
        activityIndicator.startAnimating()
        activityIndicator.layer.zPosition = 1
        activityIndicator.hidesWhenStopped = true
        
    }
    
    func stopSpinner(){
        self.activityIndicator.layer.zPosition = -1
        self.activityIndicator.stopAnimating()
    }
    
    func setUpCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 115, height: 170)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 10)
        movieCV.collectionViewLayout = layout

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
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.layer.zPosition = 1
            self.activityIndicator.style = .whiteLarge
        }
        print("getting filtered data...")
                   let data = try? Data(contentsOf: url)
                   let json:APIResults = try! JSONDecoder().decode(APIResults.self, from: data!)
                   self.theData = json.results
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
           DispatchQueue.main.async {
               self.stopSpinner()
           }
        }
        
        
        //FIND WAY TO CHECK FOR ALL VALUES, AND ADJUST IF ONE NOT PRESENT
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
        let detailedVC = DetailedViewController()
        detailedVC.image = theImageCache[indexPath.row]
        detailedVC.movie_title = theData[indexPath.row].title
        detailedVC.overview = theData[indexPath.row].overview
        detailedVC.release_date = theData[indexPath.row].release_date
        detailedVC.vote_average = theData[indexPath.row].vote_average
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        searchBarTextDidEndEditing(searchBar)
    }
    
    @IBAction func searchCall(_ sender: Any) {
        activityIndicator.startAnimating()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchQuery == ""{
            self.fetchDataForCollectionView()
            self.cacheImages()
            
        } else {
            let base_url = "https://api.themoviedb.org/3/search/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&language=en-US&query="
            let end_url = "&page=1&include_adult=false"
            let query_url = URL(string: base_url + searchQuery + end_url)
            
            DispatchQueue.main.async {
                self.fetchFilteredDataForCollectionView(from: query_url!)
                self.cacheImages()
                self.movieCV.reloadData()
                print("reloading data")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
        if searchText == ""{
            self.fetchDataForCollectionView()
            self.cacheImages()
            DispatchQueue.main.async {
                self.movieCV.reloadData()
                print("reloading data")
            }
        }
        
        
    }
}

