﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает соответствие объектов метаданных и подсистем командного интерфейса.
//
// Возвращаемое значение: 
//  Соответствие, где ключем является полное имя объекта, а значение - массив подсистем
//    командного интерфейса программы, в которые входит данный объект.
//
Функция ПринадлежностьОбъектовРазделамКомандногоИнтерфейса() Экспорт
	
	СоответствиеОбъектовИПодсистем = Новый Соответствие;
	
	Для Каждого Подсистема Из Метаданные.Подсистемы Цикл
		Если Не Подсистема.ВключатьВКомандныйИнтерфейс
			Или Не ПравоДоступа("Просмотр", Подсистема)
			Или Не ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Подсистема) Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Объект Из Подсистема.Состав Цикл
			ПодсистемыОбъекта = СоответствиеОбъектовИПодсистем[Объект.ПолноеИмя()];
			Если ПодсистемыОбъекта = Неопределено Тогда
				ПодсистемыОбъекта = Новый Массив;
			ИначеЕсли ПодсистемыОбъекта.Найти(Подсистема.ПолноеИмя()) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ПодсистемыОбъекта.Добавить(Подсистема.ПолноеИмя());
			СоответствиеОбъектовИПодсистем.Вставить(Объект.ПолноеИмя(), ПодсистемыОбъекта);
		КонецЦикла;
		
		ДобавитьОбъектыПодчиненныхПодсистем(Подсистема, СоответствиеОбъектовИПодсистем);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СоответствиеОбъектовИПодсистем);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
//
Процедура ДобавитьОбъектыПодчиненныхПодсистем(ПодсистемаПервогоУровня, СоответствиеОбъектовИПодсистем, ПодсистемаРодитель = Неопределено)
	
	Подсистемы = ?(ПодсистемаРодитель = Неопределено, ПодсистемаПервогоУровня, ПодсистемаРодитель);
	
	Для Каждого Подсистема Из Подсистемы.Подсистемы Цикл
		Если Подсистема.ВключатьВКомандныйИнтерфейс
			И ПравоДоступа("Просмотр", Подсистема)
			И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Подсистема) Тогда
			
			Для Каждого Объект Из Подсистема.Состав Цикл
				ПодсистемыОбъекта = СоответствиеОбъектовИПодсистем[Объект.ПолноеИмя()];
				Если ПодсистемыОбъекта = Неопределено Тогда
					ПодсистемыОбъекта = Новый Массив;
				ИначеЕсли ПодсистемыОбъекта.Найти(ПодсистемаПервогоУровня.ПолноеИмя()) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ПодсистемыОбъекта.Добавить(ПодсистемаПервогоУровня.ПолноеИмя());
				СоответствиеОбъектовИПодсистем.Вставить(Объект.ПолноеИмя(), ПодсистемыОбъекта);
			КонецЦикла;
			
			ДобавитьОбъектыПодчиненныхПодсистем(ПодсистемаПервогоУровня, СоответствиеОбъектовИПодсистем, Подсистема);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти