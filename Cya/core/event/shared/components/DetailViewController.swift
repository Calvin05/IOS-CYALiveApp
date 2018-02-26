//
//  DetailViewController.swift
//  Cya
//
//  Created by Rigo on 09/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var viewHeader: UIImageView!
    
    @IBOutlet weak var userAvata: UIImageView!
    @IBOutlet weak var userAvata2: UIImageView!
    @IBOutlet weak var userAvata3: UIImageView!
    
    

    @IBAction func stage(_ sender: Any) {


    }
    
    //detailCandy
    var detailEvent: Event? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


