import UIKit

//var greeting = "Hello, playground"

class Temperature {
    var celcius: Double
    var fahr: Double
    var cal: Double

    init (celcius: Double, fahr: Double) {
        self.celcius = celcius
        self.fahr = fahr
        self.cal = 5.0
    }
}

extension Temperature {
    convenience init (celciusss: Double, fahr: Double) {
        self.init(celcius: celciusss, fahr: fahr)
//        self.celcius = celciusss
//        self.fahr = fahr
        self.cal = 5.0


        // если будет super, то надо сначала вызвать self.init, а внутри первым делом проинициализировать необходимые параметры (чтобы выделилась память на объект, чтобы программа поняла что нужна память), потом вызывать super,
        // а потом можно делать дополнительные настройки класса (override etc.)

        // логика такая, что мы доходим по 

        // двухфазная инициализация
    }
}

let first = Temperature(celcius: 4.0, fahr: 2.0)
