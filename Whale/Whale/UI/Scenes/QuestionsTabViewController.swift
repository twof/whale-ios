//
//  QuestionsTabViewController.swift
//  Whale
//
//  Created by fnord on 3/24/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit

class QuestionsTabViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var questionsViewModel: QuestionsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        questionsViewModel = QuestionsViewModel(completion: { (areNewQuestions) in
            switch areNewQuestions {
            case true:
                self.tableView.reloadData()
            case false:
                break
            }
        })
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

extension QuestionsTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = questionsViewModel.questions.count - 1
        
        if indexPath.row == lastElement && !self.questionsViewModel.isLoading {
            self.questionsViewModel.nextPage(completion: { (areNewQuestions) in
                switch areNewQuestions {
                case true:
                    self.tableView.reloadData()
                case false:
                    break
                }
            })
        }
    }
}

extension QuestionsTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsViewModel.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionCell
        
        cell.setupCell(question: self.questionsViewModel.questions[indexPath.row])
        
        return cell
    }
}

