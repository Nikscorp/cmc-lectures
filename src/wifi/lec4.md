##### Beacons

Data Frames, Control Frames, Management Frames — кадры Wi-Fi

Control: ACK,RTS,CTS, CF-Pol (нужно послать очень-очень быстро, обрабатываются аппаратно, генерируются строго в определенный момент времени) 

Management: меняют режим, сообщают дополнительную служебную информацию (генерируются программно, могут посылаться не сразу) .

Так вот, биконы это Management frame.

- Mesh ID вместо SSID

Beacon Interval — когда системные часы кратны Beacon Interval — Beacon отправляются, 100 Time Units, 

1 Time Unit = 1024 microsecs

С помощью beacon устройства обнаруживают друг друга, узнают о параметрах сети, распространяется служебная информация.

Синхронизация происходит с помощью биконов: поле TSF — в нем указывается значение системных часов в микросекундах по модулю 2^64.

В Adhoc сетях часы обновляются если присланное время больше чем свое.

Beacon кладется в очередь...

------

##### Синхронизация

В mesh сетях синхронизация проходит также как в adhoc, только вместо коррекции времени запоминается offset для каждой станции.

Когда другая станция говорит о событии, которое произойдет в момент $T$ (по другим часам), по собственным оно произойдет во время $T-offset$.

##### Избегание конфлитков биконов

(Mesh beacon collision avoidance (MBCA) — 14.13.4 в стандарте)

В основном направлено на уменьшение коллизий со скрытыми станциями (что часто для mesh сетей).

Глобально состоит из:

- Beacon timing advertisements
- TBTT selection
- TBTT adjustment

Каждая станция отслеживает TBTT (Target Beacon Transmission Time) своих соседей

- Как узнать когда именно TBTT станции?

$T_{TBTT}=T_r -(T_t mod (T_{BeaconInterval} \times 1024))$ 

где

$T_r$ — время получения фрейма в терминах TSF

$T_t$ — значение поля Timestamp время в полученном фрейме

$T_{BeaconInterval}$ — значение поля Beacon Interval в полученном фрейме

Рассылается информация (соседям) обо всех TBTT в единицах измерения 32 us, бекон-период в 1024us

=> с помощью беконов узнаем о соседях

Полученная информация позволяет настраивать TBTT на станциях так, чтобы минимизировать коллизии, алгоритм подробно не рассматривался.

##### Управление соединениями

Mesh Peering Management

**Открытие соединений**

- ->Peerig Open frame
- <- Peering Confirm frame
- <-Peering Open frame
- ->Peering Confirm frame

**Закрытие**

- ->Peering Close Frame
- <-Peering Close Frame

Все указанные кадры являются управляющими кадрами Management Action Frames.

(На каждый из пакетов еще посылаются аки)

Также дополнительно возможно секьюрное соединение (+обмен ключами)

После установки соединение будет считаться симметричным (отличие от OLSR)

##### Маршрутизация

- HWMP (Hybrid Wireless Mesh Protocol) — гибридный (проактивный + реактивный)
  - ранее рассматривался RA-OLSR
  - Является развитием AODV
  - Два режима работы
    - реактивный
    - Проактивный (...)
    - Могут работать вместе

##### Метрики маршрутизации

- HopCount
- ETX = Expected transmission count
  - Каждому линку приписывается переменная — среднее число попыток до успешной отправки
- ETT = Expected Transmission time
  - учитываются выбираемые СКК (сигнально кодовые конструкции)
- Airtime Link Metric
  - Используется в 802.11
  - Более точная ETT, учитывает сколько времени занят канал
  - $c_a=[O + \frac{B_t}{r}]\frac{1}{1-e_f}$
  - $B_t$ — длина тестового пакета в битах (8192)
  - $O$ — overhead не завиясящий от скорости (преамбула + SIFS + DIFS)
  - $r$ — data rate (Mb/s) represents the data rate at which the mesh STA would transmit a frame of standard size $B_t$ based on current conditions, and its estimation is dependent on local implementation of rate adaptation
  - $e_f$ — is the probability that when a frame of standard size $B_t$ is transmitted at the current transmission bit rate r, the frame is corrupted due to transmission error; its estimation is a local implementation choice. Frame failures due to exceeding Mesh TTL should not be included in this estimate as they are not correlated with link performance.
  - $1/(1-e_f)$ — среднее число попыток передачи
  - Еще можно добавить backoff + время нахождения в очереди
- Другие метрики



##### Требования к метрикам

Дейкстра и Беллман-Форд требуют, чтобы метрика обладала свойствами:

Изотоничность: метрика будет изотоничная если при добавлении к каким то маршрутам звена или маршрута их качество по отношению к друг другу не меняется

**ДЗ**

Привести пример метрик которые обладают / не обладают таким свойством

##### Метод доступа MCCA

- MCF controlled channel access
- Аналог HCCA

MCF controlled channel access (MCCA) is an optional access method that allows mesh STAs to access the WM at selected times with lower contention than would otherwise be possible. This standard does not require all mesh STAs to use MCCA. MCCA might be used by a subset of mesh STAs in an MBSS.

###### Резервирование

Обычный DCF плохо работает в Mesh сетях — в основном из за скрытых станции

Две станции договориваются о временных итервалах передачи и рассылают это время бродкастом.

Все эти резервирование происходят периодически (метод периодических резервирований (много где используются)).

Три числа чтобы описать такие периоды

- длительность
- период
- смещения

При ненадежной передаче (вероятность успешной передачи p<1) резервирование устанавливаются чаще чем период поступления пакетов.

###### Аналитическая модель

1. https://www.researchgate.net/publication/220654266 (по сути то, что ниже)
2. https://www.researchgate.net/profile/A_Lyakhov/publication/254037355_Mathematical_model_of_MCCA-based_streaming_process_in_mesh_networks_in_the_presence_of_noise/links/0deec5209e9cb33078000000/Mathematical-model-of-MCCA-based-streaming-process-in-mesh-networks-in-the-presence-of-noise.pdf (финальная версия статьи с усложненной моделью)

Постановка задачи

Вход:

- максимальная доля потерянных пакетов $L_{QOS}$
- максимальное время доставки пакетов $D_{QOS}$

Найти:

с каким интервалом следует устанавливать периодичные интервалы отправки? (по сути посчитать PLR, исходя из него можно подобрать оптимальный выбор таких интервалов)

Всю ось разбиваем на временные слоты $\tau$ — НОД (интервал между пакетами, период резервирований) — не обязательно целый

Интервал между пакетами = $t_p\tau$

Период резервирований =  $t_r\tau$



Шкала времени разбивается так, чтобы период резервирования  совпадал с началом слота. Моменты поступления будут сдвинуты относительно начала слота на $\xi$.

Описание процесса

- марковская цепь с единицей времени: период резервирования
- Состояние: $h(t)$:
  - $h(t) \ge 0$ — возраст (в слотах) самого старшего пакета в очереди
  - $h(t) < 0$ — время прибытия (в слотах) следующего пакета
  - Минимальное значение $h(t)=-t_p+t_r$ 
  - Максимальное значение $h(t) \le d =\lfloor{\frac{D-\xi}{\tau}}\rfloor$, $D=D_{QOS} - TransmissionTime$

Расчеты:

$h>=0$:

1. $h \to h - t_p + t_r$ — Когда самый старший пакет или успешно передается или отвергается ($h+t_r>d$)
2. $h \to h + t_r$ — Ошибка передачи и $h+t_r \le d$

$h<0$

1. $h \to h + t_r$



Итого, т.к. пакет сбрасывается с вероятностью $(1-p)$ из любого состояния, где $h+t_r > d $, при этом кол-во принятых пакетов = $t_r/t_p$

$PLR=\frac{(1-p)\sum_{i=d-t_r+1}^{d}\pi_i}{t_r/t_p}$

###### Результаты

![Screenshot 2019-03-09 at 11.29.23](/img/Screenshot%202019-03-09%20at%2011.29.23.png)

Забавный или не очень факт в том, что PLR(t_r) не является монотонной в любой точке, т.к. максимальное число попыток передачи, которое определяет  PLR. Подробнее про это можно почитать в статье.