//
//  NewsShowViewController.swift
//  OmnieCommerce
//
//  Created by msm72 on 09.11.16.
//  Copyright (c) 2016 Omniesoft. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Input & Output protocols
protocol NewsShowViewControllerInput {
    func displaySomething(viewModel: NewsShow.Something.ViewModel)
}

protocol NewsShowViewControllerOutput {
    func doSomething(request: NewsShow.Something.Request)
}

class NewsShowViewController: BaseViewController, NewsShowViewControllerInput {
    // MARK: - Properties
    var output: NewsShowViewControllerOutput!
    var router: NewsShowRouter!
    
    var dataSource = Array<News>()
    
    @IBOutlet weak var smallTopBarView: SmallTopBarView!
    @IBOutlet weak var copyrightLabel: CustomLabel!
    @IBOutlet weak var tableView: CustomTableView!

    
    // MARK: - Class Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NewsShowConfigurator.sharedInstance.configure(viewController: self)
    }
    

    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization
        for _ in 0 ..< 25 {
            let pathString = (arc4random_uniform(2) == 1) ? "http://www.nyhabitat.com/blog/wp-content/uploads/2013/08/fifth-avenue-shopping-manhattan-nyc-new-york.jpg" : nil
            
            dataSource.append(News(title: "Сауна Акваторія", logoStringURL: pathString, activeDate: Date.init(), description: "Вже давно відомо, що читабельний зміст буде заважати зосередитись людині, яка оцінює... композицію сторінки. Сенс використання Lorem Ipsum полягає в тому, що цей текст має більш-менш нормальне розподілення літер на відміну від, наприклад, \"Тут іде текст. Тут іде текст.\" Це робить текст схожим на оповідний. Багато програм верстування та веб-дизайну використовують Lorem Ipsum як зразок і пошук за терміном \"lorem ipsum\" відкриє багато веб-сайтів, які знаходяться ще в зародковому стані. Різні версії Lorem Ipsum з'явились за минулі роки, деякі випадково, деякі було створено зумисно (зокрема, жартівливі)."))
        }

        // Config topBarView
        smallTopBarView.type = "ParentSearch"
        topBarViewStyle = .Small
        setup(topBarView: smallTopBarView)

        // Register the Nib header/footer section views
        tableView.register(UINib(nibName: "BaseTableViewCell", bundle: nil), forCellReuseIdentifier: "DataCell")

        // Delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        doSomethingOnLoad()
    }
    

    // MARK: - Custom Functions
    func doSomethingOnLoad() {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Ask the Interactor to do some work
        let request = NewsShow.Something.Request()
        output.doSomething(request: request)
    }
    
    // Display logic
    func displaySomething(viewModel: NewsShow.Something.ViewModel) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        // NOTE: Display the result from the Presenter
        // nameTextField.text = viewModel.name
    }
    
    func setupScene(withSize size: CGSize) {
        print(object: "\(type(of: self)): \(#function) run. Screen view size = \(size)")
        
        smallTopBarView.setNeedsDisplay()
        smallTopBarView.circleView.setNeedsDisplay()
    }
    
    
    // MARK: - Transition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print(object: "\(type(of: self)): \(#function) run. New size = \(size)")
        
        setupScene(withSize: size)
    }
}


// MARK: - UITableViewDataSource
extension NewsShowViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setScrollIndicatorColor(color: UIColor.veryLightOrange)

        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! BaseTableViewCell
        let news = dataSource[indexPath.row] 
        
        // Config cell
        cell.setup(withItem: news)
        
        return cell
    }
}


// MARK: - 
extension NewsShowViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(object: "\(type(of: self)): \(#function) run.")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95.0
    }
}
