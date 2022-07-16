//
//  PaymentItemView.swift
//  MoneyTracker
//
//  Created by Victor Varenik on 13.07.2022.
//

import SwiftUI

struct PaymentItemView: View {
    var payment: Payment
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                HStack {
                    Text(payment.about!)
                    Spacer()
                }
                HStack {
                    Text((payment.price < 0) ? "🔻" : (payment.tag == nil) ? Tag.other.rawValue.localized : payment.tag!.localized)
                        .opacity(0.8)
                        .font(.system(size: 14))
                    Spacer()
                }
            }
            Spacer()
            Text("\(String(format: "%.2f", payment.price)) \(viewModel.priceType)")
                .foregroundColor(payment.price < 0 ? Color.init(.sRGB, red: 245/255, green: 97/255, blue: 76/255, opacity: 1.0) : Color.init(.sRGB, red: 81/255, green: 187/255, blue: 116/255, opacity: 1.0))
        }
    }
}
