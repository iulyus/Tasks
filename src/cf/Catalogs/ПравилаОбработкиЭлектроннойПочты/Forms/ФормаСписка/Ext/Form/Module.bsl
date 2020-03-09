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
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Параметры.Отбор.Владелец) Тогда
			
			ТолькоПросмотр = Истина;
			
			Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаПрименитьПравила.Видимость               = Ложь;
			Элементы.НастройкаПорядкаЭлементов.Видимость = Ложь;
			
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//+ #286 Иванов А.Б. 2017-12-17
	узОбщийМодульСервер.ДобавитьРеквизитыНаФормуСписка(ЭтотОбъект, узОбщийМодульСервер.ИмяМетаданных_ПравилаОбработкиЭлектроннойПочты());                              
	//- #286 Иванов А.Б. 2017-12-17

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьПравила(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыФормы = Новый Структура;
	
	МассивЭлементовОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ВзаимодействияКлиентСервер.ОтборДинамическогоСписка(Список), "Владелец");
	Если МассивЭлементовОтбора.Количество() > 0 И МассивЭлементовОтбора[0].Использование
		И ЗначениеЗаполнено(МассивЭлементовОтбора[0].ПравоеЗначение) Тогда
		ПараметрыФормы.Вставить("УчетнаяЗапись",МассивЭлементовОтбора[0].ПравоеЗначение);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не установлен отбор по владельцу(учетной записи) правил.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаОбработкиЭлектроннойПочты.Форма.ПрименениеПравил", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
