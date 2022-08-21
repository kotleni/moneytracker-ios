//
//  AddPaymentView.swift
//  MoneyTracker
//
//  Created by Victor Varenik on 12.07.2022.
//

import SwiftUI

struct AddPaymentView: View {
    @EnvironmentObject var router: HomeCoordinator.Router
    @ObservedObject var viewModel: AddPaymentViewModel
    
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.spendingBool) {
                Text("segment_expenses".localized)
                    .tag(true)
                Text("segment_income".localized)
                    .tag(false)
            }
            .pickerStyle(.segmented)
            .padding()
            
            Form {
                Section {
                    HStack {
                        Text("field_price".localized)
                        Spacer()
                        TextField("hint_necessarily".localized, text: $viewModel.priceText)
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .frame(width: UIScreen.main.bounds.width / 3)
                    }
                    HStack {
                        Text("field_desc".localized)
                        Spacer()
                        TextField("hint_necessarily".localized, text: $viewModel.aboutText)
                            .multilineTextAlignment(.trailing)
                            .frame(width: UIScreen.main.bounds.width / 3)
                    }
                    if viewModel.spendingBool {
                        HStack {
                            Text("label_tag".localized)
                            Spacer()
                            Picker("", selection: $viewModel.selectedTag) {
                                ForEach(viewModel.tags, id: \.self) { tag in
                                    Text(tag.emoji! + " " + tag.name!)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
                } footer: {
                    Text("hint_payment".localized)
                }
            }
            .navigationBarTitle("title_newpayment".localized, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if PriceExpressionValidator.validate(str: viewModel.priceText) && !viewModel.aboutText.isEmpty {
                            viewModel.tryAddPayment() { isSuccess in
                                    if isSuccess {
                                        router.popToRoot()
                                        
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.success)
                                    } else {
                                        viewModel.showError()
                                    }
                                }
                        } else {
                            viewModel.showError()
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.error)
                        }
                    } label: {
                        Text("btn_next".localized)
                    }
                }
            }
        }
        .toast(message: "toast_invalidpaydata".localized, isShowing: $viewModel.isError, config: .init())
        .onAppear { viewModel.loadData() }
    }
}

struct AddPaymentPreview: PreviewProvider {
    static var previews: some View {
        AddPaymentView(viewModel: AddPaymentViewModel.init(paymentsManager: PaymentsManager(), storageManager: StorageManager(), notificationsManager: NotificationsManager(), tagsManager: TagsManager(), storeManager: StoreManager(keychain: KeychainManager(), productsIDs: .init()), keychainManager: KeychainManager()))
    }
}
