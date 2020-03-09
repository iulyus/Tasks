﻿Функция CreateTask(Наименование, 
		СодержаниеСтрока = Неопределено, СодержаниеHTML = Неопределено,
		Статус = Неопределено, Родитель = Неопределено, 
		Контрагент = Неопределено,ВложениеСтруктура = Неопределено) Экспорт
	
	Перем пЗадача;
	
	СпрОбъект = Справочники.узЗадачи.СоздатьЭлемент();
	СпрОбъект.Наименование = Наименование;
	СпрОбъект.Статус = Статус;
	СпрОбъект.Родитель = Родитель;
	СпрОбъект.Контрагент = Контрагент;
	
	// +++ Григорьев  07.02.2019
	СпрОбъект.Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Обычная");
	// --- Григорьев  07.02.2019
	
	
	// +++ 79Vlad  06.02.2019	
	//Если Контрагент является и пользователем ИБ, то установим его исполнителем 
	Если ЗначениеЗаполнено(СпрОбъект.Контрагент) Тогда
		МассивКонтрагентов = Новый Массив();
		МассивКонтрагентов.Добавить(СпрОбъект.Контрагент);
		
		ТЗАдресаЭлектроннойПочты = узОбщийМодульСервер.ПолучитьТЗАдресаЭлектроннойПочтыПоМассивуКонтрагентов(
		МассивКонтрагентов);
		
		Для каждого стр Из ТЗАдресаЭлектроннойПочты Цикл
			Если ЗначениеЗаполнено(стр.АдресЭлектроннойПочты) Тогда
				//Попробуем найти ользователя ИБ		
				ТЗПользователей = узОбщийМодульСервер.ПолучитьТЗПОльзователейПоАдресуЭлектроннойПочты(стр.АдресЭлектроннойПочты,Ложь);
				Для каждого стрПользователь Из ТЗПользователей Цикл
					 Если стрПользователь.АвтоматическиСтановитьсяИсполнителемЕслиПрислалПисьмо Тогда
					 	СпрОбъект.Исполнитель = стрПользователь.Пользователь;
						//СпрОбъект.Статус = ПредопределенноеЗначение("Справочник.узСтатусыЗадачи.Backlog");
					 КонецЕсли; 
				КонецЦикла; 	 
				 
			КонецЕсли; 
		КонецЦикла; 
		
	КонецЕсли; 
	// --- 79Vlad  06.02.2019
	
	
	СпрОбъект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст");
	СпрОбъект.ПоказыватьВОтчетахИКанбанДоске = Истина;
	
	ФорматированныйТекст = Новый ФорматированныйДокумент;
	
	пТекстСодержания = СокрЛП(Наименование);
	пТекстHTML = СокрЛП(Наименование);
	
	СодержаниеHTMLЗаполнено = ЗначениеЗаполнено(СодержаниеHTML);
	
	Если СодержаниеHTMLЗаполнено Тогда
		
		пТекстHTML = СодержаниеHTML;
		//пТекстHTML = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(СодержаниеHTML);

		пТекстСодержания = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(СодержаниеHTML);
	Конецесли;
	
	Если НЕ СодержаниеHTMLЗаполнено
		И СодержаниеСтрока <> Неопределено Тогда
		пТекстСодержания = СодержаниеСтрока;	
		пТекстHTML = СодержаниеСтрока;
	Конецесли;
	
	Если ВложениеСтруктура = Неопределено Тогда
		ВложениеСтруктура = Новый Структура();
	Конецесли;
	
	ФорматированныйТекст.УстановитьHTML(пТекстHTML,ВложениеСтруктура);
	
	СпрОбъект.ТекстСодержания = пТекстСодержания;
	СпрОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));	
	
	СпрОбъект.Записать();
	
	пЗадача = СпрОбъект.Ссылка;
	Возврат пЗадача;
КонецФункции  

Функция GetTask(НомерЗадачи) Экспорт
	Перем пЗадача;
	
	пЗадача = Справочники.узЗадачи.НайтиПоКоду(НомерЗадачи);
	
	Возврат пЗадача;
КонецФункции

Функция GetKontragent(АдресЭлектроннойПочты) Экспорт
	Перем пКонтрагент;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	узКонтрагентыКонтактнаяИнформация.Ссылка
	|ИЗ
	|	Справочник.узКонтрагенты.КонтактнаяИнформация КАК узКонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	узКонтрагентыКонтактнаяИнформация.АдресЭП = &АдресЭлектроннойПочты
	|	И узКонтрагентыКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты)
	|	И узКонтрагентыКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.узEmailКонтрагенты)";

	Запрос.УстановитьПараметр("АдресЭлектроннойПочты", АдресЭлектроннойПочты);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат пКонтрагент;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	пКонтрагент = Выборка.Ссылка;
	
	Возврат пКонтрагент;
	
КонецФункции 

Функция CreateKontragent(Наименование = Неопределено, АдресЭлектроннойПочты) Экспорт
	Перем пКонтрагент;

	Если НЕ ЗначениеЗаполнено(Наименование) 
		И НЕ ЗначениеЗаполнено(АдресЭлектроннойПочты) Тогда
		ВызватьИсключение "Ошибка! не удалось создать контрагента, "
			+ "не задано наименование и/или адрес электронной почты для контрагента";
	Конецесли;
	
	пКонтрагент = GetKontragent(АдресЭлектроннойПочты);	
	Если ЗначениеЗаполнено(пКонтрагент) Тогда
		Возврат пКонтрагент;
	Конецесли;
	
	АдресЭлектроннойПочты = СокрЛП(АдресЭлектроннойПочты);
	
	СпрОбъект = Справочники.узКонтрагенты.СоздатьЭлемент();
	СпрОбъект.Наименование = Наименование;
	
	СтрокаКонтактнаяИнформация = СпрОбъект.КонтактнаяИнформация.Добавить();
	СтрокаКонтактнаяИнформация.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты");
	СтрокаКонтактнаяИнформация.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.узEmailКонтрагенты");
	СтрокаКонтактнаяИнформация.АдресЭП = АдресЭлектроннойПочты;
	СтрокаКонтактнаяИнформация.Представление = АдресЭлектроннойПочты; 
	
	СпрОбъект.Записать();
	
	пКонтрагент = СпрОбъект.Ссылка;

	Возврат пКонтрагент;
КонецФункции 


