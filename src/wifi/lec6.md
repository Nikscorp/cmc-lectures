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
- улучших Quolity of Experience
- ...

#### Главные плюшки

- Modified PHY
- Uplink Multi-user Multiple Input Multiple Output (UL MU MIMO), (802.11ac supports multiuser MIMO, but only in downlink mode. In contrast, 802.11ax adds uplink capability, so multiple users can upload video simultaneously)
- OFDMA (киллер фича) — появилось только тут
- Channel access modifications
- Features for enabling Spatial Reuse (SR) (две точки доступа работают рядом, но при этом разделяют канал без негативных последствий)
- Enhanced Power Efficiency



##### PHY Features

- Унаследовали с 11ac
- Changed numerology 1024 QAM
- Растянули OFDM символ 3.2 us (+ GI of 0.8us) -> 12.8 us (+GI of 3.2, 1.6 or 0.8 us) (omg, что это вообще значит, спасите).
  - GI это Guard Interval
  - Нужно, чтобы передавать на большие расстояния (?)
  - и уменьшать overhead от GI



> Номинальная скорость увеличилась всего на 37%
>
> Зато реальная конкретно увеличилась



То, что появился full-duplex — это миф.



Но появился MU Transmission в виде OFDMA.

В даунлинке просто посылаем всем одну преамбулу.

В аплинке пользователи отправляет одну и ту же преамбулу, синхронизируются базовой станцией.



------



Структура PHY кадров более подробно:

Преамбула: (Duplicated at every 20 MHz)

- L-STF
- L-LTF
- L-SIG
- RL-SIG
- HE-SIG-A (Contains some MAC layer information)

Дальше: (Transmittied in the whole used band)

- HE part of the preable
- HE-STF
- HE-LTF
- Data
- ...

 

…