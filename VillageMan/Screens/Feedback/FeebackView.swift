//
//  FeebackView.swift
//  VillageMan
//
//  Created by cauca on 11/10/21.
//

import SwiftUI
import Introspect

struct FeebackView: View {
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            registerForm
            switch viewModel.showLoading {
            case .loaded:
                LoadingView(loading: false).onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.presentationMode.wrappedValue.dismiss()
                        self.viewModel.showLoading = .notRequested
                    }
                }
            case .isLoading:
                LoadingView(loading: true).ignoresSafeArea()
            default:
                Spacer()
            }
        }.navigationBarTitle("Liên hệ với chúng tôi", displayMode: .inline)
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
                self.viewModel.tabBarController = tabBarController
            }.onDisappear {
                self.viewModel.tabBarController?.tabBar.isHidden = false
            }.onTapGesture {
                UIApplication.shared.windows.first?.endEditing(true)
            }
    }
    
    private var registerForm: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Nhập họ tên", text: $viewModel.name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 17))
                    .padding()
                    .frame(height: 40)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.sRGB, white: 0.9, opacity: 1)))
                TextField("Nhập số điện thoại", text: $viewModel.phone)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 17))
                    .padding()
                    .frame(height: 40)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.sRGB, white: 0.9, opacity: 1)))
                TextField("Nhập email", text: $viewModel.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 17))
                    .padding()
                    .frame(height: 40)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.sRGB, white: 0.9, opacity: 1)))
                ZStack(alignment: .topLeading) {
                    
                    TextEditor(text: $viewModel.comment)
                        .font(.system(size: 17))
                        .padding()
                        .frame(height: 120)
                        
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.sRGB, white: 0.9, opacity: 1)))
                    
                    if viewModel.comment.isEmpty {
                        Text("Nội dung").font(.robotoTitle).opacity(0.25).padding(EdgeInsets(top: 24, leading: 20, bottom: 0, trailing: 0))
                    }
                }
                
                Button("Gửi tin nhắn", action: viewModel.send)
                    .disabled(viewModel.name.isEmpty || (viewModel.phone.isEmpty && viewModel.email.isEmpty))
                    .frame(width: 140, height: 40, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color.mainColor)
                    .cornerRadius(20)
            }
            .padding(16)
            Spacer()
        }.onAppear {
            self.viewModel.comment = ""
        }
    }
    
}

struct FeebackView_Previews: PreviewProvider {
    static var previews: some View {
        FeebackView(viewModel: .init(service: ServiceMock())).previewLayout(.device)
    }
}

extension FeebackView {
    final class ViewModel: ObservableObject {
        
        @Published var name: String = ""
        @Published var phone: String = ""
        @Published var email: String = ""
        @Published var comment: String = ""
        
        @Published var showLoading: Loadable<Bool> = .notRequested
        
        weak var tabBarController: UITabBarController?
        
        private let service: Service
        private let cancelBag = CancelBag()
        
        init(service: Service) {
            self.service = service
        }
        
        func send() {
            self.showLoading = .isLoading(last: false, cancelBag: cancelBag)
            self.service.feedback(model: .init(name: name,
                                               phone: phone,
                                               email: email,
                                               content: comment))
                .map({ $0.code == 200 }).sinkToLoadable { result in
                    self.showLoading = result
                }.store(in: cancelBag)
        }
    }
}
