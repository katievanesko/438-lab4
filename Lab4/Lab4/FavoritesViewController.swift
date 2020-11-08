//
//  FavoritesViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/7/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        //        cell.label!.text = theData[indexPath.row.title]
        //        cell.imageView?.image = theImageCache[indexPath.row]
        return cell
    }
    
    func setUpTableView() {
        //        tableView.dataSource = self
        //        tableView.delegate = self
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView(){
        //        let url = URL(string: "https://api.themoviedb.org/3/movie/550?api_key=bc86ebc978bfb13bc0c142825c1417b1") ?? <#default value#>
        //        let data = try! Data(contentsOf: url) //dont use !
        //        theData = try! JSONDecoder().decode([APIResults].self,from:data)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    


}
