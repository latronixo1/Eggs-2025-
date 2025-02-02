//
//  ViewController.swift
//  03. EggTimer
//
//  Created by MacBook on 16.01.2025.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: UI
    
    //объявляем главный вертикальный стек
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.spacing = 0
        element.distribution = .fillEqually
        element.axis = .vertical
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    } ()
    
    //Объявляем главную надпись
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Какие яйца нравятся вам?"
        element.font = .systemFont(ofSize: 25)
        element.textAlignment = .center
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    } ()
    
    //Объявляем горизонтальный стек с изображениями яиц
    private lazy var eggsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 20
        element.distribution = .fillEqually
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    } ()
    
    //Объявляем левую картинки для яиц
    private let softImageView = UIImageView(imageName: "soft_egg")
    private let mediumImageView = UIImageView(imageName: "medium_egg")
    private let hardImageView = UIImageView(imageName: "hard_egg")

    //Объявляем кнопку для яйиц
    private let softButton = UIButton(title: "Всмятку")
    private let mediumButton = UIButton(title: "Вмешочек")
    private let hardButton = UIButton(title: "Вкрутую")

    //стек для прогр
    
    private lazy var timerView: UIView = {
        let element = UIView()
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    } ()

    private lazy var progressView: UIProgressView = {
        let element = UIProgressView()
        element.progressTintColor = .systemYellow
        element.trackTintColor = .systemGray

        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    } ()

    //MARK: - Private Properties
    
    private let eggTimes = ["Всмятку": 300, "Вмешочек": 420, "Вкрутую": 720]  //словарь с временами приготовления (в секундах)
    private var totalTime = 0   // всего времени
    private var secondPassed = 0    //секунд прошло
    private var timer = Timer() //таймер
    private var player: AVAudioPlayer?  //плеер для проигрывания сигнала таймера
    private var nameSoundTimer = "alarm_sound"  // название файла сигнала таймера
    
    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setupConstraints()
    }
    
    //MARK: - Bisnes Logic
    
    //функция произведения звука
    private func playSound (_ soundName: String) {
        //создаем путь к файлу звука. Bundle.main - означает, что будем искать внутри нашего проекта
        //forResource - имя файла, withExtenstion - его расширение
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }

        //try необходим, чтобы приложение не крашилось в случае недоступности файла, путь к которому указан в url
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }

    
    //функция нажатия на картинки с яйцами
    @objc private func eggsButtonsTapped(_ sender: UIButton) {
        //инвалидируем (сбрасываем, если он запущен) таймер - для исключения дублирования (запуска нескольких таймеров одновременно)
        timer.invalidate()
        player?.stop()
        //сбрасываем (обнуляем, двигаем ползунок в начало) прогресВью
        progressView.setProgress(0, animated: true)
        //обнуляем количество прошедших секунд
        secondPassed = 0
        
        let hardness = sender.titleLabel?.text ?? "error"
        
        titleLabel.text = "Варим \(hardness)..."
        
        totalTime = eggTimes[hardness] ?? 0
        
        //timeInterval - интервал между "тиканием" - между запусками функции updateTimer, target - наш ViewController, selector - наша функция, которую мы запускаем при тике, repeats - повторять тик или нет
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    
    //событие "тика" - что мы будем делать каждую секунду
    @objc private func updateTimer() {
        //если время не истекло
        if secondPassed < totalTime {
            //то увеличиваем счетчик секунд на единицу
            secondPassed += 1
            //высчитываем процент для progressView (крайнее левое положение соответствует нулю, крайнее правое - единице. Посередине - значение от 0 до 1 типа Float
            let percentageProgress = Float(secondPassed) / Float(totalTime)
            //меняем позицию progressView
            progressView.setProgress(percentageProgress, animated: true)
        } else {    //а если время истекло, то
            playSound(nameSoundTimer)   //производим звук "nameSoundTimer", который находится в нашем Assets
            timer.invalidate()  //отключаем таймер
            secondPassed = 0    //обнуляем счетчик секунд
            titleLabel.text = "Готово! Повторим?"   //меняем текст надписи
            progressView.setProgress(1, animated: true) //ставим progressView в крайнее правое положение
        }
    }
    
}

extension ViewController {
    private func setViews() {
        //добавляем главны вертикальный стек
        view.backgroundColor = .systemCyan
        view.addSubview(mainStackView)
        
        //в главный вертикальный стек добавляем элементы
        mainStackView.addArrangedSubview(titleLabel)    //надпись сверху
        mainStackView.addArrangedSubview(eggsStackView) //горизонтальный стек с изображениями яиц
        mainStackView.addArrangedSubview(timerView)     //View с таймером
        
        //в горизонтальный стек с изображениями яиц добавляем картинки
        eggsStackView.addArrangedSubview(softImageView)  //мягкое яйцо
        eggsStackView.addArrangedSubview(mediumImageView)  //нормальное яйцо
        eggsStackView.addArrangedSubview(hardImageView)  //вкрутую яйцо
        
        //на картинки горизонтального View добавляем кнопки
        softImageView.addSubview(softButton)
        mediumImageView.addSubview(mediumButton)
        hardImageView.addSubview(hardButton)

        //добавляем к кнопка события нажатия этих кнопок. Не смотря на то, что их текст одинаков,
        //не рекомендуется добавлять этот текст во вспомогательный инициализатор, потому что
        //ему для работы необходимо передавать self - т.е. это ViewController, а это не правильно
        softButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)

        
        //в View с таймером добавялем progressView
        timerView.addSubview(progressView)
        
    }
    
    private func setupConstraints () {
        NSLayoutConstraint.activate([
            //главный вертикальный стек прикрепляем в safeArea, справа и слева только делаем отступы по 20
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            //закрепляем progressView в центре timerView
            progressView.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: timerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            
            //натягиваем на картинки с изображениями яиц соответствующие кнопки
            softButton.topAnchor.constraint(equalTo: softImageView.topAnchor),
            softButton.bottomAnchor.constraint(equalTo: softImageView.bottomAnchor),
            softButton.leadingAnchor.constraint(equalTo: softImageView.leadingAnchor),
            softButton.trailingAnchor.constraint(equalTo: softImageView.trailingAnchor),

            //натягиваем на картинки с изображениями яиц соответствующие кнопки
            mediumButton.topAnchor.constraint(equalTo: mediumImageView.topAnchor),
            mediumButton.bottomAnchor.constraint(equalTo: mediumImageView.bottomAnchor),
            mediumButton.leadingAnchor.constraint(equalTo: mediumImageView.leadingAnchor),
            mediumButton.trailingAnchor.constraint(equalTo: mediumImageView.trailingAnchor),

            //натягиваем на картинки с изображениями яиц соответствующие кнопки
            hardButton.topAnchor.constraint(equalTo: hardImageView.topAnchor),
            hardButton.bottomAnchor.constraint(equalTo: hardImageView.bottomAnchor),
            hardButton.leadingAnchor.constraint(equalTo: hardImageView.leadingAnchor),
            hardButton.trailingAnchor.constraint(equalTo: hardImageView.trailingAnchor),

        ])
    }
}

//расширение для кнопок. Используем для исключения дублирования кода без использования циклов.
//Вспомогательный инициализатор будет
//принимать только те параметры, которыми будут отличаться наши кнопки.
extension UIButton {
    //вспомогательный инициализатор (в расширении мы не можем менять собственный инициализатор)
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 15, weight: .black)
        self.tintColor = .purple
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImageView {
    //вспомогательный инициализатор (в расширении мы не можем менять собственный инициализатор)
    convenience init(imageName: String) {
        self.init()
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleAspectFit   //сохранять пропорции и не обрезать
        self.isUserInteractionEnabled = true //разрешаем нажание на View
 
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
