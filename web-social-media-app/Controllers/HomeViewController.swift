//
//  HomeViewController.swift
//  web-social-media-app
//
//  Created by Paul Defilippi on 9/4/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import UIKit
import WebKit
import LBTATools
import Alamofire

struct Post: Decodable {
    let id: String
    let text: String
    let createdAt: Int
    let user: User
}

struct User: Decodable {
    let id: String
    let fullName: String
}

class HomeViewController: UITableViewController {
    // Terminal run ifconfig
    // should give you the ip address similar to 192.168.2.183

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCookies()

        navigationItem.rightBarButtonItem = .init(title: "Fetch Posts", style: .plain, target: self, action: #selector(fetchPosts))
        
        navigationItem.leftBarButtonItem = .init(title: "Log in", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    fileprivate func showCookies() {
        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            print(cookie)
        })
    }
    
    @objc func handleLogin() {
        print("Show login and sign up pages")
        let navController = UINavigationController(rootViewController: LoginViewController())
        present(navController, animated: true)
    }
    
    @objc func fetchPosts() {
        // returning JSON
        let url = "http://localhost:1337/post"
        Alamofire.request(url)
        .validate(statusCode: 200..<300)
            .responseData { (dataResponse) in
                if let err = dataResponse.error {
                    print("Failed to fetch posts: ", err)
                    return
                }
                
                guard let data = dataResponse.data else { return }
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = posts
                    self.tableView.reloadData()
                    
                } catch {
                    print(error)
                }
        }
        
        
        
       
        
        
        // Below is returning HTML
//        print("Attempt to fetch posts while unauthorized")
//
//        guard let url = URL(string: "http://localhost:1337/post") else { return }
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//
//            DispatchQueue.main.async {
//                if let err = err {
//                    print("Failed to hit server:", err)
//                    return
//                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
//                    print("Failed to fetch posts, statusCode:", resp.statusCode)
//                    return
//                } else {
//
//                    // ignore this for now
//                    print("Successfully fetched posts, response data:")
//                    let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
//                    print(html)
//                    let vc = UIViewController()
//                    let webView = WKWebView()
//                    webView.loadHTMLString(html, baseURL: nil)
//                    vc.view.addSubview(webView)
//                    webView.fillSuperview()
//                    self.present(vc, animated: true)
//                }
//            }
//
//
//            }.resume()
    }
    
    var posts = [Post]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.user.fullName
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = post.text
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
