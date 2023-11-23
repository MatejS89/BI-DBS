# BI-DBS
My semestral work for BI-DBS at Czech Technical University in Prague
## Description:

Stanica ChooChoo sa nachádza na začiatku rušného transportného uzla a denne vypraví niekoľko desiatok vlakov.

Každý vlak má svoje unikátne ID. Ku vlaku evidujeme jeho jazdy, ktoré majú vlastné unikátne ID, čas odjazdu, cieľ a vzdialenosť do konečnej stanice.

Vlaky kategorizujeme do 2 základných kategórií a to: nákladné a osobné.

Nákladné vlaky prepravujú náklad rôznych kategórií ako napr. kvapaliny, sutinu a balený tovar. Podľa druhu nákladu je potrebné určiť správny typ nákladného vagónu (cisterna, otvorený vagón alebo kontainerový vagón...).

Každý náklad musí mať uvedené unikátne ID a názov. Vďaka perfektnej dohode medzi stanicou a odosielateľmi, každý prepravovaný náklad je presne o veľkosti/váhe, ktorá sa zmestí do práve jedného vagóna. Náklad musí mať priradeného aj odosielateľa, ktorý má vlastné ID odosielateľa a meno.

Osobné vlaky prepravujú našich vážených pasažierov. Samozrejme, aj do súprav osobných vlakov radíme viacero typov osobných vagónov. Pre pasažierov požadujúcich maximálne pohodlie poskytujeme vozne 1. triedy, pre bežných smrtelníkov sú v ponuke vozne 2. triedy . Každá súprava osobného vlaku musí mať pripojený aj jedálenský vagón. Súpravy, ktoré majú odjazd po 21:00 majú pripojený aj lôžkový vagón.

Evidujeme aj osoby, ktoré majú meno, priezvisko, ID a rolu.

Podľa roly evidujeme u osôb: Pasažier: ID jazdy, trieda a číslo miesta. Steward: zamestnávateľ, každý steward môže byť priradený ku konkrétnemu osobnému vagónu, jeden steward obsluhuje práve v jednom vagóne. Strojvodca: zamestnávateľ, je priradený ku vlaku, ktorý riadi. Výpravca: číslo koľaje a plat.

Každý vagón má svoje ID číslo a typ.

Ku vagónu evidujeme jeho jazdy, ktoré majú vlastné unikátne ID.

Žiaden osobný vlak nesmie mať pripojený nákladný vagón, takisto žiaden nákladný vlak nesmie mať pripojený osobný vagón.

Každá koľaj má svoje číslo a priradeného výpravcu.

![image](https://github.com/MatejS89/BI-DBS/assets/111086657/a15dd91a-fef8-456b-917d-7ef7a13c6117)
