//
//  PDFKitRepresentedView.swift
//  VacationUI
//
//  Created by Nikita Erokhin on 6/13/23.
//

import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    
    public let doc: PDFDocument?

    init(_ url: URL) {
        self.url = url
        self.doc = PDFDocument(url: url)
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = self.doc
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
    }
}
