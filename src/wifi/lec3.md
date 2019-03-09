#### Способ получения сетевой (маршрутной) информации

![image-20190226204431043](/img/image-20190226204431043.png)

- Проактивный
  - информация о маршрутах посылается периодично (не зависит не от чего, кроме протокола) 
  - например OLSR, DSDV
- Гибридный (проактивный + реактивный):
  - можно ограничивать области применения реактивного и проактивного подходов для разных маршрутов 
  - HWMP
- Реактивный:
  - если что-то нужно, то информация рассылается, если нет — то нет. То есть сетевая информация ищется строго по запросу.
  - Например ADV.

##### Классификация проактивных протоколов

![image-20190226204508490](/img/image-20190226204508490.png)



- выделяется подход с прореживанием broadcast сообщений
  - Каждую секунду шлем bc с маршрутами с TTL=1
  - Каждую 2 секунды шлем bc с маршрутами с TTL=2
  - Каждую 4 секунды шлем bc с маршрутами с TTL=4
  - ...
  - 256 (или диаметр сети)
  - такой подход сильно уменьшает оверхед
- FishEye, FSLS используют технику выше + HSLS



##### Тип маршрутной информации

![image-20190226204607110](/img/image-20190226204607110.png)

- LS=Link State — хранима информацию о подмножестве соединений (графе) на котором можно в любой момент запустить поиск кратчайшего пути (чаще проактивные)
  - Next-Hop Routing — могут содержаться кольца
  - Source Routing — (источник строит маршрут) плохо для динамичных сред
- DV=Distance Vector — маршруты строятся распределенно (чаще реактивные)
  - Алгоритм дейкстры работает распределено (?)
  - счетчик до бесконечности
- Еще один пункт, но это неважно

##### Возможность кластеризации

![image-20190226204619145](/img/image-20190226204619145.png)

#### IEEE 802.11s WiFi Mesh

WiFi Mesh интегрированно в канальный уровень

- нужно чтобы использовать эксклюзивную информацию с канального уровня

##### MBSS

Новая архитектура в добавление к инфраструтурной и AdHoc сетях.

Mesh BSS — сеть из равноправных узлов, при котором возможна передача через произвольные (?) промежуточные узлы.

Итого:

- В отличии от BSS можно передавать даже если станции не слышат друг друга
- нет точек доступа, но могут быть шлюзы
- Можно использовать MBSS, чтобы объединить несколько BSS в одну ESS

##### Особенность адресации кадров

Сколько нужно адресов? От 4 до 6.

1. RA — адрес следующего хопа (следующей меш станции)
2. TA  — Адрес передающей меш станции
3. DA (dst) —  Адрес назначения меш станции (итоговый) 
4. SA (src) —  исходная меш станция
5. DEA — Исходный получатель (нужен, если например адрес внешний)
6. SEA — Исходный отправитель

##### Биконы

- Mesh ID вместо SSID
- Генерирует и рассылает каждая станция
- Биконы **генерируются** периодически (В BSS генерируются одной, в AdHoc все пытаются послать Beacon, но посылает в итоге одна)