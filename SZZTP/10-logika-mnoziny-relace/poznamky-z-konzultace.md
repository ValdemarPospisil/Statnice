
1. první otázka

- výrokový počet 40% 
- predikátový počet
- množiny 40%
- binární relace 20%

-- na jednu z nich se zeptá (o čem bys chtěl mluvit)
naučit se aspon 2-3
- predikátový počet si nikdo nevybral


### Výrokový počet

- výrok (určuje se zda je nebo není pravdivé)
- výrok x výroková formule(neznámá)
- atomární výrok - dále nedilitelný
- výrokové (logické) spojky
 -- my se zaměříme na binární spojky -- spojují dva výroky

 p q výroky -> p spojka q

kolik je binárních spojek?
pk(p) - pravda 1
      - nepravda 0

p q
1 1  -> 1/0
1 0  -> 1/0
0 1  -> 1/0
0 0  -> 1/0

=> 16 bin. spojek


1. základem je matematika

OR, AND, implikace, ekvivalentnost


2. Základem jsou logické obvody

NAND 
NOR


výroková formule/forma

x > 3 -- není to výrok, ale výroková forma
x = 5 -> 5 > 3 pravda
x = 0 -> 0 > 3 nepravda

atomární výrok

3+5 = 7
 se rovná (nepravdivý výrok)
-- jedno sloveso (tudíž to je atomární)


## Predikátový počet

- predikát = vždy se vztahuje ke konkrétnímu tématu
- nejběžnější predikát = 

Predikátový Počet pro množiny
- abeceda - symboly
 - výrokové proměnné - p,q,a,b
 - výrokové konstanty - 0,1
 - operace (spojky) na proměnných - and,or,implikace,ekvivalence,negace
 - predikátové proměnné - A,B,C,..
 - predikátové konstanty - prázdná..
 - predikáty: =, je elementem, není elementem, býti podmnožinou
 - operace (funktor)
 - kvantifikace: V(přeškrnuté) E (obrácené)

 gramatika
- slovem je: každý výrok
           : p and q, ...
           : A=B, ...
           : AsjednocenoB,...
    
Funktory se definují:
    A B = {x; xeA and xeB}
...


## Naivní teorie množin

x je elementem A or x není elementem A

A = B
A průnik B
A u B
A and B


## Systém množin

 - poteční množina
 - rozklad množiny

 A -> A1, A2, A3, .. , Ak

1) Ai nerovná se s prázdnou množinou
2) i nerovná j Ai and Aj = prázdná množina
3) U Ai = A

A := No
Ao = {0,3,6,9,...}
A1 = {1,4,7,10,..}
A2 = {2,5,8,11,..}


!NOTE Řekněte jak přesně zněla vaše otázka!
 - a říct čemu se budeme věnovat

## Binární relace

- zavedení a vlastnosti
- ekvivalence
- uspořádnání

Zavedení a vlastnosti
Relace R c A x B

|A| = 3
|B| = 5

|A x B| = |A| * |B| = 15

počet relací = počet podmnožin = 2**|A x B| = 2**15

1) Obory relace
 - První obor relace = čtverec R = {a; (a,b) e R}
 - Druhý obor relace = R čtverec = { b; (a,b) e R}

 A = {a,b,c}
B = {b,c,d,e}

R = {(a,b), (a,d), (a,e), (b,b), (b,d)}

čtverecR = {a,b} čtverecR e A
Rčteverec = {b,d,e} Rčtverec e B

2) znázornování relací

- kartézský graf
- uzlový graf

3) Vlastnoti relací na množině 

i) reflexivita
    R je reflexivní <=> (všechny x e A)
ii) antireflexivní
iii) symetrie
iv) antisymetrie
- slabá
    - připouští reflexvní prvky
-silná
v) tranzitivita


Ekvivalence
- je relace která je reflexivní, symetrická a tranzitivní

Uspořádní
- R je uspořádání na množině <=> R je (anti)reflexivní, antisymetrické, tranzitivní
- neostré uspo. (reflexivní)
- ostré uspo. (antireflexivní)


Hasseův diagram
i) vynecháváme reflexivní šipky
ii) vynecháváme tranzitivní šipky
iii) kreslíme diagram
        - odzdola nahoru, podle počtu vycházejících šipek
