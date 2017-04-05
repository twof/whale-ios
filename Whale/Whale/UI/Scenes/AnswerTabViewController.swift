//
//  AnswerTabViewController.swift
//  Whale
//
//  Created by fnord on 3/24/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AnswerTabViewController: UIViewController {
    
    @IBOutlet weak var answersTable: UITableView!
    
    var answerListViewModel: AnswersListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        answersTable.delegate = self
        answersTable.dataSource = self

        answerListViewModel = AnswersListViewModel(completion: { (areAnswers) in
            switch areAnswers {
            case true:
                self.answersTable.reloadData()
            case false:
                break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AnswerTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerItem = AVPlayerItem(url: URL(string: self.answerListViewModel.answers[indexPath.row].videoURLText)!)
        let avPlayer = AVPlayer(playerItem: playerItem)
        
        @IBAction func playPressed(_ sender: UIButton) {
            avPlayer.play()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = answerListViewModel.answers.count - 1
        
        if indexPath.row == lastElement && !self.answerListViewModel.isLoading {
            self.answerListViewModel.nextPage(completion: { (areNewAnswers) in
                switch areNewAnswers {
                case true:
                    self.answersTable.reloadData()
                case false:
                    break
                }
            })
        }
    }
}

extension AnswerTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerListViewModel.answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! AnswerCell
        
        return cell.setupCell(answer: answerListViewModel.answers[indexPath.row])
    }
}
