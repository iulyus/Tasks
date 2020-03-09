﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидКонтактнойИнформации = Параметры.ВидКонтактнойИнформации;
	Если Не ЗначениеЗаполнено(ВидКонтактнойИнформации) Тогда
		ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта из-за некорректного внедрения контактной информации.'");
	КонецЕсли;
	ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
	
	Заголовок = ?(Не Параметры.Свойство("Заголовок") Или ПустаяСтрока(Параметры.Заголовок), Строка(ВидКонтактнойИнформации), Параметры.Заголовок);
	
	ЗначенияПолей = ОпределитьЗначениеАдреса(Параметры);
	
	Если ПустаяСтрока(ЗначенияПолей) Тогда
		Данные = УправлениеКонтактнойИнформацией.ОписаниеНовойКонтактнойИнформации(ТипКонтактнойИнформации);
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(ЗначенияПолей) Тогда
		Данные = УправлениеКонтактнойИнформациейСлужебный.JSONВКонтактнуюИнформациюПоПолям(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.ВебСтраница);
	Иначе
		
		Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(ЗначенияПолей) Тогда
			РезультатыЧтения = Новый Структура;
			КонтактнаяИнформация = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(ЗначенияПолей, ТипКонтактнойИнформации, РезультатыЧтения);
			Если РезультатыЧтения.Свойство("ТекстОшибки") Тогда
				// Распознали с ошибками, сообщим при открытии.
				КонтактнаяИнформация.Представление = Параметры.Представление;
			КонецЕсли;
			
			Данные = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтруктуруJSON(КонтактнаяИнформация, ТипКонтактнойИнформации);
			
		Иначе
			Данные = УправлениеКонтактнойИнформацией.ОписаниеНовойКонтактнойИнформации(ТипКонтактнойИнформации);
			Данные.value = ЗначенияПолей;
			Данные.Comment = Параметры.Комментарий;
		КонецЕсли;
		
	КонецЕсли;
	
	Адрес        = Данные.Value;
	Наименование = СокрЛП(Параметры.Представление);
	Комментарий  = Данные.Comment;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(РезультатВыбора(Адрес, Наименование, Комментарий));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОпределитьЗначениеАдреса(Параметры)
	
	ЗначенияПолей = "";
	Если Параметры.Свойство("Значение") Тогда
		Если ПустаяСтрока(Параметры.Значение) Тогда
			Если Параметры.Свойство("ЗначенияПолей") Тогда
				ЗначенияПолей = Параметры.ЗначенияПолей;
			КонецЕсли;
		Иначе
			ЗначенияПолей = Параметры.Значение;
		КонецЕсли;
	Иначе
		ЗначенияПолей = Параметры.ЗначенияПолей;
	КонецЕсли;
	
	Возврат ЗначенияПолей;
	
КонецФункции

&НаСервереБезКонтекста
Функция РезультатВыбора(Адрес, Наименование, Комментарий)
	
	ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.ВебСтраница;
	НаименованиеСайта = ?(ЗначениеЗаполнено(Наименование), Наименование, Адрес);
	
	КонтактнаяИнформация         = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(ТипКонтактнойИнформации );
	КонтактнаяИнформация.value   = СокрЛП(Адрес);
	КонтактнаяИнформация.name    = СокрЛП(НаименованиеСайта);
	КонтактнаяИнформация.comment = СокрЛП(Комментарий);
	
	ДанныеВыбора = УправлениеКонтактнойИнформациейСлужебный.СтруктураВСтрокуJSON(КонтактнаяИнформация);
	
	Результат = Новый Структура();
	Результат.Вставить("Тип",                  ТипКонтактнойИнформации);
	Результат.Вставить("Адрес",                Адрес);
	Результат.Вставить("КонтактнаяИнформация", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(ДанныеВыбора, Наименование, ТипКонтактнойИнформации));
	Результат.Вставить("Значение",             ДанныеВыбора);
	Результат.Вставить("Представление",        НаименованиеСайта);
	Результат.Вставить("Комментарий",          КонтактнаяИнформация.Comment);
	
	Возврат Результат
	
КонецФункции

#КонецОбласти