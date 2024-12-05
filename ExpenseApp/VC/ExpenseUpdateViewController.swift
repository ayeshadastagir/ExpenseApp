//
//  ExpenseUpdateTestViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 05/12/2024.
//

import UIKit

class ExpenseUpdateViewController: ExpenseViewController {

    private let recordId: UUID
    private var existingExpenseData: ExpenseData?
    private var initialAmount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.setTitle( "Update", for: .normal)
    }
    
    init(recordId: UUID) {
        self.recordId = recordId
        super.init(nibName: nil, bundle: nil)
        fetchExistingRecord()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchExistingRecord() {
        let dbHandler = DatabaseHandling()
        existingExpenseData = dbHandler?.fetchSpecificExpense(id: recordId)
        DispatchQueue.main.async {
            self.populateFields()
        }
    }
    
    private func populateFields() {
        guard let expenseData = existingExpenseData else { return }
        enterAmountTF.text = expenseData.amount
        explainationTF.text = expenseData.explanation
        selectCategoryView.didUpdateCategory(
            name: expenseData.category,
            img: UIImage(data: expenseData.image)
        )
        initialAmount = expenseData.amount
        super.validateFields()
    }
    
    override func dataSaved() {
        let dataHandler = DatabaseHandling()
        guard let selectedImage = selectCategoryView.logo.image?.pngData() else { return }
        
        let updatedExpense = ExpenseData(
            amount: enterAmountTF.text?.justifyNumber ?? "",
            category: selectCategoryView.selectedCategoryLabel.text ?? "",
            explanation: explainationTF.text ?? "",
            image: selectedImage,
            date: existingExpenseData?.date ?? Date(),
            id: recordId )
        
        let homeScreen = CustomTabBarController()
        homeScreen.modalTransitionStyle = .crossDissolve
        homeScreen.modalPresentationStyle = .fullScreen
        
        if dataHandler?.updateExpense(id: recordId, updatedExpenseData: updatedExpense, oldAmount: initialAmount ?? "") == true {
            self.present(homeScreen, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Update Failed",
                message: "Unable to update expense record.",
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
