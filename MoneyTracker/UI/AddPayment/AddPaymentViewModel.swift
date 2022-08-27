//
//  AddPaymentViewModel.swift
//  MoneyTracker
//
//  Created by Victor Varenik on 26.07.2022.
//

import SwiftUI
import Combine

class AddPaymentViewModel: BaseViewModel {
    @Published var isError: Bool = false
    @Published var tags: [Tag] = []
    @Published var selectedTag: Tag?
    @Published var priceText: String = ""
    @Published var aboutText: String = ""
    @Published var spendingBool: Bool = true
    
    /// Load all
    override func loadData() {
        TagsPublisher(tagsManager: tagsManager)
            .sink { tags in
                self.tags = tags
                self.resetTags()
            }
            .store(in: &publishers)
    }
    
    /// Add new payment
    func addPayment(price: Float, about: String, tag: Tag) {
        _ = paymentsManager.addPayment(price: price, about: about, tag: tag)
    }
    
    /// Try add new payment
    func tryAddPayment(onFinish: (_ isSuccess: Bool) -> Void) {
        guard let selectedTag = selectedTag else { return }
        let priceStr = priceText.replacingOccurrences(of: ",", with: ".")
        let mathExp = MathematicalExpression(line: priceStr)
        do {
            let sum = try mathExp.calculate()
            guard let value = Float(spendingBool ? "-\(sum)" : "\(sum)") else { return }
            let about = aboutText
            let tag = selectedTag
            
            addPayment(price: value, about: about, tag: tag)
            
            priceText = ""
            aboutText = ""
            spendingBool = true
            resetTags()
            onFinish(true)
        } catch let error {
#if DEBUG
            print(error)
#endif
            
            onFinish(false)
        }
    }
    
    func resetTags() {
        if let tag = tags.first {
            self.selectedTag = tag
        }
    }
    
    /// Show error
    func showError() { isError = true }
}
