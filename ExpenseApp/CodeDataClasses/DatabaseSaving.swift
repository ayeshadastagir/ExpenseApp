import UIKit
import CoreData

class DatabaseHandling {
    
    let app: AppDelegate
    let context: NSManagedObjectContext
    
    init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        self.app = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func saveIncome(incomeData: IncomeData) {
        let getIncome = NSEntityDescription.insertNewObject(forEntityName: Income.entityName, into: context) as? Income
        getIncome?.amount = incomeData.amount
        getIncome?.category = incomeData.category
        getIncome?.explaination = incomeData.explanation
        getIncome?.img = incomeData.image
        getIncome?.date = incomeData.date
        getIncome?.id = incomeData.id
        do {
            try context.save()
            print("Income Data has been saved")
        } catch {
            print("Income data cannot be saved")
        }
    }
    
    func saveExpense(expenseData: ExpenseData) -> Bool {
        guard let incomeList = fetchIncome(), !incomeList.isEmpty else {
            print("Cannot add expense: No income data exists")
            return false
        }
        var totalIncome: Double = 0.0
        incomeList.forEach { totalIncome += Double($0.amount) ?? 0.0 }
        
        var totalExistingExpenses: Double = 0.0
        let existingExpenses = fetchExpense() ?? []
        existingExpenses.forEach { expense in
            totalExistingExpenses += Double(expense.amount) ?? 0.0
        }
        
        let newExpenseAmount = Double(expenseData.amount) ?? 0.0
        let totalProposedExpenses = totalExistingExpenses + newExpenseAmount
        guard totalProposedExpenses <= totalIncome else {
            print("Cannot add expense: Expenses exceed total income")
            return false
        }
        
        let getExpense = NSEntityDescription.insertNewObject(forEntityName: Expense.entityName, into: context) as? Expense
        getExpense?.amount = expenseData.amount
        getExpense?.category = expenseData.category
        getExpense?.explaination = expenseData.explanation
        getExpense?.img = expenseData.image
        getExpense?.date = expenseData.date
        getExpense?.id = expenseData.id
        do {
            try context.save()
            print("Expense Data has been saved")
            return true
        } catch {
            print("Expense Data cannot be saved")
            return false
        }
    }
    
    func fetchIncome() -> [IncomeData]? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomeData = try context.fetch(fetchRequest)
            print("Income Data has been fetched")
            let incomeList = incomeData.map { income -> IncomeData in
                IncomeData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img! ,
                    date: income.date ?? Date(),
                    id: income.id ?? UUID())
            }
            return incomeList
        } catch {
            print("income data cannot be changed")
            return nil
        }
    }
    
    func fetchExpense() -> [ExpenseData]? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let expenseData = try context.fetch(fetchRequest)
            print("expense Data has been fetched")
            let expenseList = expenseData.map { income -> ExpenseData in
                ExpenseData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img! ,
                    date: income.date ?? Date(),
                    id: income.id ?? UUID())
            }
            return expenseList
        } catch {
            print("expense data cannot be fetched")
            return nil
        }
    }
    
    func deleteRecord<T: NSManagedObject>(type: T.Type, id: UUID)  {
        let fetchRequest: NSFetchRequest<T> = type.fetchRequest() as! NSFetchRequest<T>
        do {
            let results = try context.fetch(fetchRequest)
            
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                try context.save()
                print("Record deleted successfully")
            } else {
                print("No record found with the given ID")
            }
        } catch {
            print("Error deleting record")
        }
    }
    
    func fetchSpecificIncome(id: UUID) -> IncomeData? {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomeData = try context.fetch(fetchRequest)
            if let income = incomeData.first {
                let incomeDataModel = IncomeData(
                    amount: income.amount ?? "",
                    category: income.category ?? "",
                    explanation: income.explaination ?? "",
                    image: income.img ?? Data(),
                    date: income.date ?? Date(),
                    id: income.id ?? UUID() )
                return incomeDataModel
            } else {
                print("No income found for the given ID")
                return nil
            }
        } catch {
            print("Failed to fetch income data")
            return nil
        }
    }
        
    func fetchSpecificExpense(id: UUID) -> ExpenseData? {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let expenseData = try context.fetch(fetchRequest)
            if let expense = expenseData.first {
                let expenseModel = ExpenseData(
                    amount: expense.amount ?? "",
                    category: expense.category ?? "",
                    explanation: expense.explaination ?? "",
                    image: expense.img ?? Data(),
                    date: expense.date ?? Date(),
                    id: expense.id ?? UUID() )
                return expenseModel
            } else {
                print("No expense found for the given ID")
                return nil
            }
        } catch {
            print("Failed to fetch expense data")
            return nil
        }
    }
    
    func updateIncome(id: UUID, updatedIncomeData: IncomeData) -> Bool {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let incomeData = try context.fetch(fetchRequest)
            
            if let income = incomeData.first {
                income.amount = updatedIncomeData.amount
                income.category = updatedIncomeData.category
                income.explaination = updatedIncomeData.explanation
                income.img = updatedIncomeData.image
                income.date = updatedIncomeData.date
                income.id = updatedIncomeData.id
                try context.save()
                print("Income data updated successfully")
                return true
            } else {
                print("No income found with the given ID")
                return false
            }
        } catch {
            print("Failed to update income data")
            return false
        }
    }
    
    func updateExpense(id: UUID, updatedExpenseData: ExpenseData) -> Bool {
        
        guard let incomeList = fetchIncome(), !incomeList.isEmpty else {
            print("Cannot add expense: No income data exists")
            return false
        }
        var totalIncome: Double = 0.0
        incomeList.forEach { totalIncome += Double($0.amount) ?? 0.0 }
        
        var totalExistingExpenses: Double = 0.0
        let existingExpenses = fetchExpense() ?? []
        existingExpenses.forEach { expense in
            totalExistingExpenses += Double(expense.amount) ?? 0.0
        }
        
        let newExpenseAmount = Double(updatedExpenseData.amount) ?? 0.0
        let totalProposedExpenses = totalExistingExpenses + newExpenseAmount
        guard totalProposedExpenses <= totalIncome else {
            print("Cannot add expense: Expenses exceed total income")
            return false
        }
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenseData = try context.fetch(fetchRequest)
            
            if let expense = expenseData.first {
                
                expense.amount = updatedExpenseData.amount
                expense.category = updatedExpenseData.category
                expense.explaination = updatedExpenseData.explanation
                expense.img = updatedExpenseData.image
                expense.date = updatedExpenseData.date
                expense.id = updatedExpenseData.id
                
                try context.save()
                print("Income data updated successfully")
                return true
            } else {
                print("No income found with the given ID")
                return false
            }
        } catch {
            print("Failed to update income data")
            return false
        }
    }
            
}
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //func deleteIncome(amount: String, category: String, explanation: String, date: Date) {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        //    do {
        //        let results = try context.fetch(fetchRequest)
        //        for record in results {
        //            context.delete(record)
        //        }
        //        try context.save()
        //        print("Income record deleted successfully")
        //    } catch {
        //        print("Error deleting income record")
        //    }
        //}
        //
        //func deleteExpense(amount: String, category: String, explanation: String, date: Date) {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        //    do {
        //        let results = try context.fetch(fetchRequest)
        //        for record in results {
        //            context.delete(record)
        //        }
        //        try context.save()
        //        print("Income record deleted successfully")
        //    } catch {
        //        print("Error deleting expense record")
        //    }
        //}
        //func deleteAllIncome() {
        //       guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //       let context = app.persistentContainer.viewContext
        //       let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Income.fetchRequest()
        //       let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //
        //       do {
        //           try context.execute(deleteRequest)
        //           try context.save()
        //           print("All Income Data has been deleted")
        //       } catch {
        //           print("Error occurred during deleting all Income Data")
        //       }
        //   }
        
        //   func deleteAllExpense() {
        //       guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        //       let context = app.persistentContainer.viewContext
        //       let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Expense.fetchRequest()
        //       let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //
        //       do {
        //           try context.execute(deleteRequest)
        //           try context.save()
        //           print("All Expense Data has been deleted")
        //       } catch {
        //           print("Error occurred during deleting all Expense Data")
        //       }
        //   }
        //func fetchIncome() -> [IncomeData]? {
        //    guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        //    let context = app.persistentContainer.viewContext
        //    let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        //
        //    do {
        //        let incomeData = try context.fetch(fetchRequest)
        //        print("Income Data has been fetched")
        //
        //        let incomeList = incomeData.map { income -> IncomeData in
        //            IncomeData(
        //                amount: income.amount ?? "",
        //                category: income.category ?? "",
        //                explanation: income.explaination ?? "",
        //                image: UIImage(data: income.img!) ?? UIImage(named: "logo")!, // Provide a default image if `img` is nil
        //                date: income.date ?? Date()
        //            )
        //        }
        //
        //        return incomeList
        //    } catch {
        //        print("Error occurred during fetching Income Data: \(error.localizedDescription)")
        //        return nil
        //    }
        //}
