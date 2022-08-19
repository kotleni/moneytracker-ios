//
//  SettingsViewModel.swift
//  MoneyTracker
//
//  Created by Victor Varenik on 24.07.2022.
//

import SwiftUI
import Combine

class SettingsViewModel: BaseViewModel {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isDeveloper: Bool = false
    @Published private(set) var isExperimental: Bool = false
    @Published private(set) var isPremium: Bool = false
    @Published private(set) var currency: String = ""
    @Published private(set) var exportJson: String = ""
    @Published var isExportJson: Bool = false
    
    /// Load data
    override func loadData() {
        currency = storageManager.getPriceType()
        isDeveloper = storageManager.isDeveloper()
        isExperimental = storageManager.isExperimental()
        
        // Check if product saved in keychain
        if let data = keychainManager.read(key: Static.subsExpirationKeychain),
           let expirationTimeInteval = try? JSONDecoder().decode(TimeInterval.self, from: data) {
            let subscriptionDate = Date(timeIntervalSince1970: expirationTimeInteval)
            isPremium = (Date() <= subscriptionDate)
            print("Settings load premium: \(isPremium)")
        }
    }
    
    /// Set is loading
    func setLoading(isEnabled: Bool) {
        isLoading = isEnabled
    }
    
    /// Export data
    func exportData() {
        var exportablePayments: Array<ExportablePayment> = []
        
        paymentsManager.getPayments().forEach { payment in
            exportablePayments.append(payment.exportPayment())
        }
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(exportablePayments)
            let jsonString = String(data: jsonData, encoding: .utf8)
            exportJson = jsonString ?? ""
            isExportJson = true
        } catch let error {
            print(error)
        }
        
        isLoading = false
    }
}
