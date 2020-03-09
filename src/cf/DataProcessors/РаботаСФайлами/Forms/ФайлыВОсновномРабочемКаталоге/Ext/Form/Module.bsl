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
	
	ЗаполнитьСписок();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.СписокНаРедактирование.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокВФорме();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		ДоступностьКоманд = Ложь;
	Иначе
		ДоступностьКоманд = Истина;
	КонецЕсли;
	
	Элементы.ФормаУдалитьИзЛокальногоКэшаФайлов.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМенюУдалитьИзЛокальногоКэшаФайлов.Доступность = ДоступностьКоманд;
	
	Элементы.ФормаЗакончитьРедактирование.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМенюЗакончитьРедактирование.Доступность = ДоступностьКоманд;
	
	Элементы.ФормаОсвободить.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = ДоступностьКоманд;
	
	Элементы.ФормаОткрытьКаталогФайла.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМенюОткрытьКаталогФайла.Доступность = ДоступностьКоманд;
	
	Элементы.ФормаОткрытьКарточку.Доступность = ДоступностьКоманд;
	Элементы.СписокКонтекстноеМенюОткрытьКарточку.Доступность = ДоступностьКоманд;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайлов(Команда)
	УдалитьИзЛокальногоКэшаФайловВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(СтрокаТаблицы.Файл);
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект);
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(Обработчик, ДанныеФайла.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	ОткрытьКарточкуВыполнить();
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВыполнить()
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьПослеУстановкиРасширения", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайлаВыполнить()
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(СтрокаТаблицы.Файл);
	РаботаСФайламиСлужебныйКлиент.КаталогФайла(Неопределено, ДанныеФайла);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакончитьРедактированиеЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	ЗаполнитьСписок();
	ЗаполнитьСписокВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьПослеУстановкиРасширения(Результат, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивСсылок", Новый Массив);
	
	Для Каждого Элемент Из Элементы.Список.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(Элемент);
		Ссылка = ДанныеСтроки.Файл;
		ПараметрыВыполнения.МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	ПараметрыВыполнения.Вставить("Индекс", 0);
	ПараметрыВыполнения.Вставить("ВГраница", ПараметрыВыполнения.МассивСсылок.ВГраница());
	
	ОсвободитьВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВЦикле(ПараметрыВыполнения)
	
	РаботаСФайламиСлужебныйКлиент.ЗарегистрироватьОписаниеОбработчика(
		ПараметрыВыполнения, ЭтотОбъект, "ОсвободитьВЦиклеПродолжить");
	
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("ОбработчикРезультата",               ПараметрыВыполнения);
	ПараметрыВызова.Вставить("ОбъектСсылка",                       Неопределено);
	ПараметрыВызова.Вставить("Версия",                             Неопределено);
	ПараметрыВызова.Вставить("ХранитьВерсии",                      Неопределено);
	ПараметрыВызова.Вставить("ФайлРедактируетТекущийПользователь", Неопределено);
	ПараметрыВызова.Вставить("Редактирует",                        Неопределено);
	ПараметрыВызова.Вставить("УникальныйИдентификатор",            Неопределено);
	ПараметрыВызова.Вставить("НеЗадаватьВопрос",                   Ложь);
	
	Для Индекс = ПараметрыВыполнения.Индекс По ПараметрыВыполнения.ВГраница Цикл
		ПараметрыВыполнения.Индекс = Индекс;
		ПараметрыВызова.Версия = ПараметрыВыполнения.МассивСсылок[Индекс];
		
		РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлПослеУстановкиРасширения(
			Неопределено, ПараметрыВызова);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Истина Тогда
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьСписок();
	ЗаполнитьСписокВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВЦиклеПродолжить(Результат, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
	ОсвободитьВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВФорме()
	
	РабочийКаталогПользователя = РаботаСФайламиСлужебныйКлиент.РабочийКаталогПользователя();
	
	Список.Очистить();
	
	Для Каждого Строка Из СписокЗначенийФайловВРегистре Цикл
		
		ПолныйПуть = РабочийКаталогПользователя + Строка.Значение.ЧастичныйПуть;
		Файл = Новый Файл(ПолныйПуть);
		Если Файл.Существует() Тогда
			НоваяСтрока = Список.Добавить();
			НоваяСтрока.ДатаИзменения    = МестноеВремя(Строка.Значение.ДатаМодификацииУниверсальная);
			НоваяСтрока.ИмяФайла         = Строка.Значение.ПолноеНаименование;
			НоваяСтрока.ИндексКартинки   = Строка.Значение.ИндексКартинки;
			НоваяСтрока.Размер           = Формат(Строка.Значение.Размер / 1024, "ЧЦ=10; ЧН=0"); // в КБ
			НоваяСтрока.Версия           = Строка.Значение.Ссылка;
			НоваяСтрока.Редактирует      = Строка.Значение.Редактирует;
			НоваяСтрока.НаРедактирование = ЗначениеЗаполнено(Строка.Значение.Редактирует);
			НоваяСтрока.Файл             = Строка.Значение.Файл;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПоСсылке(СсылкаДляУдаления)
	
	КоличествоЭлементов = Список.Количество();
	
	Для Номер = 0 По КоличествоЭлементов - 1 Цикл
		Строка = Список[Номер];
		Ссылка = Строка.Версия;
		Если Ссылка = СсылкаДляУдаления Тогда
			Список.Удалить(Номер);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	
	СписокВРегистре = СписокВРегистре();
	СписокЗначенийФайловВРегистре.Очистить();
	
	Для Каждого Строка Из СписокВРегистре Цикл
		СписокЗначенийФайловВРегистре.Добавить(Строка);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВыполнить()
	
	ТекстВопроса = НСтр("ru = 'Удалить выбранные файлы из рабочего каталога?'");
	Обработчик = Новый ОписаниеОповещения("УдалитьИзЛокальногоКэшаПослеОтветаНаВопрос", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаПослеОтветаНаВопрос(Ответ, ПараметрыВыполнения) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("МассивСсылок", Новый Массив);
	Для Каждого НомерЦикла Из Элементы.Список.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.Список.ДанныеСтроки(НомерЦикла);
		ПараметрыВыполнения.МассивСсылок.Добавить(ДанныеСтроки.Версия);
	КонецЦикла;
	
	ПараметрыВыполнения.Вставить("Индекс", 0);
	ПараметрыВыполнения.Вставить("ВГраница", ПараметрыВыполнения.МассивСсылок.ВГраница());
	ПараметрыВыполнения.Вставить("Ссылка", Неопределено);
	ПараметрыВыполнения.Вставить("ЕстьЗанятыеФайлы", Ложь);
	ПараметрыВыполнения.Вставить("ИмяКаталога", РаботаСФайламиСлужебныйКлиент.РабочийКаталогПользователя());

	УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения)
	
	РаботаСФайламиСлужебныйКлиент.ЗарегистрироватьОписаниеОбработчика(ПараметрыВыполнения, ЭтотОбъект, "УдалитьИзЛокальногоКэшаФайловВЦиклеПродолжить");
	
	Для Индекс = ПараметрыВыполнения.Индекс По ПараметрыВыполнения.ВГраница Цикл
		ПараметрыВыполнения.Индекс = Индекс;
		ПараметрыВыполнения.Ссылка = ПараметрыВыполнения.МассивСсылок[Индекс];
		
		Если ФайлЗанят(ПараметрыВыполнения.Ссылка) Тогда
			Строки = Список.НайтиСтроки(Новый Структура("Версия", ПараметрыВыполнения.Ссылка));
			Строки[0].НаРедактирование = Истина;
			ПараметрыВыполнения.ЕстьЗанятыеФайлы = Истина;
			ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
			ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
			Продолжить;
		КонецЕсли;
		
		ПараметрыВыполнения.Вставить("ИмяФайлаСПутем",
			РаботаСФайламиСлужебныйВызовСервера.ПолучитьПолноеИмяФайлаИзРегистра(
				ПараметрыВыполнения.Ссылка, ПараметрыВыполнения.ИмяКаталога, Ложь, Ложь));
		
		РаботаСФайламиСлужебныйКлиент.УдалитьФайлИзРабочегоКаталога(
			ПараметрыВыполнения, ПараметрыВыполнения.Ссылка);
		
		Если ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Истина Тогда
			Возврат;
		КонецЕсли;
		
		Если ПараметрыВыполнения.ИмяФайлаСПутем <> "" Тогда
			ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ИмяФайлаСПутем);
			Если НЕ ФайлНаДиске.Существует() Тогда
				УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
			КонецЕсли;
		Иначе
			УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыВыполнения.ЕстьЗанятыеФайлы Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Нельзя удалять из рабочего каталога файлы,
			           |занятые для редактирования.'"));
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайловВЦиклеПродолжить(Результат, ПараметрыВыполнения) Экспорт
	
	// Завершение операций с файлом.
	Если ПараметрыВыполнения.ИмяФайлаСПутем <> "" Тогда
		ФайлНаДиске = Новый Файл(ПараметрыВыполнения.ИмяФайлаСПутем);
		Если НЕ ФайлНаДиске.Существует() Тогда
			УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
		КонецЕсли;
	Иначе
		УдалитьПоСсылке(ПараметрыВыполнения.Ссылка);
	КонецЕсли;
	
	// Продолжение цикла.
	ПараметрыВыполнения.АсинхронныйДиалог.Открыт = Ложь;
	ПараметрыВыполнения.Индекс = ПараметрыВыполнения.Индекс + 1;
	УдалитьИзЛокальногоКэшаФайловВЦикле(ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуВыполнить()
	
	СтрокаТаблицы = Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, СтрокаТаблицы.Файл);
	
КонецПроцедуры

&НаСервере
Функция СписокВРегистре()
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокЗначений = Новый Массив;
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	// Для каждой нашей записи находим запись в регистре сведений - оттуда берем поле Версия и Редактирует.
	ЗапросВРегистр = Новый Запрос;
	ЗапросВРегистр.УстановитьПараметр("Пользователь", ТекущийПользователь);
	ЗапросВРегистр.Текст =
	"ВЫБРАТЬ
	|	ФайлыВРабочемКаталоге.Файл КАК Ссылка,
	|	ФайлыВРабочемКаталоге.НаЧтение КАК НаЧтение,
	|	ФайлыВРабочемКаталоге.Размер КАК Размер,
	|	ФайлыВРабочемКаталоге.Путь КАК Путь,
	|	ФайлыВРабочемКаталоге.Файл.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
	|	ФайлыВРабочемКаталоге.Файл.Наименование КАК ПолноеНаименование,
	|	ФайлыВРабочемКаталоге.Файл.ИндексКартинки КАК ИндексКартинки,
	|	ФайлыВРабочемКаталоге.Файл.Редактирует КАК Редактирует,
	|	ФайлыВРабочемКаталоге.Файл КАК Файл
	|ИЗ
	|	РегистрСведений.ФайлыВРабочемКаталоге КАК ФайлыВРабочемКаталоге
	|ГДЕ
	|	ФайлыВРабочемКаталоге.Пользователь = &Пользователь
	|	И ФайлыВРабочемКаталоге.ВРабочемКаталогеВладельца = ЛОЖЬ";
	
	РезультатЗапроса = ЗапросВРегистр.Выполнить(); 
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Запись = Новый Структура;
			Запись.Вставить("ДатаМодификацииУниверсальная", Выборка.ДатаМодификацииУниверсальная);
			Запись.Вставить("ПолноеНаименование",           Выборка.ПолноеНаименование);
			Запись.Вставить("ИндексКартинки",               Выборка.ИндексКартинки);
			Запись.Вставить("Размер",                       Выборка.Размер);
			Запись.Вставить("Ссылка",                       Выборка.Ссылка);
			Запись.Вставить("Редактирует",                  Выборка.Редактирует);
			Запись.Вставить("НаЧтение",                     Выборка.НаЧтение);
			Запись.Вставить("ЧастичныйПуть",                Выборка.Путь);
			// Это справочник версий файлов.
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("РодительскаяВерсия", Метаданные.НайтиПоТипу(ТипЗнч(Выборка.Ссылка))) Тогда
				Запись.Вставить("Файл", Выборка.Ссылка.Владелец);
			Иначе
				Запись.Вставить("Файл", Выборка.Ссылка);
			КонецЕсли;
			СписокЗначений.Добавить(Запись);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокЗначений;
	
КонецФункции

&НаСервереБезКонтекста
Функция ФайлЗанят(Ссылка)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ИмяСправочникаХранения = Метаданные.НайтиПоТипу(ТипЗнч(Ссылка)).Имя;
	
	Если ИмяСправочникаХранения = "ВерсииФайлов" Или СтрЗаканчиваетсяНа(ИмяСправочникаХранения, "ВерсииПрисоединенныхФайлов") Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ЗначениеИстина
			|ИЗ
			|	Справочник." + ИмяСправочникаХранения + " КАК ВерсииФайлов
			|ГДЕ
			|	ВерсииФайлов.Ссылка = &Ссылка
			|	И ВерсииФайлов.Владелец.Редактирует <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИСТИНА КАК ЗначениеИстина
			|ИЗ
			|	Справочник." + ИмяСправочникаХранения + " КАК Файлы
			|ГДЕ
			|	Файлы.Ссылка = &Ссылка
			|	И Файлы.Редактирует <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)";		
	КонецЕсли;
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти
