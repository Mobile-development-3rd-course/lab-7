<div align = "center"><strong>
Міністерство освіти і науки України<br>
Національний технічний університет України<br>
«Київський політехнічний інститут ім. Ігоря Сікорського»<br>
Факультет інформатики та обчислювальної техніки<br>
Кафедра обчислювальної техніки<br><br><br><br>
</strong></div>

<div align = "center" bold = ""><strong>ЛАБОРАТОРНА РОБОТА № 1</strong><br><br>
з дисципліни «Розроблення клієнтських додатків для мобільних платформ»<br>
на тему «Знайомство з Xcode, створення першого проекту»</div><br><br><br><br>

<div align = "right" >Виконав:<br>
студент ІІІ курсу ФІОТ<br>                        
групи ІП-84<br>                                
Андрейченко Кирило<br>
номер залікової книжки: 8401<br></div><br><br><br><br>

<div align = "center">Київ – 2021</div><br><br><br><br>

<strong>Робота виконується без варіанту.</strong><br>
<strong>Скріншоти роботи застосунка:</strong><br>
1. Bundle identifier<br>
<p align = "center"><img src="https://i.imgur.com/ibLUz0Y.png" alt="bundle identifier"/></p><br>

2. Наявність іконки застосунка для всіх необхідних правильних розмірів
<p align = "center"><img src="https://i.imgur.com/UiasD9I.png" alt="icons"/></p><br>

3. Застосунок побудований на основі навігаційної моделі вкладок
<p align = "center"><img src="https://i.imgur.com/fWOzSNk.png" alt="model"/></p><br>

4. Правильно налаштована мітка з персональними даними студента
<p align = "center"><img src="https://i.imgur.com/bUQ9ok3.png" alt="info about student"/></p><br>

5. Вказана назва та визначене зображення для вкладки, що налаштовувалася
<p align = "center"><img src="https://i.imgur.com/RKOEyfE.png" alt="image and name for item"/></p><br>

6. Проєкт збирається та запускається
<p align = "center"><img src="https://i.imgur.com/UQ7alZ8.png" alt="the project is working properly"/></p><br>

<strong>Лістинг коду:</strong><br>
<i>ViewController.swift</i>
```swift
import UIKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
```

<i>SceneDelegate.swift</i>
```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
```

<i>AppDelegate.swift</i>
```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
```
<strong>Висновок:</strong><br>
На першій лабораторній роботі я познайомився з інтегрованим середовищем розробки Xcode, створив свій перший проєкт.
