//
//  LoginView.swift
//  CharactersRickandMorty2
//

import SwiftUI
import UIKit
struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    // Credenciales mock
    private let validEmail = "rick@sanchez.com"
    private let validPassword = "pruebajim"
    
    var body: some View {
        if isLoggedIn {
            
            MainAppView()
        } else {
            loginContent
        }
    }
    
    // MARK: - Login Content
    
    private var loginContent: some View {
        ZStack {
            // Fondo
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // MARK: Header
                    headerSection
                    
                    // MARK: Form
                    formSection
                        .padding(.top, 48)
                    
                    // MARK: Footer
                    footerSection
                        .padding(.top, 24)
                }
                .padding(.horizontal, 28)
                .padding(.top, 60)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Logo / ícono
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 88, height: 88)
                Text("🛸")
                    .font(.system(size: 44))
            }
            
            Text("Rick and Morty")
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.primary)
            
            Text("Inicia sesión para continuar")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Form
    
    private var formSection: some View {
        VStack(spacing: 16) {
            
            // Email
            VStack(alignment: .leading, spacing: 6) {
                Text("Correo electrónico")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 10) {
                    Image(systemName: "envelope")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    TextField("rick@sanchez.com", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(UIColor.separator), lineWidth: 0.5)
                )
            }
            
            // Password
            VStack(alignment: .leading, spacing: 6) {
                Text("Contraseña")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 10) {
                    Image(systemName: "lock")
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    SecureField("••••••••", text: $password)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(UIColor.separator), lineWidth: 0.5)
                )
            }
            
            // Hint credenciales
            VStack(alignment: .leading, spacing: 2) {
                Text("Demo: rick@sanchez.com")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Text("Contraseña: pruebajim")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
            
            // Botón login
            Button {
                login()
            } label: {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Iniciar sesión")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid ? Color.green : Color.green.opacity(0.4))
                .cornerRadius(14)
            }
            .disabled(!isFormValid || isLoading)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Footer
    
    private var footerSection: some View {
        Text("se verificara la conexión a internet")
            .font(.system(size: 12))
            .foregroundColor(.secondary)
    }
    
    // MARK: - Logic
    
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }
    
    private func login() {
        isLoading = true
        
        // Simula delay de red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            
            if email.lowercased() == validEmail && password == validPassword {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isLoggedIn = true
                }
            } else {
                errorMessage = "Correo o contraseña incorrectos"
                showError = true
            }
        }
    }
}

// MARK: - MainAppView (wrapper para RMTabBarController)

struct MainAppView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UITabBarController {
        return RMTabBarController()
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {}
}

// MARK: - Preview

#Preview {
    LoginView()
}
