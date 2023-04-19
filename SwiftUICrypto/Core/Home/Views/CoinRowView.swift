//
//  CoinRowView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 06/04/23.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColoumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            
            leftColoumn
            
            Spacer()
            
            if showHoldingsColoumn {
               
                ceneterColoumn
            }
            
            
            rightColoumn
        }
        .font(.subheadline)
        .background(Color.theme.background.opacity(0.001))
        
        
    }
    
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColoumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColoumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}





extension CoinRowView {
    private var leftColoumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var ceneterColoumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue  .asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
            
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColoumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentage() ?? "")
                .foregroundColor(coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
            
        }
        //use Geometry reader if device orientation
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
    
    
    
    
    
}
