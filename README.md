SocialFeed

Тестовое задание для iOS-разработчика (Стажировка)

Цель задания

Цель задания – проверить навыки разработки под iOS, умение работать с ключевыми технологиями (Swift, UIKit, CoreData, Alamofire) и креативность в решении задач. Проект представляет собой упрощённую версию ленты социальной сети.

Описание функционала

- Загрузка данных через API:
  Данные получаются из JSONPlaceholder с использованием Alamofire.

- Отображение постов в таблице:
  Каждая запись (ячейка) ленты включает:
 - Заголовок поста;
 - Текст поста;
 - Аватар пользователя (скачивается с Lorem Picsum с использованием вычисляемых URL);
 - Основное изображение поста (также скачивается с Lorem Picsum с использованием seed для гарантированного изображения).

- Оффлайн-режим:
  Все посты сохраняются в CoreData для доступа без интернета.

- Обновление ленты:
  Реализован pull-to-refresh для обновления ленты.

- Бонусные функции:
 - Функциональность лайков 
 - Пагинация – подгрузка постов при прокрутке;
 - Анимация при нажатии/двойном тапе для лайка.

Архитектура

Проект реализован по архитектуре MVVM:

- Model:
  Модель `Post` (Post.swift) описывает пост, декодируется из JSONPlaceholder и содержит вычисляемые свойства для формирования URL изображений (используются seed, вычисляемые по `id` и `userId`).

- ViewModel:
  `PostListViewModel` отвечает за получение данных через API, сохранение в CoreData, управление пагинацией, pull-to-refresh и обновление состояния лайков.

- View:
 - `PostListViewController` – основной экран, где отображается лента постов в таблице с pull-to-refresh и пагинацией.
 - `PostTableViewCell` – кастомная ячейка, отображающая аватар, имя пользователя, основное изображение, кнопки лайка/комментариев/поделиться, текст поста и реализующая анимацию лайка (одинарный и двойной тап).

Использованные технологии

- Swift – язык программирования.
- UIKit – фреймворк для создания интерфейсов.
- AutoLayout – программная вёрстка без Storyboard/XIB.
- CoreData – локальное хранилище для оффлайн-режима.
- Alamofire – библиотека для работы с сетью.
- Swift Package Manager (SPM) – для управления зависимостями (единственная сторонняя библиотека – Alamofire).

Инструкция по сборке

1. Клонируйте репозиторий:
   ```bash
   git clone <URL_репозитория>
2. Откройте проект:
Откройте Xcode-проект (файл с расширением .xcodeproj или .xcworkspace) – зависимости управляются через SPM, поэтому дополнительных команд не требуется.
3. Соберите и запустите приложение:
Выберите нужное устройство или симулятор и запустите приложение.

<p align="center">Скриншоты
</p>
<p align="center">
  <strong>Splash Screen</strong><br>
  <img src="https://github.com/user-attachments/assets/7e466b75-a705-42c8-8e9d-138abaf97f9b" alt="Splash Screen" width="336" />
</p>

<p align="center">
  <strong>Main Feed 1</strong><br>
  <img src="https://github.com/user-attachments/assets/c6f293a5-a482-4283-afb2-2c9cae8bbd4e" alt="Main Feed 1" width="292" />
</p>

<p align="center">
  <strong>Main Feed 2</strong><br>
  <img src="https://github.com/user-attachments/assets/f2e30be9-a496-4f26-9b13-f4d6a7b5b4b7" alt="Main Feed 2" width="288" />
</p>




