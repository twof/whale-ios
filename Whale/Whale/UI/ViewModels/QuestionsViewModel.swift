//
//  QuestionViewModel.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation

class QuestionsViewModel {
    var questions: [Question]! = []
    var isLoading = false
    
    private var page = 0
    private let perPage = 10
    
    init(withQuestions questions: [Question]?=nil, completion: @escaping (Bool) -> ()) {
        self.nextPage { (areNewQuestions) in
            completion(areNewQuestions)
        }
    }
    
    func nextPage(completion: @escaping (Bool) -> ()){
        self.isLoading = true
        
        WhaleService(endpoint: Whale.GetQuestions(perPage: self.perPage, pageNum: self.page)).get { (result) in
            
            switch result {
            case .Failure(let error):
                print(error)
                self.isLoading = false
                completion(false)
            case .Success(let newQuestion):
                var currentQuestion = newQuestion as? Question
                
                if currentQuestion?.id == nil {
                    self.isLoading = false
                    completion(false)
                    return
                }
                
                while currentQuestion != nil {
                    self.questions.append(currentQuestion!)
                    currentQuestion = currentQuestion?.nextQuestion
                }
                
                self.page += 1
                
                self.isLoading = false
                completion(true)
            }
        }
    }
}
