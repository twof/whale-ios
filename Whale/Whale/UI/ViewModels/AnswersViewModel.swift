//
//  AnswersViewModel.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//


class AnswersViewModel {
    var answers: [Answer]! = []
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
            case .Success(let newAnswer):
                var currentAnswer = newAnswer as? Answer
                
                if currentAnswer?.id == nil {
                    self.isLoading = false
                    completion(false)
                    return
                }
                
                while currentAnswer != nil {
                    self.answers.append(currentAnswer!)
                    currentAnswer = currentAnswer?.nextAnswer
                }
                
                self.page += 1
                
                self.isLoading = false
                completion(true)
            }
        }
    }
}
