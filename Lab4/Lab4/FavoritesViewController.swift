//
//  FavoritesViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/7/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Movie: Decodable {
        let id: Int!
        let poster_path: String?
        let title: String
        let release_date: String
        let vote_average: Double
        let overview: String
    }
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    var favorites: [Favorite]?
    
    override func viewDidLoad() {
        print("loading favorites...")
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("fav view did appear")
        self.fetchFavorites()
    }
    
    func fetchFavorites(){
        do {
            self.favorites = try context.fetch(Favorite.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error as NSError {
            print("could not fetch due to \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = favorites?[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell")
        let detailedVC = DetailedViewController()

        detailedVC.image = UIImage(data: favorites![indexPath.row].poster_img!)!
        detailedVC.movie_title = favorites![indexPath.row].title
        detailedVC.overview = favorites![indexPath.row].overview
        detailedVC.release_date = favorites![indexPath.row].release_date
        detailedVC.vote_average = favorites![indexPath.row].score as? Double
            
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let favToRemove = self.favorites![indexPath.row]
            self.context.delete(favToRemove)
            do {
                try self.context.save()
            }
            catch {
                print("was unable to save deletion")
            }
            
            self.fetchFavorites()
            }
        return UISwipeActionsConfiguration(actions: [action])
    }

}
