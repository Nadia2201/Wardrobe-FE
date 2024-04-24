//
//  AuthenticationServiceProtocol.swift
//  WardrobeApp
//
//  Created by Nadia Bourial on 23/04/2024.
//

public protocol AuthenticationServiceProtocol {
    func signUp(user: User) async throws
    func login(user: User, completion: @escaping (Result<String, Error>) -> Void)
}
