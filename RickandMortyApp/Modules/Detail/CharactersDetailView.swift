//
//  CharactersDetailView.swift
//  CharactersRickandMorty2
//
//  Created by Jimena Hernández García on 12/03/26.
//

import SwiftUI

// MARK: - CharacterDetailView

/// Vista de detalle del personaje desarrollada en SwiftUI
/// Se presenta desde ambos módulos: Characters y Favorites
struct CharacterDetailView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: CharacterDetailViewModel
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: Imagen
                AsyncImage(url: URL(string: viewModel.character.image)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(Color(.systemGray5))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: Nombre y favorito
                    HStack {
                        Text(viewModel.character.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Divider()
                    
                    // MARK: Status
                    InfoRowView(
                        icon: "circle.fill",
                        iconColor: viewModel.character.status == .alive ? .green :
                                   viewModel.character.status == .dead ? .red : .gray,
                        title: "Status",
                        value: viewModel.character.status.displayText
                    )
                    
                    // MARK: Especie
                    InfoRowView(
                        icon: "pawprint.fill",
                        iconColor: .blue,
                        title: "Especie",
                        value: viewModel.character.species
                    )
                    
                    // MARK: Género
                    InfoRowView(
                        icon: "person.fill",
                        iconColor: .purple,
                        title: "Género",
                        value: viewModel.character.gender.rawValue
                    )
                    
                    // MARK: Origen
                    InfoRowView(
                        icon: "globe.americas.fill",
                        iconColor: .orange,
                        title: "Origen",
                        value: viewModel.character.origin.name
                    )
                    
                    // MARK: Última ubicación
                    InfoRowView(
                        icon: "location.fill",
                        iconColor: .green,
                        title: "Última ubicación",
                        value: viewModel.character.location.name
                    )
                    
                    // MARK: Episodios
                    InfoRowView(
                        icon: "tv.fill",
                        iconColor: .indigo,
                        title: "Episodios",
                        value: "\(viewModel.character.episode.count) episodios"
                    )
                    
                    // MARK: Tipo
                    if !viewModel.character.type.isEmpty {
                        InfoRowView(
                            icon: "tag.fill",
                            iconColor: .pink,
                            title: "Tipo",
                            value: viewModel.character.type
                        )
                    }
                }
                .padding(20)
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - InfoRowView

/// Componente reutilizable para mostrar una fila de información
struct InfoRowView: View {
    
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
