//
//  RegisterController.swift
//  web-social-media-app
//
//  Created by Paul Defilippi on 9/7/19.
//  Copyright © 2019 Paul Defilippi. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class RegisterController: LBTAFormController {
    
    // MARK: UI ELEMENTS
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "startup"), contentMode: .scaleAspectFit)
    let logoLabel = UILabel(text: "FullStack Social", font: .systemFont(ofSize: 32, weight: .heavy), textColor: .black, numberOfLines: 0)
    
    let fullNameTextField = IndentedTextField(placeholder: "Full Name", padding: 24, cornerRadius: 25)
    let emailTextField = IndentedTextField(placeholder: "Email", padding: 24, cornerRadius: 25)
    let passwordTextField = IndentedTextField(placeholder: "Password", padding: 24, cornerRadius: 25, isSecureTextEntry: true)
    
    lazy var signUpButton = UIButton(title: "Sign Up", titleColor: .white, font: .boldSystemFont(ofSize: 18), backgroundColor: .black, target: self, action: #selector(handleSignup))
    
    let errorLabel = UILabel(text: "Something went wrong during sign up, please try again later.", font: .systemFont(ofSize: 14), textColor: .red, textAlignment: .center, numberOfLines: 0)
    
    lazy var goBackButton = UIButton(title: "Go back to login.", titleColor: .black, font: .systemFont(ofSize: 16), target: self, action: #selector(goToRegister))
    
    @objc fileprivate func goToRegister() {
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSignup()
        return true
    }
    
    @objc fileprivate func handleSignup() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Registering"
        hud.show(in: view)
        
        guard let fullName = fullNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Service.shared.signUp(fullName: fullName, emailAddress: email, password: password) { (res) in
            
            hud.dismiss(animated: true)
            
            switch res {
            case .failure(let err):
                print("Failed to sign up:", err)
                self.errorLabel.isHidden = false
            case .success:
                print("Successfully signed up")
                self.dismiss(animated: true)
            }
        }
        
        //        let url = "http://localhost:1337/api/v1/entrance/signup"
        //        let params = ["fullName": fullName, "emailAddress": email, "password": password]
        //
        //        Alamofire.request(url, method: .post, parameters: params)
        //            .validate(statusCode: 200..<300)
        //            .responseData { (dataResp) in
        //
        //                hud.dismiss()
        //
        //                if let err = dataResp.error {
        //                    print("Failed to sign up:", err)
        //                    self.errorLabel.isHidden = false
        //                    return
        //                }
        //
        //                print("Successfully signed up")
        //                self.dismiss(animated: true)
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        emailTextField.autocapitalizationType = .none
        [fullNameTextField, emailTextField, passwordTextField].forEach{$0.backgroundColor = .white}
        signUpButton.layer.cornerRadius = 25
        
        view.backgroundColor = .init(white: 0.92, alpha: 1)
        
        let formView = UIView()
        formView.stack(
            formView.stack(formView.hstack(logoImageView.withSize(.init(width: 80, height: 80)), logoLabel.withWidth(160), spacing: 16, alignment: .center).padLeft(12).padRight(12), alignment: .center),
            UIView().withHeight(12),
            fullNameTextField.withHeight(50),
            emailTextField.withHeight(50),
            passwordTextField.withHeight(50),
            errorLabel,
            signUpButton.withHeight(50),
            goBackButton,
            UIView().withHeight(80),
            spacing: 16).withMargins(.init(top: 48, left: 32, bottom: 0, right: 32))
        
        formContainerStackView.addArrangedSubview(formView)
    }
}
