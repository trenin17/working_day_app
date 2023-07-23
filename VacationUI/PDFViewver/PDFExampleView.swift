import SwiftUI

struct VacationPDFView: View {
    
    let url: URL
    
    var body: some View {
        VStack {
            docView
            shareButton.frame(height: 50)
            Spacer()
        }
    }
            
    var docView: PDFKitRepresentedView {
        PDFKitRepresentedView(url)
    }
    
    @ViewBuilder
    var shareButton: some View {
        if let doc = docView.doc {
            ShareLink(
                item: doc,
                preview: SharePreview(
                    "Поделится своим отпуском",
                    image: Image(systemName: "plus")
                )
            )
        } else {
            EmptyView()
        }
    }
    
}


struct VacationPDFView_Previews: PreviewProvider {
    static let url = URL(string: "https://www.africau.edu/images/default/sample.pdf")!
    static var previews: some View {
        VacationPDFView(url: url)
    }
}
