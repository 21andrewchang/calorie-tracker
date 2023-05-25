//
//  AuthManager.swift
//  Ongry
//
//  Created by Andrew Chang on 4/1/23.
//
import FirebaseAuth
import Foundation

class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    public func startAuth(phoneNumber: String, completeion: @escaping (Bool) -> Void)
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self ]verificationId, error in
            guard let verificationId = verificationId, error == nil else{
                completeion(false)
                return
            }
            self?.verificationId =  verificationId
            completeion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completeion: @escaping (Bool) -> Void)
    {
        guard let verificationId = verificationId else{
            completeion(false)
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode
        )
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else{
                completeion(false)
                return
            }
            completeion(true)
        }
    }
    
}
