# YM-API - Неофициальная Swift библиотека Yandex Music

<p align="center">
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/YM-API">
        <img src="https://img.shields.io/cocoapods/v/YM-API.svg?style=flat">
    </a>
    <a href="http://cocoapods.org/pods/YM-API">
        <img src="https://img.shields.io/cocoapods/p/YM-API.svg?style=flat">
    </a>
    <a href="https://raw.githubusercontent.com/p0rterB/YM-API/master/LICENSE">
        <img src="https://img.shields.io/cocoapods/l/YM-API.svg?style=flat">
    </a>
</p>

Полностью портированное API Yandex Music на Swift.

Спасибо [MarshalX](https://github.com/MarshalX) за его [исследование Yandex Music API](https://habr.com/ru/post/462607) и саму [библиотеку на python](https://github.com/MarshalX/yandex-music-api).

## Содержание

- [Введение](#Введение)

- [Установка](#Установка)

- [Начало работы](#Начало-работы)

- [Примеры](#Примеры-использования)

- [Приложение-пример](#Приложение-пример)

- [Получение помощи](#Получение-помощи)

- [Благодарность](#Благодарность)

- [Лицензия](#Лицензия)

## Введение

Библиотека предоставляет интерфейс взаимодействия с API Яндекс Музыки.

Модуль разработан под macOS (10.14 и новее) и iOS (10.0 и новее).

### Доступ к вашим данным на Яндексе

Значения констант [CLIENT_ID и CLIENT_SECRET](https://github.com/p0rterB/YM-API/blob/master/Classes/API/YMClient.swift#L11)
позаимствованы у официального приложения-клиента сервиса Яндекс.Музыка из магазина
Microsoft Store. Так как API является закрытым и используется только внутри
компании Яндекс сейчас невозможно зарегистрировать своё собственное приложение на
[oauth.yandex.ru](https://oauth.yandex.ru),  а следовательно, использовать свои значения констант.

## Установка

YM-API доступно с помощью CocoaPods. Чтобы установить модуль, просто добавьте имя модуля в Podfile:

- Для iOS
```ruby
platform :ios, '10.0'
...
pod 'YM-API'
```

- Для macOS
```ruby
platform :osx, '10.14'
...
pod 'YM-API'
```

## Начало работы

Работа с API производится с помощью объекта [YMClient](https://github.com/p0rterB/YM-API/blob/main/Classes/API/YMClient.swift).

Инциализировать клиент можно 2 способами:

### Базовая, при первом запуске или отсутствии активной сессии

```swift
import YM_API

let client = YMClient.initialize(device: YMDevice, lang: ApiLanguage)
```
Параметр **device** - Информация об устройстве. Необходим, в основном, при работе с очередями воспроизведения
```swift
let device = YMDevice(os: "iOS", osVer: "14.6", manufacturer: "Apple",
    model: "iPhone8,4", clid: "app-store", 
    deviceId: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased(),
    uuid: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased())
```
Параметр **lang** - Локализация сервиса Яндекс Музыки. на выбор доступно 7 вариантов:
```swift
enum ApiLanguage: String {
    case en//Английский
    case uz//Узбекский
    case uk//Украинский
    case us//Английский (США)
    case ru//Русский
    case kk//Казахский
    case hy//Армянский
}
```

### Расширенная, при наличии активной сессии

```swift
import YM_API

let client = YMClient.initialize(device: YMDevice, lang: ApiLanguage, uid: Int,
    token: String, xToken: String)
```
Параметр **uid** - Идентификатор учетной записи

Параметр **token** - Токен активной сессии

Параметр **xToken** - Токен доступа к Passport Yandex

Для работы с сервисом при отсутствии активной сессии необходимо авторизоваться.

Авторизация происходит в 3 этапа. Основное требование - использование WKWebView

**I Шаг** - Сгенерировать ссылку для инициализации авторизации 

```swift
//String - Строковое представление ссылки
//URLRequest? - Объект запроса по сгенерированной ссылке
let pair: (String, URLRequest?) = client.generateInitAuthSessionRequest()
```

**II Шаг** - Авторизация в *passport.yandex.ru* через WKWebView через свою учетную запись, как это реализовано в официальном приложении Яндекс Музыка

```swift
webView_auth.navigationDelegate = self//Использование делегата необходимо для извлечения trackID и Ya-Client-Cookie из успешной авторизации
webView_auth.load(request)
```

**III Шаг** - Использование извлеченных trackID и Ya-Client-Cookie для генерации X-Токена и токена для яндекс музыки

## Примеры использования

При наличии инициализированного клиента с активной сессией возможно использовать все доступные методы из API.

### Получение списка сгенерированных ежедневных плейлистов в контексте ленты feed

```swift
client.getFeed { result in
    guard let feed = try? result.get() else {return}
    let playlists = feed.generatedPlaylists
}
```

### Получение данных по трекам плейлиста

Вариант с вызовом функции из экземпляра трека плейлиста
```swift
playlist.tracks?[index].fetchTrack(completion: { result in
    //Действия с данными по треку
})
```

Вариант с вызовом функции из объекта клиента
```swift
let trackIds = playlist.tracks?.map{ track in return track.trackId }
client.getTracks(trackIds: trackIds, positions: false) { result in
    //Действия с данными по трекам
}
```

### Получение ссылки на загрузку трека

```swift
var track: Track!
... acquiring track data...
track.getDownloadLink(codec: .mp3, bitrate: .kbps_192) {result in
    //Действия с ссылкой на загрузку
}
```

## Приложение пример

<p align="center">
<img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Images/appIcon.png?raw=true">
</p>

Под данное API было создано приложение под iOS (11.0+).
В нем реализован рабочий минимум: генерируемые Яндексом плейлисты, отображение содержимого этих плейлистов,
проигрывание композиций, возможность их лайкнуть или дизлайкнуть,
отображение 'моей коллекции' треков с возможностью прослушивания и поиск по трекам.
Также проигрыванием в приложении можно управлять в CarPlay через Центр Управления.
Его исходный код находится в открытом доступе.

<p align="center">
<img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/feed.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/playlistOfDay.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/nowPlaying.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/nowPlayingQueue.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/favourite.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/searchSuggestions.png?raw=true">          <img src="https://github.com/p0rterB/YM-API/blob/main/Project/ios/Screenshots/searchResults.png?raw=true">
</p>

Посетите [эту страницу](https://github.com/p0rterB/YM-API/tree/master/Project/ios/Rave), чтобы просмотреть исходный код приложения.

### Способы установки приложения

Данное приложение можно установить себе на устройство для тестирования несколькими способами:

### Простой и бесплатный
 Необходимо наличие мака, установленного XCode. Плюс необходимо иметь базовый аккаунт разработчика
 и добавленное в него Apple устройство. Обновляете зависимости pod в проекте и
 просто компилируете проект приложения-примера под свое устройство.
 Установленное приложение будет доступно 7 дней ввиду ограничений базового аккаунта разработчика
 
 ### Сложный и платный
 Необходимо иметь мак и аккаунт разработчика с проплаченной лицензией.
 На сайте [Apple Developer](https://developer.apple.com/account/) необходимо подготовить инфраструктуру для заливки:
 сертификаты, ID приложения (базовый набор capabilities), набор provision profiles
 Так можно использовать приложение уже не только на своем личном устройстве и не 7 дней.
 P.S. А если хотите показать всю широту своей души и, может быть, отблагодарить создателя, то можете залить приложение в TestFlight на открытое тестирование и поделиться ссылкой, которую размещу здесь=)
 

## Получение помощи

Если вы нашли проблемы или хотите предложить новую фичу в самом API
создайте [issue](https://github.com/p0rterB/YM-API/issues/new/choose)

По самому приложению дополнять кардинально нового ничего не планирую - оно в качестве примера использования API


## Лицензия

Вы можете копировать, распространять и модифицировать программное обеспечение
при условии, что модификации описаны и лицензированы бесплатно в соответствии
с  [LGPL-3](https://www.gnu.org/licenses/lgpl-3.0.html). Произведения
производных (включая модификации или что-либо статически связанное с библиотекой)
могут распространяться только в соответствии с LGPL-3, но приложения, которые
используют библиотеку, необязательно.
