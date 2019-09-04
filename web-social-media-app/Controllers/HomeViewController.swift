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

class HomeViewController: UITableViewController {

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
        print("Attempt to fetch posts while unauthorized")
        
        guard let url = URL(string: "http://localhost:1337/post") else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to hit server:", err)
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    print("Failed to fetch posts, statusCode:", resp.statusCode)
                    return
                } else {
                    
                    // ignore this for now
                    print("Successfully fetched posts, response data:")
                    let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    print(html)
                    let vc = UIViewController()
                    let webView = WKWebView()
                    webView.loadHTMLString(html, baseURL: nil)
                    vc.view.addSubview(webView)
                    webView.fillSuperview()
                    self.present(vc, animated: true)
                }
            }
            
            
            }.resume()
    }

}
