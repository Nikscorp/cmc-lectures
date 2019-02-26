## Многошаговые сети Wifi

Задачи:

- Увеличить покрытие
- Повысить емкость (хз что такое емкость)

Идея — передавать цепочкой через промежуточные узлы

802.11s (появились многошаговые сети)

### Название

Существует 2 схожих названия для многошаговых сетей

- Mesh сеть
  - IEEE
  - сеть в которой маршрутизация работает на канальном уровне
  - стационарная сеть

- MANET — Mobile Ad hoc NETwork
  - IETF
  - маршрутизация выполняется на сетевом уровне
  - мобильная сеть

Мы будем понимать многошаговую сеть следующим образом:

Многошаговая беспроводная сеть — сеть, в которой доставка информации возможна через промежуточные узлы, выступающие в роли ретрансляторов

### Задачи построения многошаговых сетей

(По сути это все нужно для обеспечения маршрутизации)

- обнаружение соседей
- управление соединений с ними (логическими, для Health-статусов)
- Оценка качества соединений (чтобы решать задачу маршрутизации оптимальным образом)
- Рассылка сетевой информации
- Построение маршрутов
- Ретрансляция

Особенность — динамическая сетевая среда, очень быстро меняются условия

### Лавинная рассылка

Широковещательная рассылка с TTL, не меньше чем диаметр сети

Плюсы:

- простота
- устойчивость к высоким скоростям движения узлов
- относительная надежность доставки при наличии большой избыточности маршрутов
- “естественная оптимальность“ пути (НО много узлов делят один канал => лишние ожидания)

Минусы:

- большие накладные расходы (каждый пакет повторяется до N-1 раз)
- необходимость механизма разрешения / избегания коллизий широковещательных пакетов
  - Необходимо, т.к. на широковещательные пакеты нет ACK
- Высокие потери (видимо эффективности), если маршрут (или его часть) единственный

### Протоколы маршрутизации

#### OLSR и NHDP

Optimized Link State Routing Protocol — RFC 3626 — https://tools.ietf.org/html/rfc3626

OLSR v2 — RFC 7131

Мы изучаем первую версию протокола

Neighborhood Discovery Protocol (**NHDP**) — RFC 6130

- Проактивный протол, рассылающий информацию о наличии соединений

- Не учитывает качество соединений. Оптимизация объема рассылаемой информации

Работает как программа поверх канального уровня.

Программа рассылает UDP пакеты, через которые происходит обмен информации, по ним составляются таблицы маршрутизации

##### Обнаружение соседей:

- периодическая рассылка Hello сообщений (Link Sensing)
  - Интервал HELLO_INTERVAL = 2s
  - Проблема синхронизации
    - Джиттер — от планируемого времени генерации пакета отнимается случайное время [0 ... MAXJITTER]​, MAXJITTER=HELLO\_INTERVAL / 4​
    - Actual message interval = MESSAGE_INTERVAL - jitter

- Hello сообщение содержит:
  -  список (адресов) соседей про которые знает станция
  - Состояния соединений (содержится в поле link code)
    - S = symmetric (получили hello и там есть наш адрес)
    - U = однонаправленные (услышали о ком-то, но он о нас не знает) (Heard)
    - C = Закрытые / потерянные (Closed/Lost) — переходим если в течение NEIGBH_HOLD_TIME не пришло не одного Hello сообщения.
- Также содержит информацию о том, считает ли сосед принимающую станцию MPR

Знаем полную топологию в двухшаговой окрестности узла.

MPR узлы (Multipoint Relay) — те симметричные одношаговые соседи, через которые можно достучаться до двухшаговых.

> The idea of multipoint relays is to minimize the overhead of flooding messages in the network by reducing redundant retransmissions in the same region.

> The neighbors of node N which are *NOT* in its MPR set, receive and process broadcast messages but do not retransmit broadcast messages received from node N.

> Each node selects its MPR set from among its 1-hop symmetric neighbors. This set is selected such that it covers (in terms of radio range) all symmetric strict 2-hop nodes.

> The MPR set of N, denoted as MPR(N), is then an arbitrary subset of the symmetric 1-hop neighborhood of N which satisfies the following condition: every node in the symmetric strict 2-hop neighborhood of N must have a symmetric link towards MPR(N).

> Each node maintains information about the set of neighbors that have selected it as MPR. This set is called the "Multipoint Relay Selector set" (MPR selector set) of a node. A node obtains this information from periodic HELLO messages received from the neighbors.

Пытается построить миниммальное количество MPR узлов

Построение через жадный алгоритм

> A. Qayyum, L. Viennot, A. Laouiti. Multipoint relaying: An efficient technique for flooding in mobile wireless networks. 35th Annual Hawaii International Conference on System Sciences (HICSS’2001).

##### Рассылка сообщений TC (Topology Control)

- Topology Control
- Рассылается broadcastom
- Раз в TC_INTERVAL (5 секунд)
- Пересылаются MPR узлами
- Содержат информацию только об MPR Selector Set
- Высылает список адресов (только тех, кто выбрал данный узел в качестве MPR) с которыми установленны симметричные соединения
- Ретранслируются дальше только MPR-ми

Таким образом получается подсеть, в которой не увиличиваются длины маршрутов (по метрике hop-count)



##### Поиск маршрута и таблица маршрутизации

1. R_dest_addr R_next_addr R_dist (число шагов) R_iface_addr
2. R_dest_addr R_next_addr R_dist R_iface_addr
3. ...

R_dest_addr — куда нужно доставить пакет

R_next_addr — адрес next-хопа

R_dist — метрика

R_iface_addr — интерфейс

Обновляется каждый раз, когда происходят изменения.

Заполняется по очереди: сначала по информации о соседях, затем двухшаговых соседях, затем по остальным соединениям в порядке их удаления от узла.

Обновляется каждый раз (конкретно полностью), когда происходят изменения:

- link set (содержит информацию о соединениях с соседями и их статусе)
- neighbor set (содержит информацию о соседях и их статусе)
- 2-hop neigbour set (содержит информацию о двухшаговых соседях)
- the topology set (содержит информацию о “дальних” соединениях, полученную из TC)
- Multiple Interface Association Information Base (содержит информацию о соответствии нескольких адресов одному узлу (распространяется через MIB сообщения))



1. Потворить прошлый семестр (нужна будет в этом году)

---------



##### Дополнительная информация

Also, OLSR does not require sequenced delivery of messages. Each control message contains a sequence number which is incremented for each message. Thus the recipient of a control message can, if required, easily identify which information is more recent - even if messages have been re-ordered while in transmission.

OLSR does not require any changes to the format of IP packets. Thus any existing IP stack can be used as is: the protocol only interacts with routing table management.

##### Формат пакета

OLSR communicates using a unified packet format for all data related to the protocol. The purpose of this is to facilitate extensibility of the protocol without breaking backwards compatibility. This also provides an easy way of piggybacking different "types" of information into a single transmission, and thus for a given implementation to optimize towards utilizing the maximal frame-size, provided by the network. These packets are embedded in UDP datagrams for transmission over the network. The present document is presented with IPv4 addresses.



Packets in OLSR are communicated using UDP. Port 698 has been assigned by IANA for exclusive usage by the OLSR protocol.

The basic layout of any packet in OLSR is as follows (omitting IP and UDP headers):

![image-20190213005126118](./img/image-20190213005126118.png)

- The Packet Sequence Number (PSN) MUST be incremented by one each time a new OLSR packet is transmitted.

  - Нужно для того, чтобы понимать какую информацию считать более свежой

- The IP address of the interface over which a packet was transmitted is obtainable from the IP header of the packet.

- Vtime

  This field indicates for how long time after reception a node MUST consider the information contained in the message as valid, unless a more recent update to the information is received. The validity time is represented by its mantissa (four highest bits of Vtime field) and by its exponent (four lowest bits of Vtime field). In other words:

  validity time = C*(1+a/16)* 2^b [in seconds]

  where a is the integer represented by the four highest bits of Vtime field and b the integer represented by the four lowest bits of Vtime field. The proposed value of the scaling factor C is specified in section 18.

- Originator Address

  This field contains the main address of the node, which has originally generated this message. This field SHOULD NOT be confused with the source address from the IP header, which is changed each time to the address of the intermediate interface which is re-transmitting this message. The Originator Address field MUST *NEVER* be changed in retransmissions. — WTF

- Hop Count

  This field contains the number of hops a message has attained. Before a message is retransmitted, the Hop Count MUST be incremented by 1.

  Initially, this is set to ’0’ by the originator of the message.

- Message Sequence Number

  While generating a message, the "originator" node will assign a unique identification number to each message. This number is inserted into the Sequence Number field of the message. The sequence number is increased by 1 (one) for each message originating from the node. Message sequence numbers are used to ensure that a given message is not retransmitted more than once by any node.