﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается для получения настроек подсистемы.
//
// Параметры:
//  Настройки - Структура - со свойствами:
//   * Реквизиты - Соответствие - для переопределения имен реквизитов объекта, в которых содержится информация 
//                                о сумме и валюте, выводимых в списке связанных документов. 
//                                В ключе указывается полное имя объекта метаданных, в значении - соответствие 
//                                реквизитов Валюта и СуммаДокумента с реальными реквизитами объекта. 
//                                Если не задано, то значения зачитываются из реквизитов Валюта и СуммаДокумента.
//   * РеквизитыДляПредставления - Соответствие - для переопределения представления объектов, выводимых в списке 
//                                связанных документов. В ключе указывается полное имя объекта метаданных, в значении -
//                                массив имен реквизитов, значения которых участвуют в формировании представления.
//                                Для формирования представления перечисленных здесь объектов будет вызываться 
//                                процедура СтруктураПодчиненностиПереопределяемый.ПриПолученииПредставления.
//
// Пример:
//	Реквизиты = Новый Соответствие;
//	Реквизиты.Вставить("СуммаДокумента", Метаданные.Документы.СчетНаОплатуПокупателю.Реквизиты.СуммаОплаты.Имя);
//	Реквизиты.Вставить("Валюта", Метаданные.Документы.СчетНаОплатуПокупателю.Реквизиты.ВалютаДокумента.Имя);
//	Настройки.Реквизиты.Вставить(Метаданные.Документы.СчетНаОплатуПокупателю.ПолноеИмя(), Реквизиты);
//		
//	РеквизитыДляПредставления = Новый Массив;
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.ДатаОтправления.Имя);
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.Тема.Имя);
//	РеквизитыДляПредставления.Добавить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.Реквизиты.СписокПолучателейПисьма.Имя);
//	Настройки.РеквизитыДляПредставления.Вставить(Метаданные.Документы.ЭлектронноеПисьмоИсходящее.ПолноеИмя(), 
//		РеквизитыДляПредставления);
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	
	
КонецПроцедуры

// Вызывается для получения представления объектов, выводимых в списке связанных документов.
// Только для тех объектов, которые перечислены в свойстве РеквизитыДляПредставления параметра Настройки
// процедуры СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
//
// Параметры:
//  ТипДанных - ЛюбаяСсылка - тип ссылки выводимого объекта, см. свойство Тип критерия отбора СвязанныеДокументы.
//  Данные    - ВыборкаИзРезультатаЗапроса, Структура - содержит значения полей, из которых формируется представление:
//               * Ссылка - ЛюбаяСсылка - ссылка объекта, выводимого в списке связанных документов.
//               * ДополнительныйРеквизит1 - Произвольный - значение первого реквизита, указанного в массиве 
//                 РеквизитыДляПредставления параметра Настройки процедуры ПриОпределенииНастроек.
//               * ДополнительныйРеквизит2 - Произвольный - значение второго реквизита...
//               ...
//  Представление - Строка - поместить в этот параметр рассчитанное представление объекта. 
//  СтандартнаяОбработка - Булево - поместить в этот параметр Ложь, если установлено значение параметра Представление.
//
Процедура ПриПолученииПредставления(ТипДанных, Данные, Представление, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры	
	
#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
// См. свойство РеквизитыДляПредставления параметра Настройки.
// Формирует массив реквизитов документа. 
// 
// Параметры: 
//  ИмяДокумента - Строка - имя документа.
//
// Возвращаемое значение:
//   Массив - массив наименований реквизитов документа. 
//
Функция МассивРеквизитовОбъектаДляФормированияПредставления(ИмяДокумента) Экспорт
	
	Возврат Новый Массив;
	
КонецФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриПолученииПредставления.
// Получает представление документа для печати.
//
// Параметры:
//  Выборка  - КоллекцияДанных - структура или выборка из результатов запроса
//                 в которой содержатся дополнительные реквизиты, на основании
//                 которых можно сформировать переопределенное представление 
//                 документа для вывода в отчет "Структура подчиненности".
//
// Возвращаемое значение:
//   Строка,Неопределено   - переопределенное представление документа, или Неопределено,
//                           если для данного типа документов такое не задано.
//
Функция ПредставлениеОбъектаДляВыводаВОтчет(Выборка) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать СтруктураПодчиненностиПереопределяемый.ПриОпределенииНастроек.
// См. свойство Реквизиты параметра Настройки.
// Возвращает имя реквизита документа, в котором содержится информация о Сумме и Валюте документа для вывода в
// структуру подчиненности.
// По умолчанию используются реквизиты Валюта и СуммаДокумента. Если для конкретного документа или конфигурации в целом
// используются другие
// реквизиты, то переопределить значения по умолчанию можно в данной функции.
//
// Параметры:
//  ИмяДокумента  - Строка - имя документа, для которого надо получить имя реквизита.
//  Реквизит      - Строка - строка, может принимать значения "Валюта" и "СуммаДокумента".
//
// Возвращаемое значение:
//   Строка   - имя реквизита документа, в котором содержится информация о Валюте или Сумме.
//
Функция ИмяРеквизитаДокумента(ИмяДокумента, Реквизит) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
