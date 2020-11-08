//
//  DetailedViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/6/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    

    var image: UIImage!
    var movie_title: String?
    var overview: String?
    var release_date: String?
    var vote_average: Double?
    var favorites: [Favorite]?
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var favortieBtn: UIButton!
    @IBOutlet weak var overviewLabel: UILabel!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var btnFrame: CGRect!
    var btn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        let imageFrame = CGRect(x:view.frame.midX-112, y: 100, width: 224, height: 300)
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = image
        view.addSubview(imageView)
        
        let textFrame = CGRect(x: view.frame.midX - view.frame.width/2, y: 400, width: view.frame.width, height: 60)
        let textView = UILabel(frame: textFrame)
        textView.text = movie_title
        textView.textAlignment = .center
        textView.numberOfLines = 2
        textView.font = textView.font.withSize(20)
        
        view.addSubview(textView)
        
        let releaseFrame = CGRect(x: view.frame.midX - view.frame.width/2, y: 450, width: view.frame.width, height: 30)
        let releaseView = UILabel(frame: releaseFrame)
        releaseView.text = "Release Date: " + release_date!
        releaseView.textAlignment = .center
        view.addSubview(releaseView)
        
        let scoreFrame = CGRect(x: view.frame.midX - view.frame.width/2, y: 490, width: view.frame.width, height: 30)
        let scoreView = UILabel(frame: scoreFrame)
        scoreView.text = "Score: " + String(vote_average!) + "/10"
        scoreView.textAlignment = .center
        view.addSubview(scoreView)
        
        let overviewFrame = CGRect(x: view.frame.midX - view.frame.width/2, y: 540, width: view.frame.width, height: 15)
        let overviewView = UILabel(frame: overviewFrame)
        overviewView.text = "Overview: "
        overviewView.textAlignment = .center
        view.addSubview(overviewView)
        
        let overviewDescFrame = CGRect(x: view.frame.midX - view.frame.width/2+20, y: 555, width: view.frame.width-45, height: 80)
        let descView = UILabel(frame: overviewDescFrame)
        descView.text = overview
        descView.numberOfLines = 10
        descView.textAlignment = .center
        descView.backgroundColor = UIColor.clear
        descView.font = textView.font.withSize(10)
        view.addSubview(descView)
        
        btnFrame = CGRect(x: view.frame.midX-100, y: 650, width: 200, height: 40)
        btn = UIButton(frame: btnFrame!)
        btn.setTitle("Add to Favorites", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.systemBlue, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont(name: "System", size: 25)
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(self.addedToFavs(_:)), for: .touchUpInside)
        
        self.btn.setTitle("Added to Favorites", for: UIControl.State.disabled)
        self.btn.setTitleColor(UIColor.systemGray, for: UIControl.State.disabled)
        
        fetchFavorites()
    }
    
    func fetchFavorites(){
        do {
            self.favorites = try context.fetch(Favorite.fetchRequest())
            for fav in favorites! {
                 print(fav.title)
                if fav.title == self.movie_title {
                    self.btn.isEnabled = false
                    btn.layer.borderColor = UIColor.systemGray.cgColor
                }
            }
        } catch let error as NSError {
            print("could not fetch due to \(error), \(error.userInfo)")
        }
    }
    
    @objc func addedToFavs(_ sender: AnyObject?) {
        print("adding \(movie_title) to favs")
        DispatchQueue.main.async {
            let newFavorite = Favorite(context: self.context)
            newFavorite.title = self.movie_title
            try! self.context.save()
        }

        self.btn.isEnabled = false
        btn.layer.borderColor = UIColor.systemGray.cgColor
        
    }
}
