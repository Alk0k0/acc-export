﻿
#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(ФайлКлассификацииОшибок) Тогда
		ФлажокЗагрузитьИзФайла = Истина;
	КонецЕсли;
	
	УправлениеДиалогом();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

Процедура ФлажокЗагрузитьИзФайлаПриИзменении(Элемент)
	
	УправлениеДиалогом();
	
КонецПроцедуры

Процедура ФайлКлассификацииОшибокНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Укажите файл классификации ошибок";
	Диалог.Фильтр = "Текстовый документ(*.csv)|*.csv";
	Если Диалог.Выбрать() Тогда
		ФайлКлассификацииОшибок = Диалог.ПолноеИмяФайла; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ФайлКлассификацииОшибокОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Не ПустаяСтрока(ФайлКлассификацииОшибок) Тогда
		ЗапуститьПриложение(ФайлКлассификацииОшибок);
	КонецЕсли;
КонецПроцедуры

Процедура КлассыОшибокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОТребованиях", 0.5, Истина);
	
КонецПроцедуры

Процедура ТЗТребованияВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(ВыбраннаяСтрока.Требования);
	
КонецПроцедуры

Процедура КлассыОшибокОшибкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФормаВыборОшибки = Справочники.ОбнаруживаемыеОшибки.ПолучитьФормуВыбора("ФормаВыбора", Элемент);
	ФормаВыборОшибки.Открыть();
	
КонецПроцедуры

Процедура КлассыОшибокОшибкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	КодОшибки = ВыбранноеЗначение.Код;
	// Проверим на наличие дублей.
	НайденныеСтроки = КлассыОшибок.НайтиСтроки(Новый Структура("КодОшибки", КодОшибки));
	Если НайденныеСтроки.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Строка с настройками данной ошибки уде есть в таблице под номером %1'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", НайденныеСтроки[0].НомерСтроки);
		Сообщить(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = ЭлементыФормы.КлассыОшибок.ТекущаяСтрока;
	ТекущаяСтрока.КодОшибки = КодОшибки;
	ТекущаяСтрока.НаименованиеОшибки = ВыбранноеЗначение.Наименование;
	
КонецПроцедуры

Процедура КлассыОшибокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ТипЗнч(ОтсутствующиеВПроверкеНастройкиОшибок) = Тип("Массив") Тогда
		Если ОтсутствующиеВПроверкеНастройкиОшибок.Найти(ДанныеСтроки.КодОшибки) <> Неопределено Тогда
			ОформлениеСтроки.ЦветФона = WebЦвета.ЛососьСветлый;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КлассыОшибокОшибкаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = ЭлементыФормы.КлассыОшибок.ТекущаяСтрока;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОбнаруживаемыеОшибки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ОбнаруживаемыеОшибки КАК ОбнаруживаемыеОшибки
	|ГДЕ
	|	ОбнаруживаемыеОшибки.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", ТекущаяСтрока.КодОшибки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
	
		ОткрытьЗначение(Выборка.Ссылка);
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура КоманднаяПанельКлассыОшибокПрочитатьНастройки(Кнопка)
	
	Если фФайлСуществует(ФайлКлассификацииОшибок) Тогда
		АдресФайлаКлассификацииВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлКлассификацииОшибок));
	КонецЕсли;
	
	ЗаполнитьКлассыОшибок();
	
	Если ЗначениеЗаполнено(ОтсутствующиеВПроверкеНастройкиОшибок)
		И ОтсутствующиеВПроверкеНастройкиОшибок.Количество() > 0 Тогда
		
		Сообщить(НСтр("ru = 'Есть настройки ошибок, отсутствующих в текущем варианте проверки конфигурации. Они выделены красным.'"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельКлассыОшибокСохранитьВФайл(Кнопка)
	
	Если ФлажокЗагрузитьИзФайла
		И Не ПустаяСтрока(ФайлКлассификацииОшибок) Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		ТекстВопроса = НСтр("ru = 'Перезаписать текущий файл классификации?'");
		Ответ = Вопрос(ТекстВопроса, Режим, 0);
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ПутьКФайлу = ФайлКлассификацииОшибок;
		Иначе
			ПутьКФайлу = ПолучитьПутьКФайлуКлассификации();
		КонецЕсли;
		
	Иначе
		ПутьКФайлу = ПолучитьПутьКФайлуКлассификации();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПутьКФайлу) Тогда
		СохранитьНастройкиВФайл(ПутьКФайлу);
		ТекстСообщения = НСтр("ru = 'Настройки классификации сохранены в файл: %1'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", ПутьКФайлу);
		Сообщить(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УправлениеДиалогом()
	
	Если ФлажокЗагрузитьИзФайла Тогда
		ЭлементыФормы.НадписьФайлКлассификации.Видимость = Истина;
		ЭлементыФормы.ФайлКлассификацииОшибок.Видимость = Истина;
	Иначе
		ЭлементыФормы.НадписьФайлКлассификации.Видимость = Ложь;
		ЭлементыФормы.ФайлКлассификацииОшибок.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПутьКФайлуКлассификации()
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок = "Укажите адрес файла классификации Ошибок";
	Диалог.Фильтр = "Текстовый документ(*.csv)|*.csv";
	// По умолчанию предложим создать файл в каталоге проекта.
	Если ЗначениеЗаполнено(КаталогПроекта) Тогда
		КаталогФайла = СтрЗаменить(КаталогПроекта, "/", "\");
		Каталог = Новый Файл(КаталогФайла);
		Если Каталог.Существует()
			И Каталог.ЭтоКаталог() Тогда
			
			Если Не СтрЗаканчиваетсяНа(КаталогФайла, "\") Тогда
				КаталогФайла = КаталогФайла + "\";
			КонецЕсли;
			
			Диалог.Каталог = КаталогФайла;
			Диалог.ПолноеИмяФайла = КаталогФайла + "FileClassificationError.csv";
			
		КонецЕсли;
	КонецЕсли;
	Если Диалог.Выбрать() Тогда
		Возврат Диалог.ПолноеИмяФайла;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Есть глобальный метод ФайлСуществует, но он не проверяет, что это файл
Функция фФайлСуществует(Знач пФайл) Экспорт
	
	Файл = Новый Файл(пФайл);
	Возврат Файл.Существует() И Файл.ЭтоФайл();
	
КонецФункции

Процедура СохранитьНастройкиВФайл(ПутьКФайлу)
	
	ТекстДок = Новый ТекстовыйДокумент;
	
	Для Каждого СтрокаКлассификации Из КлассыОшибок Цикл
		
		ЧастиСтроки = Новый Массив;
		ЧастиСтроки.Добавить(СтрокаКлассификации.Серьезность);
		ЧастиСтроки.Добавить(СтрокаКлассификации.Тип);
		ЧастиСтроки.Добавить(СтрокаКлассификации.ЗатрачиваемыеУсилия);
		ЧастиСтроки.Добавить(СтрокаКлассификации.КодОшибки);
		ЧастиСтроки.Добавить(СтрокаКлассификации.НаименованиеОшибки);
		
		ТекстСтроки = СтрСоединить(ЧастиСтроки,";");
		ТекстДок.ДобавитьСтроку(ТекстСтроки);
		
	КонецЦикла;
	
	ТекстДок.Записать(ПутьКФайлу, КодировкаТекста.ANSI);
	
КонецПроцедуры

Процедура Подключаемый_ВывестиИнформациюОТребованиях()
	
	ТекущаяСтрока = ЭлементыФормы.КлассыОшибок.ТекущаяСтрока;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТребованияККонфигурации.Требование КАК Требования
	               |ИЗ
	               |	РегистрСведений.ТребованияККонфигурации КАК ТребованияККонфигурации
	               |ГДЕ
	               |	ТребованияККонфигурации.Ошибка.Код = &КодОшибки
	               |	И ТребованияККонфигурации.Конфигурация = &Конфигурация
	               |	И ТребованияККонфигурации.ВариантПроверки = &ВариантПроверки";
	
	Запрос.УстановитьПараметр("КодОшибки", ТекущаяСтрока.КодОшибки);
	Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	Запрос.УстановитьПараметр("ВариантПроверки", Конфигурация.ВариантПроверкиВручную);
	
	ТЗТребования = Запрос.Выполнить().Выгрузить();
	
КонецПроцедуры

#КонецОбласти
