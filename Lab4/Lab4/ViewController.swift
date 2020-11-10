//
//  ViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit
import Network

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
        let release_date: String?
        let vote_average: Double?
        let overview: String?
    }
    
    var theData : [Movie] = []
    var theImageCache : [UIImage] = []
    var theImageCacheHR : [UIImage] = []
    var searchQuery: String = ""
    
    var punctuation:[Character:String] = [
           "'": "%27",
           " ": "%20",
           ",": "%2C",
           ";": "%3B",
           ":": "%3A",
           "/": "%2F",
           "?": "%3F",
           "[": "%5B",
           "]": "%5D",
           "(": "%28",
           ")": "%29",
           "{": "%7B",
           "}": "%7D",
           "!": "%21"
       ]
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var movieCV: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var movieDataLabel: UILabel!
    @IBOutlet weak var TMDbLogo: UIImageView!
    @IBOutlet weak var refreshBtn: UIButton!
    
    var isConnectedToInternet: Bool =  false
    let nwPathMonitor = NWPathMonitor()
    let bkgd_queue = DispatchQueue.global(qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        searchBtn.layer.borderColor = UIColor.systemBlue.cgColor
        searchBtn.layer.cornerRadius = 5.0
        searchBtn.layer.borderWidth = 1
        activityIndicator.startAnimating()
        activityIndicator.layer.zPosition = 1
        activityIndicator.hidesWhenStopped = true
        searchBar.delegate = self
        TMDbLogo.image = UIImage(named: "TMDb")
        self.movieDataLabel.text = ""
        self.movieDataLabel.layer.zPosition = 1
        refreshBtn.isHidden = true
        nwPathMonitor.start(queue: bkgd_queue)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let status = self.nwPathMonitor.currentPath.status
            print(status)
            if status == .satisfied {
                print("Connected!!!!")
                self.isConnectedToInternet = true
                 DispatchQueue.main.async {
                    self.fetchDataForCollectionView()
                    self.cacheImages()
                    self.movieCV.reloadData()
                }
            }
            else {
                print("not connected.... :(")
                DispatchQueue.main.async {
                    self.isConnectedToInternet = false
                    self.TMDbLogo.image = UIImage(named: "blank")
                    self.movieDataLabel.text = "Connect to internet to load movie data"
                    self.refreshBtn.isHidden = false
                }
            }
           DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.nwPathMonitor.cancel()
           }
       }
    }
    
    func stopSpinner(){
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func refreshForInternet(_ sender: Any) {
        let monitor = NWPathMonitor()
        let q = DispatchQueue.global(qos: .userInitiated)
        monitor.start(queue: q)
        
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                self.isConnectedToInternet = true
                self.fetchDataForCollectionView()
                self.cacheImages()
                DispatchQueue.main.sync {
                    self.movieCV.reloadData()
                }
            } else {
                self.isConnectedToInternet = false
            }
        }
        DispatchQueue.main.async {
            self.stopSpinner()
            if self.isConnectedToInternet == true {
                self.TMDbLogo.image = UIImage(named: "TMDb")
                self.movieDataLabel.text = "   "
                self.refreshBtn.isHidden = true
            }
            monitor.cancel()
        }
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
        print("fetching data...")
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&sort_by=popularity.desc")
        do {
            let data = try Data(contentsOf: url!)
            let json:APIResults = try JSONDecoder().decode(APIResults.self, from: data)
            self.theData = json.results
        } catch {
            print("fetching data failed")
        }
    }
    
    func fetchFilteredDataForCollectionView(from url:URL) {
        print("fetching filtered data...")
        let data = try? Data(contentsOf: url)
        let json:APIResults = try! JSONDecoder().decode(APIResults.self, from: data!)
        self.theData = json.results
    }
    
    func cacheImages(){
        print("caching images...")
        theImageCache = []
        theImageCacheHR = []
        let base_url = "https://image.tmdb.org/t/p/w500"
        let hr_base_url = "https://image.tmdb.org/t/p/original"
        for movie in self.theData {
            if let poster_img = movie.poster_path {
                let image_url = base_url + poster_img
                let url = URL(string: image_url)
                do {
                    let data = try Data(contentsOf: url!)
                    let img = UIImage(data: data)
                    self.theImageCache.append(img!)
                }
                catch {
                    print("could not get contents of url for img")
                }
                
                let hr_image_url = hr_base_url + poster_img
                let hr_url = URL(string: hr_image_url)
                do {
                    let hr_data = try Data(contentsOf: hr_url!)
                    let hr_img = UIImage(data: hr_data)
                    self.theImageCacheHR.append(hr_img!)
                } catch {
                    print("could not get contents of url for hd img")
                }
            }
            else{
                let image = UIImage(named: "poster_not_avail")
                self.theImageCache.append(image!)
                self.theImageCacheHR.append(image!)
            }
        }
        DispatchQueue.main.async {
            self.movieCV.reloadData()
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
        detailedVC.image = theImageCacheHR[indexPath.row]
        
        detailedVC.movie_title = theData[indexPath.row].title
        detailedVC.overview = theData[indexPath.row].overview
        detailedVC.release_date = theData[indexPath.row].release_date
        detailedVC.vote_average = theData[indexPath.row].vote_average
        detailedVC.movie_id = theData[indexPath.row].id
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        activityIndicator.startAnimating()
        print("searching...")
        let monitor = NWPathMonitor()
        let q = DispatchQueue.global(qos: .userInitiated)
        monitor.start(queue: q)
        monitor.pathUpdateHandler = { path in
            print(path.status)
            if path.status == .satisfied {
                self.searchBarTextDidEndEditing(self.searchBar)
            } else {
                DispatchQueue.main.async {
                    self.movieCV.reloadData()
                    self.TMDbLogo.image = UIImage(named: "blank")
                    self.movieDataLabel.text = "Connect to internet to load movie data"
                    self.refreshBtn.isHidden = false
                }
            }
            monitor.cancel()
        }
    }
    
    @IBAction func searchCall(_ sender: Any) {
        activityIndicator.startAnimating()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            print("beginning spinner")
        }
        if self.searchQuery == ""{
            DispatchQueue.main.async {
//                self.activityIndicator.startAnimating()
                self.fetchDataForCollectionView()
                self.cacheImages()
                self.activityIndicator.stopAnimating()
                print("ending spinner")
                self.movieCV.reloadData() //??????
            }
        } else {
            let base_url = "https://api.themoviedb.org/3/search/movie?api_key=bc86ebc978bfb13bc0c142825c1417b1&language=en-US&query="
            let end_url = "&page=1&include_adult=false"
            var query = ""
            for char in self.searchQuery {
                if self.punctuation[char] != nil {
                    query.append(self.punctuation[char]!)
                } else {
                    query.append(char)
                }
            }
            let query_url = URL(string: base_url + query + end_url)
            DispatchQueue.main.async {
//                self.activityIndicator.startAnimating()
                self.fetchFilteredDataForCollectionView(from: query_url!)
                self.cacheImages()
                self.movieCV.reloadData()
                print("ending spinner")
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
        
        if searchText == ""{
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            DispatchQueue.main.async {
                self.fetchDataForCollectionView()
                self.cacheImages()
                self.movieCV.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

