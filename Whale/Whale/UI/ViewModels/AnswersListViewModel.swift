//
//  AnswersViewModel.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AnswerViewModel {
    private var answer: Answer
    
    init(answer: Answer) {
        self.answer = answer
    }
    
    var questionText: String {
        return answer.question.content
    }
    
    var questionSenderText: String {
        return answer.question.sender.username
    }
    
    var likesCountText: String {
        if let likesCount = answer.likesCount {
            return String(likesCount)
        }else{
            return "0"
        }
    }
    
    var commentCountText: String {
        if let commentCount = answer.commentCount {
            return String(commentCount)
        }else{
            return "0"
        }
    }
    
    var videoURLText: String {
        return self.answer.videoURL.absoluteString
    }
    
    fileprivate var nextAnswer: Answer? {
        return answer.nextAnswer
    }
    
    func getImage(completion: @escaping (UIImage) -> ()) {
        Alamofire.request(answer.thumbnailURL).responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}


class AnswersListViewModel {
    var answers: [AnswerViewModel]! = []
    var isLoading = false
    
    private var page = 0
    private let perPage = 10
    
    init(withAnswers answers: [Answer]?=nil, completion: @escaping (Bool) -> ()) {
        self.nextPage { (areNewQuestions) in
            completion(areNewQuestions)
        }
    }
    
    func nextPage(completion: @escaping (Bool) -> ()){
        self.isLoading = true
        
        WhaleService(endpoint: Whale.GetAnswers(perPage: self.perPage, pageNum: self.page)).get { (result) in
            
            switch result {
            case .Failure(let error):
                print(error)
                self.isLoading = false
                completion(false)
            case .Success(let answer):
                var currentAnswer = answer as? Answer
                
                if currentAnswer?.id == nil {
                    self.isLoading = false
                    completion(false)
                    return
                }
                
                while let newAnswer = currentAnswer {
                    self.answers.append(AnswerViewModel(answer: newAnswer))
                    currentAnswer = newAnswer.nextAnswer
                }
                
                self.page += 1
                
                self.isLoading = false
                completion(true)
            }
        }
    }
}
