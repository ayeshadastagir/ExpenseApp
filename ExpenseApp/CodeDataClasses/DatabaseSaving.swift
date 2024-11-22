import UIKit
import CoreData

class DatabaseHandling {
    
    func saveIncome(incomeData: IncomeData) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = app.persistentContainer.viewContext
        let getIncome = NSEntityDescription.insertNewObject(forEntityName: "Income", into: context) as? Income
        getIncome?.amount = incomeData.amount
        getIncome?.category = incomeData.category
        getIncome?.explaination = incomeData.explanation
        getIncome?.img = incomeData.image
        getIncome?.date = incomeData.date
        do {
            try context.save()
            print("Income Data has been saved")
        } catch {
            print("Error occurred while saving income")
        }
    }

    func saveExpense(expenseData: ExpenseData) {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = app.persistentContainer.viewContext
        let getExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context) as? Expense
        
        getExpense?.amount = expenseData.amount
        getExpense?.category = expenseData.category
        getExpense?.explaination = expenseData.explanation
        getExpense?.img = expenseData.image
        getExpense?.date = expenseData.date
        
        do {
            try context.save()
            print("Expense Data has been saved")
        } catch {
            print("Error occurred: \(error.localizedDescription)")
        }
    }
    
    func fetchIncome() -> ([String], [String], [String], [UIImage], [Date])? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let incomeData = try context.fetch(fetchRequest)
            print("Income Data has been fetched")
            let amounts = incomeData.map { $0.amount ?? "" }
            let categories = incomeData.map { $0.category ?? "" }
            let explanations = incomeData.map { $0.explaination ?? "" }
            let images = incomeData.map { UIImage(data: $0.img!) ?? UIImage(named: "logo")! }
            let dates = incomeData.map { $0.date ?? Date() }
            return (amounts, categories, explanations, images, dates)
        } catch {
            print("Error occurred during fetching Income Data")
            return nil
        }
    }

    func fetchExpense() -> ([String], [String], [String], [UIImage], [Date])? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenseData = try context.fetch(fetchRequest)
            print("Expense Data has been fetched")
            let amounts = expenseData.map { $0.amount ?? "" }
            let categories = expenseData.map { $0.category ?? "" }
            let explanations = expenseData.map { $0.explaination ?? "" }
            let images = expenseData.map { UIImage(data: $0.img!) ?? UIImage(named: "logo")! }
            let dates = expenseData.map { $0.date ?? Date() }
            return (amounts, categories, explanations, images, dates)
        } catch {
            print("Error occurred during fetching Expense Data")
            return nil
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
