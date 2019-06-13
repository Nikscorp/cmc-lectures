### 802.11 ax

Заканчивается разработка, поступит в продажу (массовую) через год (2020 год).

Эволюция стандартов:

1. 802.11a и g используют OFDM (a для 5ГГц, g для 2.4 Ггц, в остальном стандарты похожи)
2. 802.11n — MIMO + расширение полосы [5/2.4]
3. 802.11ac — higher order channel bonding & MIMO + MU MIMO [только 5Гц, т.к. для 2.4 нет полосы 60МГЦ]
4. 802.11 ax — OFDMA + UL MU MIMO

802.11 ax не для увеличения номинальной скорости передачи пакетов, он для увеличения реальной скорости.

Например, 11ac может в теории передавать 7Gbps, но условия почти нереальные:

- насышенная передача
- нет интерференции
- большая полоса
- по 8 антенн на отправителе

В жизни все не так.

#### Основные цели

**High Efficiency**

- Улучшение перфоманса в плотных сетях
- улучших Quality of Experience

#### Главные плюшки

- Modified PHY
- Uplink Multi-user Multiple Input Multiple Output (UL MU MIMO), (802.11ac supports multiuser MIMO, but only in downlink mode. In contrast, 802.11ax adds uplink capability, so multiple users can upload video simultaneously)
- OFDMA (киллер фича) — появилось только тут
- Channel access modifications
- Features for enabling Spatial Reuse (SR) (две точки доступа работают рядом, но при этом разделяют канал без негативных последствий)
- Enhanced Power Efficiency, например TWT.

> Номинальная скорость увеличилась всего на 37%
>
> Зато реальная конкретно увеличилась

То, что появился full-duplex — это миф.

Но появился MU Transmission в виде OFDMA.

В даунлинке просто посылаем всем одну преамбулу.

В аплинке пользователи отправляет одну и ту же преамбулу, синхронизируются базовой станцией.

##### PHY Features

- Унаследовали с 11ac
- Changed numerology: 1024 QAM
- Растянули OFDM символ 3.2 us (+ GI of 0.8us) -> 12.8 us (+GI of 3.2, 1.6 or 0.8 us) (omg, что это вообще значит, спасите).
  - GI это Guard Interval
  - Нужно, чтобы передавать на большие расстояния (?)
  - и уменьшать overhead от GI

> To increase the number of tones per band and, thus, to provide better granularity for OFDMA, the OFDM symbols used for PHY payload are 4 times longer, i.e. 12.8 µs instead of 3.2 μs [5]. Long OFDM symbols also improve robustness especially for the UL MU transmission in outdoor scenarios prone to large timing jitter across the users.

Преамбула состоит из двух частей:

- Legacy
- HE (новая для ax)
  - HE-SIG-A
  - HE-SIG-B

###### Legacy

Нужна для обратной совместимости (или ее воркэраунда с L-SIG Protection). Также содержит training sequences needed for the receiver to synchronize on the received signal.

###### HE

Начинается с повторения LSIG, это важно для плотных сетей. Затем идут SIG-A, SIG-B.

###### HE-SIG-A

Длинной 2 OFDM символа. Дублируется каждые 20 Мгц, содержит информацию важную для принятия пакета: СКК, число spatial стримов, bw. Также в нее запихнули часть информации с MAC, например TXOP duration (это нужно для экономии энергии). Тк важно принять эту часть надежно возможно хитрое дублирование данного заголовка / кадра / чего? По сути содержит всю необходимую информацию для SU передачи.

###### HE-SIG-B

Используется, когда происходит MU передача (OFDMA или MU MIMO). Содержит информацию для всех станций, затем идет информация для конкретной станции. Для увеличения надежности дублируется каждые нечетные 20Мгц.

##### MultiUser

- Появился UL MU MIMO, это сложней чем DL.
- Появился OFDMA

> To simplify resource management, in .11ax network each transmission occupies a particular set of OFDM tones called RU. A RU can contain 26, 52, 106, 242, 484 or 996 tones (including service ones). The whole 20 MHz band, 40 MHz band, 80 MHz band and 160 MHz band correspond to a 242-tone RU, two 242-tone RUs, two 484-tone RUs and two 996-tone RUs, respectively. Each wide RU can be split into two approximately twice-narrower RUs. In turn, each of them can be split again, separately from another one. The only exception is that in a 20 MHz band a 242-tone RU can be replaced by 2 106-tone RUs and one 26-tone RU.

###### MU MIMO

Может использоваться совместно с OFDMA, но только в RU>=106.

###### OFDMA

В случае даунлинка все +- просто, информация о распределении RU хранится в пакете. Посылается общая преамбула, а затем разные payload.

С аплинком все сложней:

- Станции сообщают о размере своего буфера
- Учитывая эту информацию точка доступа выделяет RUs и рассылает эту информацию с помощью нового Trigger frame, станции должны произвести отправку сразу при получении Trigger frame. (Но есть нюанс — In contrast to legacy STAs, which ignore their Network Allocation Vectors (NAVs), if any, when transmit an immediate response, a .11ax STA shall cancel its UL transmission if its NAV is nonzero, unless it transmits an ACK or BlockAck, or the NAV was set by the AP, which is the originator of the Trigger frame. Apart from that, the STA shall not transmit if its transmission exceeds the UL transmission duration indicated in the Trigger frame.)
- Круто, что все это можно делать добавляя информацию из Trigger Frame в DL MU фрейм — и, например моментально доставлять ACK пакеты.

##### Доступ к каналу

Помимо описанного выше MU доступа существует Aloha-подобный механизм доступа к каналу. Предполагается, что базовая станция не знает об очередях. Для этого используется OFDMA Back-off процедура. Сначала взводится рандомный бэкофф (OFDMA contention window). При получении Trigger frame он уменьшается на количество RU в этом фрейме. Когда счетчик достигает нуля — выбирается рандомный RU и производится передача.

Также предполагается (для отказа от всяких RTS/CTS и ненужных IFS) использовать механизм roster (список). По сути это реализация идеи критического доступа с помощью токена. Так, составляется список станций которые могут передавать в данный временной промежуток. В этом списке в определенной последовательности станции передают, при этом если станции нечего передать — токен передается следующей станции в списке. Это работает лучше чем MCCA, так как канал выделяется для группы станций.

##### Spatial Reuse

Данное предложение предлагает различать кадры из своего BSS и чужого BSS. Для этого каждая станция случайно выбирает себе 8-ми битный номер — BSS color. Данное значение добавляется в HE-SIG-A. Такой подход позволяет эффективней различать занятость канала на физическом уровне и канальном уровне (не убивать свой NAV по CF-END с другого BSS).