//
//  QuestionViewController.swift
//  AnimalQuiz
//
//  Created by Rudolf Amiryan on 04.11.23.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var singleButtonAnswer: UIButton!
    @IBOutlet weak var rangedSlider: UISlider! {
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.value = answerCount
        }
    }
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var multiplyStackView: UIStackView!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    
    @IBOutlet var singleButtons: [UIButton]!
    
    @IBOutlet var multiplyLabels: [UILabel]!
    
    @IBOutlet var rangedLabels: [UILabel]!
 
    @IBOutlet var multiplySwitches: [UISwitch]!
    //MARK: - Properties
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var answerChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[questionIndex].answer
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let currentIndex = singleButtons.firstIndex(of: sender) else {return}
        
        let currentAnswer = currentAnswers[currentIndex]
        answerChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multiplyAnswerPressed() {
        for (multiplySwitch, answer) in zip(multiplySwitches, currentAnswers) {
            if multiplySwitch.isOn {
                answerChosen.append(answer)
            }
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerPressed() {
        let index = Int(rangedSlider.value)
        answerChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
}

//MARK: - Private

extension QuestionViewController {
    private func updateUI() {
        // Hide stacks
        for stackView in [singleStackView, multiplyStackView, rangedStackView, singleButtonAnswer] {
            stackView?.isHidden = true
        }
        // get current question
        let currentQuestion = questions[questionIndex]
        
        // set current question for label
        questionLabel.text = currentQuestion.text
        
        // calculate progress
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        // set progress for progressview
        
        progressView.setProgress(totalProgress, animated: true)
        
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        // show current StackView
        showCurrentStackView(for: currentQuestion.type)
    }
    private func showCurrentStackView(for type: ResponseType) {
        switch type {
        case .single:
            showSingleStackView(with: currentAnswers)
        case .multiple:
            showMultiplyStackView(with: currentAnswers)
        case .range:
            showRangeStackView(with: currentAnswers)
        }
    }
    private func showSingleStackView(with answers: [Answer]) {
        singleStackView.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.text, for: .normal)
        }
    }
    
    private func showMultiplyStackView(with answers: [Answer]) {
        multiplyStackView.isHidden = false
        singleButtonAnswer.isHidden = false
        
        for (label, answer) in zip(multiplyLabels, answers) {
            label.text = answer.text
        }
    }
    
    private func showRangeStackView(with answers: [Answer]) {
        rangedStackView.isHidden = false
        
        rangedLabels.first?.text = answers.first?.text
        rangedLabels.last?.text = answers.last?.text
    }
    private func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
