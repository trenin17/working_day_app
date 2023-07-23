import Foundation

public class ChainExample {
    
    public init() {}
    
    // Полезная нагрузка, по-сути JSON внутри body
    struct Payload: Codable {
        let name: String
    }
    
    // Ожидаемый ответ для статуса 200
    struct Response200: Codable {
        let status: String
        let data: String
    }
    
    // Ожидаемый ответ для статуса 404
    struct Response404: Codable {
        let errorDescription: String
    }
    
    // Ожидаемый ответ для статуса 500
    struct Response500: Codable {
        let failureReason: String
    }
    
    let session = VacationSession.unAuthorizedSession
    
    public func exampleSync() {
        let payload = Payload(name: "erokha")
        
        session.post(url: "http://localhost:5000/hello", payload: payload)
            .responseDecodable(statusCode: 200, of: Response200.self) { response in
                // Этот кложур вызовется, если ответ 200
                // и body конформит протоколу(распарсился в Response200)
                print("200 completion called. Now it's time to sleep")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                print("Good morning!")
            }
            .responseDecodable(statusCode: 404, of: Response404.self) { response in
                // Этот кложур вызовется, если ответ 404
                // и body конформит протоколу(распарсился в Response404)
                print(response)
            }
            .responseDecodable(statusCode: 500, of: Response500.self) { response in
                // Этот кложур вызовется, если ответ 500
                // и body конформит протоколу(распарсился в Response500)
                print(response)
            }.fallback { data in
                // Этот кложур вызовется тогда, и только тогда
                // когда ни один из вышеописанных кложуров не вызвался
                print(data.data?.prettyPrintedJSONString ?? "no json :(")
            }
    }
    
    public func exampleAsync() {
        let payload = Payload(name: "erokha")
        
        session.post(url: "http://localhost:5000/hello", payload: payload)
            .responseDecodable(statusCode: 200, of: Response200.self) { response async in
                // Этот кложур вызовется, если ответ 200
                // и body конформит протоколу(распарсился в Response200)
                // И он асинхронный!
                print("Yeah")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                print("Good morning!")
            }
            .responseDecodable(statusCode: 404, of: Response404.self) { response in
                // Этот кложур вызовется, если ответ 404
                // и body конформит протоколу(распарсился в Response404)
                // И он синхнронный! Мы можем мешать обычные и async вызовы!
                // А еще мы видим варнинг. Мы не вызвали fallback!
            }
    }
    
    private func makeViewModel() async -> ViewModel {
        let payload = Payload(name: "erokha")
        
        let viewModel = await session.get(
            url: "http://localhost:5000/hello", payload: payload
        ).handler(for: 200, of: Response200.self) { _ in
            return ViewModel(text: "we got 200 response")
        }.handler(for: 404, of: Response404.self) { _ in
            return ViewModel(text: "we got 404 response")
        }.fallback { _ in
            return ViewModel(text: "we got fallback")
        }
        
        return viewModel
    }
    
    private struct ViewModel {
        let text: String
    }
}
