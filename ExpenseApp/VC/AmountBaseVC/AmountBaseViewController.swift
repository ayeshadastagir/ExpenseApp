//
//  AmountBaseViewController.swift
//  ExpenseApp
//
//  Created by Ayesha Dastagir on 17/12/2024.
//

import Foundation

class AmountBaseViewController {
    
    func checkFields(amount: String, category: String, description: String) -> Bool {
        let isAmountFilled = !amount.isEmpty
        let isCategorySelected = category != "Category"
        let isDescriptionFilled = !description.isEmpty
        if isAmountFilled && isCategorySelected && isDescriptionFilled {
            return true
        } else {
            return false
        }
    }
}
