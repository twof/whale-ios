//
//  QuestionsTabViewController.swift
//  Whale
//
//  Created by fnord on 3/24/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit

class QuestionsTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    var questions = [Question]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
                
        WhaleService(endpoint: Whale.GetQuestions(perPage: 10, pageNum: 1)).get { (result) in
            switch result{
            case .Failure(let error):
                print(error)
            case .Success(let question):
                var currentQuestion = question as? Question
               
                while currentQuestion != nil {
                    self.questions.append(currentQuestion!)
                    currentQuestion = currentQuestion?.nextQuestion
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionCell
        
        cell.setupCell(question: self.questions[indexPath.row])
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    */

}
