import Foundation

class ModernAsyncAwaitExample {
//    Чутка подумав я решил, что нам очень удобно
//    будет работать с async/await. Поэтому теперь
//    новая сеть поддерживает работу со swift cuncurrency.
//
//    В чем основное отличие: можем не делать миллион
//    кложур, в которых будем дергать из интерактора
//    презентер. Теперь мы можем из метода fetchЧто-то-там...
//    прям сразу выдавать ответ. Например, в виде enum'а
//    вида с двумя case'ами: либо тип ошибки, либо ответ
//
//
//    Привожу пример использования, который вижу я:
    
    // Результат работы клиента - либо ошибка, либо данные
    enum ClientResult {
        case numberOfSubscribers(String)
        case errorDescription(String)
    }
    
    struct ClientPayload: Encodable {
        let id: String
    }
    
    class Client {
        private let session = VacationSession.unAuthorizedSession
        
        func fetchSubscribers(for id: String) async -> ClientResult {
            //отправляем запрос
            await session.get(
                url: "/subscribers-for-id",
                payload: ClientPayload(id: id),
                shouldMapResultTo: ClientResult.self    // необязательный параметр, ускоряет
                                                        // стат. анализатор. быстрее работает
                                                        // подсветка синтаксиса
            ).handler(for: 200, of: Int.self) { value in
                //И все хендлеры должны вернуть нам ClientResult
                return ClientResult.numberOfSubscribers("\(value)")
            }
            .handler(for: 205, of: EmptyDecodable.self) { value in
                // И в кложурах можем делать await, если надо
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                return ClientResult.numberOfSubscribers("дохуя")
            }
            .fallback { _ in
                // Фоллбер тоже вовзращает ClientResult
                return ClientResult.errorDescription("Что-то пошло не так")
            }
            
            // Кстати, можно работать и как раньше. Просто все маппить в Void
        }
    }
    
    // А это провайдер
    class Provider {
        private let profileId: String
        private let client = Client()
        
        init(profileId: String) { self.profileId = profileId }
        
        
        // При обращении - делаем запрос в подписчиков, и как только зафетчим
        // отдадим его запращивателю
        var subscribersCount: String {
            get async {
                let count = await client.fetchSubscribers(for: profileId)
                return "\(count) подписчиков"
            }
        }
    }
    
    fileprivate struct EmptyDecodable: Decodable {}
}
