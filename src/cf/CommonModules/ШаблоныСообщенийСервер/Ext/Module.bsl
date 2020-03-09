﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обратная совместимость.
// Создает описание таблицы параметров шаблона сообщения.
//
// Возвращаемое значение:
//   ТаблицаЗначений - Сформированная пустая таблица значений.
//    * ИмяПараметра                - Строка - Имя параметра.
//    * ОписаниеТипа                - ОписаниеТипов - Описание типа параметра.
//    * ЭтоПредопределенныйПараметр - Булево - Является ли параметр предопределенным.
//    * ПредставлениеПараметра      - Строка - Представление параметра.
//
Функция ТаблицаПараметров() Экспорт
	
	ПараметрыШаблона = Новый ТаблицаЗначений;
	
	ПараметрыШаблона.Колонки.Добавить("ИмяПараметра"                , Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
	ПараметрыШаблона.Колонки.Добавить("ОписаниеТипа"                , Новый ОписаниеТипов("ОписаниеТипов"));
	ПараметрыШаблона.Колонки.Добавить("ЭтоПредопределенныйПараметр" , Новый ОписаниеТипов("Булево"));
	ПараметрыШаблона.Колонки.Добавить("ПредставлениеПараметра"      , Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	
	Возврат ПараметрыШаблона;
	
КонецФункции

#КонецОбласти
