//
//  AboutView.swift
//  GameOfChores
//
//  Created by joakim lundberg on 2022-04-23.
//

import SwiftUI
import MessageUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    
    @State private var showEmailComposer = false
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    let emailData = EmailData(subject: "Need support!", recipients: ["joakim.lundb@gmail.com"])

    
    var body: some View {
        VStack {
            Text("Game of chores")
                .font(.largeTitle)
                .underline()
                .padding()
            Text("Created by Joakim Lundberg")
            
            Button("Support") {
                if EmailComposerView.canSendEmail() {
                    showEmailComposer = true
                } else {
                    alertMessage = "Unable to send an email from this device."
                    showAlert = true
                }
            }
            .frame(width: 220.0, height: 55.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .padding()
            .sheet(isPresented: $showEmailComposer, content: {
                     EmailComposerView(emailData: emailData) { result in
                         handleEmailComposeResult(result)
                     }
                 })
                /* .alert(isPresented: $showAlert, content: {
                     Alert(title: Text("mail results"),
                           message: Text(alertMessage),
                           dismissButton: .default(Text("Dismiss")))
                 })*/
            
            Button("LinkedIn") {
                openURL(URL(string: "https://www.linkedin.com/in/joakim-lundberg-5332a9170/")!)
            }
            .frame(width: 220.0, height: 55.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .padding()
            
            
            Button("FaceBook") {
                openURL(URL(string: "https://www.facebook.com/joakim.lundb/")!)
            }
            .frame(width: 220.0, height: 55.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .padding()
            
            Button("Instagram") {
                openURL(URL(string: "https://www.instagram.com/joalux/")!)
            }
            .frame(width: 220.0, height: 55.0)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .padding()
        }
    }
    
    func handleEmailComposeResult(_ result: Result<MFMailComposeResult, Error>) {
        switch result {
            case .success(let result):
                let resultString = ["Cancelled", "Saved", "Sent", "Failed"][result.rawValue]
                alertMessage = "Email result: \(resultString)"
            
            case .failure(let error):
                alertMessage = "Failed to send email.\n\(error.localizedDescription)"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showAlert = true
        }
    }

}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

struct EmailData {
    var subject: String = ""
    var recipients: [String]?
    var body: String = ""
    var isBodyHTML = false
    var attachments = [AttachmentData]()
    
    struct AttachmentData {
        var data: Data
        var mimeType: String
        var fileName: String
    }
}

struct EmailComposerView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let emailData: EmailData
    var result: (Result<MFMailComposeResult, Error>) -> Void
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let emailComposer = MFMailComposeViewController()
          emailComposer.mailComposeDelegate = context.coordinator
          emailComposer.setSubject(emailData.subject)
          emailComposer.setToRecipients(emailData.recipients)
          emailComposer.setMessageBody(emailData.body, isHTML: emailData.isBodyHTML)
          for attachment in emailData.attachments {
              emailComposer.addAttachmentData(attachment.data, mimeType: attachment.mimeType, fileName: attachment.fileName)
          }
          return emailComposer
    }
    
    static func canSendEmail() -> Bool {
            MFMailComposeViewController.canSendMail()
    }
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
           var parent: EmailComposerView
           
           init(_ parent: EmailComposerView) {
               self.parent = parent
           }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
             
             if let error = error {
                 parent.result(.failure(error))
                 return
             }
             
             parent.result(.success(result))
             
             parent.presentationMode.wrappedValue.dismiss()
         }
       }
       
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                   context: Context) {
        
    }
    
    
}
