//
//  DetailView.swift
//  SwiftUICrypto
//
//  Created by Inspironlabs on 14/04/23.
//

import SwiftUI


struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
    
}

struct DetailView: View {
    
    @StateObject var vm : DetailViewModel
    @State private var showFullDescription: Bool = false
    private let coloumn: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    private let spacing: CGFloat = 30
    
    let coin: CoinModel
    
    init(coin:CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    
    
    var body: some View {
        ScrollView {
            
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    
                    overviewTitle
                    Divider()
                    descriptionSection
                    
                    overViewGrid
                    adittonlaTitle
                    Divider()
                    additonlaGrid
                }
                
               
                
            }
            .padding()
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBartarilingitems
                }
            }
            .navigationTitle(vm.coin.name)
            
        }
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}



extension DetailView {
    private var navigationBartarilingitems: some View {
        HStack {
            Text(vm.coin.symbol)
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
            
        }
    }
    
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var adittonlaTitle: some View{
        
        Text("Additonal Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewGrid: some View {
        LazyVGrid(columns: coloumn, alignment: .leading, spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.overViewStatisics) { stat in
                StatisticView(stat: stat)
            }
            
        }
                  .padding()
    }
    
    
    private var additonlaGrid: some View {
        LazyVGrid(columns: coloumn, alignment: .leading, spacing: 20,
                  pinnedViews: []) {
            ForEach(vm.additonalStatisics) { stat in
                StatisticView(stat: stat)
            }
            
        }
                  .padding()
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let description = vm.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                        
                    } label: {
                        Text(showFullDescription ? "Less" :"Read more")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let websiteUrl = vm.websiteURL, let url = URL(string: websiteUrl) {
                Link("Website", destination: url)
            }
            
            if let websiteUrl = vm.websiteURL {
                if let url = URL(string: websiteUrl) {
                    Link("Website", destination: url)
                }
            }
            
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
