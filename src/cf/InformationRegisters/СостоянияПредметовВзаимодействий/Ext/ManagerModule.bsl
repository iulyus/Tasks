﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Удаляет либо одну, либо все записи из регистра.
//
// Параметры:
//  Предмет  - ДокументСсылка, СправочникСсылка, Неопределено - предмет, для которого удаляется запись.
//                                                              Если указано значение Неопределено, то регистр будет
//                                                              очищен полностью.
//
Процедура УдалитьЗаписьИзРегистра(Предмет = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = СоздатьНаборЗаписей();
	Если Предмет <> Неопределено Тогда
		НаборЗаписей.Отбор.Предмет.Установить(Предмет);
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Выполняет запись в регистр сведений для указанного предмета.
//
// Параметры:
//  Предмет                       - ДокументСсылка, СправочникСсылка - предмет, для которого выполняется запись.
//  КоличествоНеРассмотрено       - Число - количество не рассмотренных взаимодействий для предмета.
//  ДатаПоследнегоВзаимодействия  - ДатаВремя - дата последнего взаимодействия по предмету.
//  Активен                         - Булево - признак активности предмета.
//
Процедура ВыполнитьЗаписьВРегистр(Предмет,
	                              КоличествоНеРассмотрено = Неопределено,
	                              ДатаПоследнегоВзаимодействия = Неопределено,
	                              Активен = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если КоличествоНеРассмотрено = Неопределено И ДатаПоследнегоВзаимодействия = Неопределено И Активен = Неопределено Тогда
		
		Возврат;
		
	ИначеЕсли КоличествоНеРассмотрено = Неопределено ИЛИ ДатаПоследнегоВзаимодействия = Неопределено ИЛИ Активен = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СостоянияПредметовВзаимодействий.Предмет,
		|	СостоянияПредметовВзаимодействий.КоличествоНеРассмотрено,
		|	СостоянияПредметовВзаимодействий.ДатаПоследнегоВзаимодействия,
		|	СостоянияПредметовВзаимодействий.Активен
		|ИЗ
		|	РегистрСведений.СостоянияПредметовВзаимодействий КАК СостоянияПредметовВзаимодействий
		|ГДЕ
		|	СостоянияПредметовВзаимодействий.Предмет = &Предмет";
		
		Запрос.УстановитьПараметр("Предмет",Предмет);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если КоличествоНеРассмотрено = Неопределено Тогда
				КоличествоНеРассмотрено = Выборка.КоличествоНеРассмотрено;
			КонецЕсли;
			
			Если ДатаПоследнегоВзаимодействия = Неопределено Тогда
				ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия.Предмет;
			КонецЕсли;
			
			Если Активен = Неопределено Тогда
				Активен = Выборка.Активен;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;

	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Предмет.Установить(Предмет);
	
	Запись = НаборЗаписей.Добавить();
	Запись.Предмет                      = Предмет;
	Запись.КоличествоНеРассмотрено      = КоличествоНеРассмотрено;
	Запись.ДатаПоследнегоВзаимодействия = ДатаПоследнегоВзаимодействия;
	Запись.Активен                      = Активен;
	НаборЗаписей.Записать();

КонецПроцедуры

#Область ОбработчикиОбновления

// Процедура обновления ИБ для версии БСП 2.2.
// Выполняет первоначальный расчет состояний предметов взаимодействий.
//
//
// Параметры:
//  Параметры  - Структура- параметры выполнения текущей порции обработчика обновления.
//
Процедура РассчитатьСостоянияПредметовВзаимодействий_2_2_0_0(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	ПредметыПапкиВзаимодействий.Предмет
	|ПОМЕСТИТЬ ПредметыДляРасчета
	|ИЗ
	|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияПредметовВзаимодействий КАК СостоянияПредметовВзаимодействий
	|		ПО (СостоянияПредметовВзаимодействий.Предмет = ПредметыПапкиВзаимодействий.Предмет)
	|ГДЕ
	|	СостоянияПредметовВзаимодействий.Предмет ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПредметыПапкиВзаимодействий.Предмет,
	|	СУММА(ВЫБОР
	|			КОГДА НЕ ПредметыПапкиВзаимодействий.Рассмотрено
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоНеРассмотрено,
	|	МАКСИМУМ(Взаимодействия.Дата) КАК ДатаПоследнегоВзаимодействия,
	|	ВЫБОР
	|		КОГДА Удалить_АктивныеПредметыВзаимодействий.Предмет ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Активен
	|ИЗ
	|	ПредметыДляРасчета КАК ПредметыДляРасчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЖурналДокументов.Взаимодействия КАК Взаимодействия
	|			ПО ПредметыПапкиВзаимодействий.Взаимодействие = Взаимодействия.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Удалить_АктивныеПредметыВзаимодействий КАК Удалить_АктивныеПредметыВзаимодействий
	|			ПО ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма = Удалить_АктивныеПредметыВзаимодействий.Предмет
	|		ПО ПредметыДляРасчета.Предмет = ПредметыПапкиВзаимодействий.Предмет
	|
	|СГРУППИРОВАТЬ ПО
	|	ПредметыПапкиВзаимодействий.Предмет,
	|	ВЫБОР
	|		КОГДА Удалить_АктивныеПредметыВзаимодействий.Предмет ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Предмет.Установить(Выборка.Предмет);
		Запись = НаборЗаписей.Добавить();
		Запись.Предмет = Выборка.Предмет;
		Запись.КоличествоНеРассмотрено = Выборка.КоличествоНеРассмотрено;
		Запись.ДатаПоследнегоВзаимодействия = Выборка.ДатаПоследнегоВзаимодействия;
		Запись.Активен = Выборка.Активен;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = (Выборка.Количество() = 0);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли