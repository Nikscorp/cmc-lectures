### 802.11n

#### BlockACK

##### 802.11e

> Некоторые дополнения к Лекции 5.

Блочное подтверждение улучшает использование ресурсов

2 метода подтверждения: 

Immediate

Delayed

BlockACK появился как механизм, который может быть реализован в драйвере, а не в железе.

Становится очевидным почему может быть Delayed — можно медленно обработать в драйвере.

"Больше задержка, но зато хорошо"

Картинки работы см на слайде

Мы отправили BlockACKReq.

Станция, которая отправила BlockACKReq — знает дошло ли или нет (по BlockACK) — если нет — повтор.

В immediate не нужен ACK на BlockACK, но в delayed нужен .

BlockACKReq — имеет 2 интересных поля: BARControl, в нем указан TID (тип трафика)

BlockACKStartingSequnceControl — состоит из 2 подполей: номер пакета, номер фрагмента.

В ответ приходит BlockACKResponse.

BTW, помимо BlockAck в 802.11e появилось (задается в поле QosControl):

- NoAck
- NormalAck
- No explicit ACK (?)
- Сам blockAck

##### 802.11n

в 11n было улучшено.

BlockACK был один — Basic, добавили сжатый (compressed) и multi-tid.

В BARControl  ключевыми полями являются Multi-tid и compressed.

Multi-tid blockACKReq появилось дополнительное поле переменной длины, указываем для каждого TID может быть несколько SequenceControl.

> Как я понял, MultiTID может просто подтверждать пакеты из разных TID.

В Compressed мы учитываем только MSDU, а не фрагменты.

> Не путать агрегацию и фрагментацию, агрегация появилась в 802.11n, фрагментация +- deprecated, начиная с 802.11n (это неточно).

> Compressed используется, если не используется фрагментация. При compressed размер bitmap 8 байт (64 MPDU), без — 128. (16 фрагментов * 64 MPDU)

ADDBA Request — starting sequence number, BlockACK timeout, BufferSize

ADDBA Response — buffer size, Block ACK timeout.

ADDBA: 

- Dialog Token
- Block Ack Parameter Set
- Block Ack Timeout Value

Повторные попытки передач: 

Делаем попытки передачи не по retry-limit, а по времени жизни MSDU.

Делим пространство номеров пополам, все пространство номеров больше выбранного — новые, остальные — старые.

> Зачем?

См. пикчу со слайдов (с кругом)

Есть буфер мы передаем пакеты (MSDU) наверх до первой дырки.

Пакет передаем наверх по lifetime.

Окно сдвигается, если пришел кадр за пределами окна, либо если вручную это сделал BlockACK.

11e — поверхностно, 11n — подробнее.

##### BlockAck Modifications

Для более простых устройств:

Full state — always maintain the bitmap.

Partial-state — can reset the bitmap if frames from another transmitter are received.

#### MIMO

> SU MIMO появился в 802.11n
>
> 802.11n поддерживает 4 x 4 : 4 SU MIMO.

Благодаря MIMO мы увеличиваем скорость передачи данных, можно увеличить payload (число бит передаваемых в единицу времени).

STBC — специальный тип кодирования, мы можем увеличить дальность передачи сигналов  за счет того, что по нескольким антеннам идет один поток.

Когда у нас есть несколько антенн, мы можем увеличивать количество spatial-stream — страдает дальность, но этот подход выгоднее на более близких расстояниях.

Суть spatial-stream: физический пакет есть, вот он может передаваться быстрее.

> По сути MIMO ускоряет текущую СКК. (Так это моделирует NS3).

Фактически на приемнике нужно решать некоторые линейные уравнения, для этого нужно произвести оценку канала.

Для использования MIMO кадр усложняется: нужно передавать специальные символы, которые  позволяют "натренировать" канал + добавляются специальные параметры.

HT-SIG — новые ССК, используется ли MIMO, сколько spatial стримов.

Далее идут специальные тренировочные поля по количество spatial стримов + дополнительные поля для ресивера.

В 11a поле signal содержало ССК и длину пакета.

Кадры являются обратно совместимыми.

L-SIG — указывается минимальная скорость, длина пакета (фейковая)

HT-GREENFIELD-PPDU — "зеленое" поле, значит, что legacy-станций нет, и мы может использовать сжатый кадр.

max HT length — 64Кб.

Длина кадра ограничивается A-MSDU.

#### LSIG TXOP Protection

Тк обратной совместимости нет, становится актуальной задача донести информацию о передаче (NAV) до легаси станций. В 802.11n появилась возможность делать это на физическом уровне.

> In 802.11g, there was only one protection mechanism defined. Before transmitting in the newer style, a device had the responsibility to transmit in a backward compatible way to make sure older stations correctly deferred access to the medium. The most common way of achieving this is for a device to transmit a CTS frame to itself, using an older modulation that can correctly be processed. Before transmitting a frame using the “new” style, a station sends a frame in the “old” style that tells receiving MACs to defer access to the medium. Although an older station is unable to detect the busy medium, it will still defer access based on the medium reservation in the CTS.

> In addition to the MAC-layer protections, 802.11n adds a new PHY-layer protection mechanism. The PLCP contains information on the length of a transmission, and 802.11n sets up the physical-layer header so that it includes information on the length of transmissions.

L-SIG TXOP Protection — защита TXOP с помощью того значения, которое мы указывали в поле L-SIG.

В L-SIG — некорректные данные (фейковая длина пакета). Будем выставлять это значение в большее, чем нам нужно для передачи нашего кадра + передача в обратную сторону.

Та станция, которая услышит L-SIG будет считать, что канал занят и не будет передавать.

NAV, который выставляется на физическом уровне.

Для durationid нужно декодировать RTS/CTS, если какая-то из станций его не слышит, но получив из поля L-SIG это значение, значит, ей не нужно что-то декодировать и все норм.

### 802.11 ac

#### Channel bonding

В 11ac стало возможным использование полосы до 160Мгц.

Всегда определяется primary 20Мгц канал.

Primary и secondary.

Primary половина — там где лежит primary20, вторая половина secondary.

2.4 нельзя — не хватит ширины полосы.

backoff считаем в primary20 (слушаем только его), мы можем вести передачу и принимаем решение в котором канале вести передачу. Если secondary канал был свободен в течение PIFS можем его задейстовать, если secondary40 был свободен в течение PIFS, то передаем в 80Мгц, если secondary80 был свободен то передаем в 160 МГц.

Кадр RTS/CTS должен передаваться во всей используемой полосе, чтобы покрыть всю будущую передачу.

CTS — должен передаваться в legacy формате. (в 20 Мгц)

Внимание вопрос: воспользовавшись стандартом ответьте, что нужно делать с RTS, BlockAck, BlockAckRequest.

В 11ac MU-MIMO — данные передаются одновременно нескольким станциям.

Мы одновременно передаем разные пакеты, которые передаются разным станциям.

Backoff считаем в primary, а выбор primary / secondary происходит в момент передачи:

- 20
- 40
- 80

