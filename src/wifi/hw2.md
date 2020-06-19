### Дз к лекции 2 — Аналитическая модель OLSR

Автор: Войнов Никита
Группа: 521

#### ДЗ 1

Доказать

$<T_o>=\frac{1-(1-p)^s}{p(1-p)^s}$

$<T_С>=\frac{1-p^r}{p^r(1-p)}$

Рассмотрим состояние $O$.  Пусть успешному получению HELLO соотвествует 1, отсутствию HELLO — 0.

Процесс выходит из состояния $O$ при получении $s$ нулей подряд.

Разобьем нахождение в состоянии $O$ на циклы, цикл заканчивается при получении первой 1 или при получении $s$ нулей.

Среднюю продолжительность состояния $O$ можно определить как

$<T_O>=E(\sum_{i-1}^{N}X_i) = E(N)E(X)$,

где $N$ количество циклов, $X_i$ продолжительность цикла $i$.

Пусть $q=(1-p)$.

Найдем $E(N)$ и $E(X)$.

##### E(X)

Вероятность того, что продолжительность цикла равна

1: $p$

2: $(q)*p$

s-1: $(q)^{s-2}*p$

s: $(q)^{s-1}$

Тогда
$$
E(X) = s*q^{s-1} + p*\sum_{i=1}^{s-1}i*q^{i-1} = s*q^{s-1} + p * \frac{d}{dq}(\frac{q-q^{s}}{1-q}) = \frac{1-q^s}{1-q}
$$

##### E(N)

Вероятноcть того, что количество циклов равно

1: $q^s$

2: $q^s(1-q^s)$

n: $q^s(1-q^s)^{n-1}$

Тогда
$$
E(N) = q^s\sum_{i=1}^{\infty}i*(1-q^s)^{i-1} = -\frac{q^s}{s*q^{s-1}}*\frac{d}{dq}(\frac{1-q^s}{q^s})=\frac{1}{q^s}
$$

##### <T_O>

Исходя из (1) и (2):

$<T_O>=\frac{1-(1-p)^s}{p*(1-p)^s}$

##### <T_C>

Проведем замену $1-p \to p$, $s \to r$ получим:

$<T_С>=\frac{1-p^r}{p^r(1-p)}$

#### ДЗ 2

$\pi_{s}=\pi_o^2$

Доказательство:

Состояние симметричное с точки зрения узла X, если оно открыто с точки зрения узла X и в последнем принятом HELLO от узла Y оно было указано как открытое.

Вероятность каждого из событий $\pi_{o}$, события независимы => доказано.

 

#### ДЗ 3

[1]

Рассмотрим 2 независимых процесса узлов A и B, меняющие состояния O и C, $J^A$ и $J^B$. Определим процесс $J_{SN}$, который в состоянии S, если оба процесса в состоянии O, иначе он в состоянии N.

Докажем

$<T_S>=\frac{<T_O>}{2}$

Пусть $f_t$ распределение продолжительности состояния $O$, а $F(t)$ его функция распределения. Положим, что $J_{SN}(t)$ меняет свое состояние на S в момент $t_0$. Считаем, что $J^{A}$ переходит в O в момент $t_0$, а $J^{B}$ уже там был.

Рассмотрим временной интервал в течение которого $J^{B}$ остается в состоянии O, включая $t_{0}$. Очевидно, что вероятность, что продолжительность данного интервала = $\tau$ равна $\frac{\tau f_{\tau}}{<T_{O}>}$.

Рассмотрим часть интервала начинающуюся в $t_0$. Функция плотности распределения этой части определятся следующим образом:



$g(t)=\sum_{\tau>t}\frac{\tau f_{\tau}}{<T_{O}>}*\frac{1}{\tau}=\frac{(1 - F(t))}{<T_O>}$



Данная плотность отвечает следующей функции распределения:

$G(t)=\frac{1}{<T_{O}>}\int_0^t(1-F(x))dx$

$J_{SN}$ переходит из S, при первом выходе из $O$ для $J^A$ или $J^B$. Следовательно вероятность того, что продолжительность S не меньше $x$ равна $(1-F(x))(1-G(x))$

По свойству неотрицательной случайной величины получаем

$<T_S> = \int_{0}^{\inf}(1-F(x))(1-G(x))dx$

Т.к. $\frac{d}{dx}(1-G(x))=-\frac{1-F(x)}{<T_O>}$

$<T_S>=-\frac{<T_O>}{2}(1-G(x))^2|^{\infty}_{0}=\frac{<T_O>}{2}$

Доказано

#### ДЗ 4

Найти $<T_N>$

Смена S и N — on-off процесс, поэтому аналогично $\pi_o$:

$\pi_s=\frac{<T_S>}{<T_S> + <T_N>}=\pi_o^2$

$<T_N>=\frac{<T_S>}{\pi_o^2} - <T_S>$

,где

$\pi_{0}=\frac{<T_o>}{<T_o>+<T_c>}$

#### Источники

1. Khorov E. et al. Analytical study of neighborhood discovery and link management in OLSR //2012 IFIP Wireless Days. – IEEE, 2012. – С. 1-6.