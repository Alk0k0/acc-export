# Экспорт диагностик из АПК для Sonar

## Минимальные требования

* SonarQube 7.4 и выше
* Плаформа 1С 8.3.10 и выше
* 1С: АПК 1.2.1.53
* Установленный плагин для SonarQube https://github.com/1c-syntax/sonar-bsl-plugin-community
* Установленный Sonar Scanner https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner

## Пример использования

1. Выполняем проверку конфигурации через 1С: АПК. Проверку можно выполнить и из обработки.
2. Создаем каталог проекта для Sonar. Из каталога **Sample** копируем файл с настройками sonar-scaner **sonar-project.properties**. В файле меняем настройки:
   * sonar.host.url - адрес сервера SonarQube
   * sonar.projectKey - ключ проекта в SonarQube
3. Выгружаем в папку **src** в каталоге проекта файлы конфигурации (можно сделать из конфигуратора 1С)
4. Если используются обычные формы, нужно извлечь form.bin. Для этого в каталог проекта копируем из папки **Sample** `run.os`. Запускаем выполнение скрипта в каталоге проекта `oscript run.os`.
5. Из конфигурации 1С: АПК запускаем обработку `acc-export.epf`. Заполняем реквизиты: "конфигурация", "каталог проекта". Нажимаем "Выполнить".
6. Получаем результаты проверки bsl-language-server. Прочитать можно по ссылке https://github.com/1c-syntax/bsl-language-server.
7. Запускаем sonar-scanner.

Пример скрипта для пунктов 6 и 7. Используем версию **bsl-language-server-0.4.0** Скрипт:

```
java -jar \path\to\file\bsl-language-server-0.3.0.jar --analyze --srcDir ./src --reporter json

\path\to\file\sonar-scanner.bat -X -D"sonar.login=687caef36034bdf6b1e535fa8f060c518739958d"
```

## Пакетный режим

Параметры пакетного режима

* `acc.propertiesPaths` - путь к файлу настроек.
* `acc.check` - запустить проверку конфигурации. Настройки будут взяты с параметров запуска по расписанию.
* `acc.projectKey` - наименование конфигурации в АПК.
* `acc.catalog` - каталог проекта **(не к src)**
* `acc.sources` - путь / каталог исходных кодов, например `src`.
* `acc.format` - формат экспорта из АПК (reportjson или genericissue). По-умолчанию reportjson. Можно не указывать. 
* `acc.titleError` - представление вывода ошибки при экспорте. Может принимать значения: `code` (только код ошибки), `name` (только наименование ошибки), `codeName` (код и наименование ошибки). По-умолчанию `codeName`.

Параметры можно передать через файл настроек acc.properties или через параметры запуска. Приоритет у параметров запуска.

Для использования формата **generic issue** при загрузке отчетов через sonar scanner нужно в конфигурационном файле `sonar-project.properties` указать свойство `sonar.externalIssuesReportPaths=acc-generic-issue.json`.

Пример скрипта запуска

```
@chcp 65001

@set RUNNER_IBNAME=/FC:\Sonar\acc
@set RUNNER_DBUSER=Администратор

@call runner run --command "acc.propertiesPaths=C:\Sonar\sample\acc.properties;" --execute "C:\Sonar\acc-export.epf" --ordinaryapp=1
```

P.S. Если скрипт не ожидает выполнения сеанса 1С, то скорее всего нужно добавить параметр с нужной версией платформы. Например:
```
...

@call runner run --v8version "8.3.10.2772" --command "acc.propertiesPaths=C:\Sonar\sample\acc.properties;" --execute "C:\Sonar\acc-export.epf" --ordinaryapp=1
```

## Замена одиночных CR
Для замены одиночных CR можно использовать скрипт updatecr.os. Копируем этот скрипт в каталог с проектом. Например: `/sample/updatecr.os`. Далее в консоли выполняем команду в каталоге с проектом:
```
oscript updatecr.os
```

## Отладка экспорта из АПК

Для запуска обработки в пользовательском режиме 1С, нужно в параметрах сеанса указать параметр запуска `\Debug` (например через конфигуратор **Сервис** - **Параметры** - **Запуск 1С: Предприятия** - **Основные** и заполнить поле **Параметр запуска**).

## Проблемые ситуации

Вы можете столкнуться с проблемами исходных кодов конфигурации 1C. Например, в файле модуля могут использоваться одновременно окончания строк LFCR и/или LF(Linux) и\или CR(MacOS). Эту проблему можно исправить, используя Notepad++. Ищем в каталоге **src** по регулярной строке `(\r)[^\n]` и меняем на \r\n (LFCR).
