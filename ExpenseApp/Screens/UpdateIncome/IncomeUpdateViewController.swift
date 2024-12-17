//
//  IncomeUpdateTestViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class IncomeUpdateViewController: IncomeViewController {

    private let recordId: UUID
    private var existingIncomeData: IncomeData?
    private var initialAmount: String?

    init(recordId: UUID) {
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        fetchExistingRecord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.setTitle( "Update", for: .normal)
    }
    
    private func fetchExistingRecord() {
        let dbHandler = DatabaseHandling()
        existingIncomeData = dbHandler?.fetchSpecificIncome(id: recordId)
        DispatchQueue.main.async {
            self.populateFields()
        }
    }
    
    private func populateFields() {
        guard let incomeData = existingIncomeData else { return }
        enterAmountTF.text = incomeData.amount
        explainationTF.text = incomeData.explanation
        selectCategoryView.didUpdateCategory(
            name: incomeData.category,
            img: UIImage(data: incomeData.image)
        )
        initialAmount = incomeData.amount
        super.validateFields()
    }

    override func dataSaved() {
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        let homeScreen = CustomTabBarController()
        homeScreen.modalTransitionStyle = .crossDissolve
        homeScreen.modalPresentationStyle = .fullScreen
        
        let updatedIncome = IncomeData(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage,
            date: existingIncomeData?.date ?? Date(),
            id: recordId )
        if dataHandler?.updateIncome(id: recordId, updatedIncomeData: updatedIncome, oldValue: initialAmount ?? "") == true {
            self.present(homeScreen, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Update Failed",
                message: "Unable to update income record. Expense exceeds income",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.present(homeScreen, animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
