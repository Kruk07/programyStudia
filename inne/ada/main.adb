with ada.text_io;   -- Tell compiler to use i/o library
use  ada.text_io;   -- Use library routines w/o fully qualified names
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
use Ada.Strings.UNbounded.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with GNAT.OS_Lib;
with ada.numerics.Float_Random;
use ada.numerics.Float_Random;

procedure main is



   type kol_prze is array (Positive range <>) of Integer;
   type trasa_p is array (Positive range <>) of Integer;
   type sasiednie_w is array (Positive range <>) of Integer;



   type Tor_przejazdowy is
      record
         od_id : Integer;
         do_id : Integer;
         dlugosc : Integer;
         max_predkosc : Integer;
         id_toru_przejazdowego : Integer;
         czy_zajety : Boolean;
         czy_uszkodzony : Boolean;
         czy_wyslano_do_naprawy: Boolean;
         czy_zarezerwowany: Boolean;
      end record;

   type Tor_postojowy is
      record
         od_id : Integer;
         do_id : Integer;
         minimalny_czas_postoju : Integer;
         nazwa_stacji : Unbounded_String;
         id_toru_postojowego : Integer;
         czy_zajety : Boolean;
         czy_uszkodzony : Boolean;
         czy_wyslano_do_naprawy: Boolean;
         czy_zarezerwowany: Boolean;
      end record;

   type Zwrotnica is
      record
         opoznienie : Integer;
         id_zwrotnicy: Integer;
         czy_zajety : Boolean;
         czy_uszkodzony : Boolean;
         czy_wyslano_do_naprawy: Boolean;
         czy_zarezerwowany: Boolean;
      end record;

   --type Pociag (array_size : Integer) is
   type Pociag is
      record
         nazwa_pociagu : Unbounded_String;
         --kolejnosc_przejazdu : kol_prze (1 .. array_size);
         kolejnosc_przejazdu : kol_prze (1 .. 20);
         predkosc_maksymalna : Integer;
         pojemnosc: Integer;
         aktualne_id: Integer;
         typ_id: Integer;
         czy_uszkodzony : Boolean;
         czy_wyslano_do_naprawy: Boolean;
      end record;


   type PojazdNaprawczy is
      record
         od_id : Integer;
         do_id : Integer;
         id_pojazdu_naprawczego : Integer;
         czas_naprawy : Integer ;
         trasa : trasa_p (1 .. 20);
      end record;

   type Wierzcholek is
      record
         id_wierzcholka : Integer;
         sasiednie_wierzcholki :sasiednie_w (1 .. 20);
         dlugosc_sasiednie_wierzcholki: Integer;
         czy_odwiedzony: boolean;
         lista_przejsc :trasa_p (1 .. 20);
         wielkosc_listy: Integer ;
         pozycja_poprzednika: Integer;
         ostatni_iterator: integer;
      end record;


   type return_znajdz_sasiadow is
      record
         listaSasiadow:sasiednie_w(1..20);
         dlugosc: Integer;
      end record;

      type return_znajdz_sciezke is
      record
         sciezka:trasa_p ( 1 .. 20 );
         dlugosc: Integer;
      end record;





   type tor_prze_array is array (Positive range <>) of Tor_przejazdowy;
   type tor_post_array is array (Positive range <>) of Tor_postojowy;
   type zwrotnice_array is array (Positive range <>) of Zwrotnica;
   type pociagi_array is array (Positive range <>) of Pociag;
   type pojazdy_naprawcze_array is array (Positive range <>) of PojazdNaprawczy;


   Tablica_torow_przejazdowych :tor_prze_array(1 .. 100);
   Tablica_torow_postojowych :tor_post_array(1 .. 100);
   Tablica_zwrotnic :zwrotnice_array(1 .. 100);
   Tablica_pociagow :pociagi_array(1 .. 20);
   Tablica_pojazdow_naprawczych : pojazdy_naprawcze_array (1 .. 20);

   godziny :Integer;
   minuty : Integer;
   czestotliwosc : Integer;
   czas : Unbounded_String;

   liczba_torow_przejazdowych: Integer;
   liczba_torow_postojowych: Integer;
   liczba_pociagow: Integer;
   liczba_pojazdow_naprawczych: Integer;
   liczba_zwrotnic : Integer;
   tryb: Unbounded_String;

   File : File_Type;
   line: Unbounded_String;



   procedure Simulation (Up_To: Natural ;godzinyw: Natural ; minutyw: Natural ; czestotliwoscw : Natural) is

      protected type Mutex is
         entry Seize;
         procedure Release;
      private
         Owned : Boolean := False;
      end Mutex;

      protected body Mutex is
         entry Seize when not Owned is
         begin
            Owned := True;
         end Seize;
         procedure Release is
         begin
            Owned := False;
         end Release;
      end Mutex;




      function znajdz_id_toru(od: Natural; do_id2: Natural;czy_uwzgledniac_ze_zajety: boolean) return Integer is
         czy_znaleziono: Boolean := false;
      begin
         for i in 1 .. liczba_torow_przejazdowych loop
            if (Tablica_torow_przejazdowych(i).od_id = od and then Tablica_torow_przejazdowych(i).do_id = do_id2)then
               if (Tablica_torow_przejazdowych(i).czy_zajety = false) then
                 -- Put_Line("ID: ");
                 -- Put(Integer'Image(i));
                 -- Put("Znaleziono! Id: ");
                --  Put_Line(Integer'Image(Tablica_torow_przejazdowych(i).id_toru_przejazdowego));
                  return Tablica_torow_przejazdowych(i).id_toru_przejazdowego;
               else
                  if (czy_uwzgledniac_ze_zajety =false)then
                     return Tablica_torow_przejazdowych(i).id_toru_przejazdowego;
                  end if;

                  czy_znaleziono := true;
               end if;
            end if;

         end loop;

         for i in 1 .. liczba_torow_postojowych loop
            if (Tablica_torow_postojowych(i).od_id = od and then Tablica_torow_postojowych(i).do_id = do_id2) or else (Tablica_torow_postojowych(i).od_id = do_id2 and then Tablica_torow_postojowych(i).do_id = od) then
               if (Tablica_torow_postojowych(i).czy_zajety = false) then
                --  Put("Znaleziono postojowy! Id: ");
                --  Put_Line(Integer'Image(Tablica_torow_postojowych(i).id_toru_postojowego));

               --   Put_Line(Integer'Image(Tablica_torow_postojowych(i).od_id));
                --  Put_Line(Integer'Image(Tablica_torow_postojowych(i).do_id));
                --  Put_Line(Tablica_torow_postojowych(i).nazwa_stacji);

                  return Tablica_torow_postojowych(i).id_toru_postojowego;
               else
                  if (czy_uwzgledniac_ze_zajety = false) then
                     return Tablica_torow_postojowych(i).id_toru_postojowego;
                  end if;
                  czy_znaleziono := true;
               end if;
            end if;

         end loop;

         if (czy_znaleziono = false) then
            return -1;
         else
            return 0;
         end if;

      end znajdz_id_toru;

      type result_ch is array (Positive range <>) of Integer;


      function check return result_ch is
         result : result_ch (1 .. 2);
      begin
         result(1) := -1;
         result(2) := -1;

         for i in 1 .. liczba_pociagow loop
            if (Tablica_pociagow(i).czy_uszkodzony = True and then Tablica_pociagow(i).czy_wyslano_do_naprawy = False) then
               Tablica_pociagow(i).czy_wyslano_do_naprawy := true;
               result(1):=4;
               result(2):=i;
               return result;
            end if ;

         end loop;

         for i in 1 .. liczba_torow_postojowych loop
            if (Tablica_torow_postojowych(i).czy_uszkodzony = True and then Tablica_torow_postojowych(i).czy_wyslano_do_naprawy = False) then
               Tablica_torow_postojowych(i).czy_wyslano_do_naprawy := true;
               result(1):=1;
               result(2):=i;
               return result;
            end if ;

         end loop;

         for i in 1 .. liczba_torow_przejazdowych loop
            if (Tablica_torow_przejazdowych(i).czy_uszkodzony = True and then Tablica_torow_przejazdowych(i).czy_wyslano_do_naprawy = False) then
               Tablica_torow_przejazdowych(i).czy_wyslano_do_naprawy := true;
               result(1):=2;
               result(2):=i;
               return result;
            end if ;

         end loop;

         for i in 1 .. liczba_zwrotnic loop
            if (Tablica_zwrotnic(i).czy_uszkodzony = True and then Tablica_zwrotnic(i).czy_wyslano_do_naprawy = False) then
               Tablica_zwrotnic(i).czy_wyslano_do_naprawy := true;
               result(1):=3;
               result(2):=i;
               return result;
            end if ;

         end loop;

	return result;

      end check;

      function findPositionbyId (position: Integer) return Integer is

      begin
         for i in 1 .. liczba_zwrotnic loop
            if (Tablica_zwrotnic(i).id_zwrotnicy = position) then
               return i;
            end if;

         end loop;
         return -1 ;
      end findPositionbyId;

      function znajdzSasiadow (num: Integer) return return_znajdz_sasiadow is
         ret_lista_Sasiadow: return_znajdz_sasiadow;
         listaSasiadow: sasiednie_w (1 .. 20);
         listaSasiadowtemp: sasiednie_w (1 .. 40);
         Iterator : Integer;
         Iterator2: Integer;
         Powtorzenie: Boolean;
      begin
         Iterator :=1;
         for i in 1 .. listaSasiadowtemp'Length loop
            listaSasiadowtemp(i):=-999;
         end loop;
         for i in 1 .. liczba_torow_postojowych loop

            if (Tablica_torow_postojowych(i).od_id=num) then
               listaSasiadowtemp(Iterator):=Tablica_torow_postojowych(i).do_id;
               Iterator:= Iterator+1;
            end if;
            if (Tablica_torow_postojowych(i).do_id=num) then

               listaSasiadowtemp(Iterator):=Tablica_torow_postojowych(i).od_id;
               Iterator:= Iterator+1;
            end if;

         end loop;

         for i in 1 .. liczba_torow_przejazdowych loop
               --Put("ANALIZUJE:");
               --Put_Line(Integer'Image(Tablica_torow_przejazdowych(i).od_id));
            if (Tablica_torow_przejazdowych(i).od_id=num) then
               --Put("        ZNALEZIONO:");
               --Put_Line(Integer'Image(Tablica_torow_przejazdowych(i).do_id));
               listaSasiadowtemp(Iterator):=Tablica_torow_przejazdowych(i).do_id;
               Iterator:= Iterator+1;
            end if;

         end loop;

         Iterator2:=1;
         for i in 1 .. listaSasiadow'Length loop
            listaSasiadow(i):=-999;
         end loop;


         for i in 1 .. Iterator loop

            Powtorzenie:=false;

            for j in 1 .. Iterator2 loop


               if (listaSasiadow(j)=listaSasiadowtemp(i)) then
                  Powtorzenie:=true;
               end if;

            end loop;
            if (Powtorzenie = false)then
               listaSasiadow(Iterator2):=listaSasiadowtemp(i);
               Iterator2:= Iterator2+1;
            end if;

         end loop;

         ret_lista_Sasiadow.listaSasiadow:=listaSasiadow;
         ret_lista_Sasiadow.dlugosc:=Iterator2-1;
         --Put_Line("WYSWIETLAM!");
        -- for j in 1 .. Iterator2-1 loop
        --    Put(Integer'Image(listaSasiadow(j)));
       --  end loop;
       --  Put_Line("KONIEC WYSWIETLANIA!");
         return ret_lista_Sasiadow;
      end znajdzSasiadow;




      function znajdzSciezke (typ2: result_ch;odkogo : Integer; czy_powrotna : Boolean) return return_znajdz_sciezke is
         returnznajdzsciezke : return_znajdz_sciezke;
         typ:result_ch( 1.. 2);
         result : trasa_p(1 .. 20);
         punktpoczatkowy : Integer;
         punktkoncowy: Integer;
         type wierzcholki_array is array (Positive range <>) of Wierzcholek;
         Tablica_wierzcholkow : wierzcholki_array(1 .. Tablica_zwrotnic'Length);
         polozenie: Integer;

         returned_znajdz_sasiadow: return_znajdz_sasiadow;

         aktualnyId: Integer;
         k: Integer;
         j: Integer;
         sasiad: Integer;
         possasiada: Integer;
         idToru: Integer;

         iterator : Integer;
      begin
         typ:=typ2;
         if (czy_powrotna = false) then
            punktpoczatkowy := Tablica_pojazdow_naprawczych(odkogo).od_id;
            if (typ(1)=1)then
               punktkoncowy := Tablica_torow_postojowych(typ(2)).od_id;
            end if;
            --zepsul sie tor przejazdowy
            if (typ(1)=2)then
               punktkoncowy := Tablica_torow_przejazdowych(typ(2)).od_id;
            end if;

            --zepsula sie zwrotnica
            if (typ(1) =3)then
               punktkoncowy := Tablica_zwrotnic(typ(2)).id_zwrotnicy;
            end if;
            --zepsul sie pociag
            if (typ(1) =4) then
               typ(1) :=Tablica_pociagow(typ(2)).typ_id;
               punktkoncowy := Tablica_pociagow(typ(2)).aktualne_id;
            end if;

         else
            punktkoncowy := Tablica_pojazdow_naprawczych(odkogo).od_id;
            if (typ(1)=1)then
               punktpoczatkowy := Tablica_torow_postojowych(typ(2)).od_id;
            end if;

            --zepsul sie tor przejazdowy
            if (typ(1)=2)then
               punktpoczatkowy := Tablica_torow_przejazdowych(typ(2)).od_id;
            end if;

            --zepsula sie zwrotnica
            if (typ(1) =3)then
               punktpoczatkowy := Tablica_zwrotnic(typ(2)).id_zwrotnicy;
            end if;

            --zepsul sie pociag
            if (typ(1) =4)then
               typ(1):=Tablica_pociagow(typ(2)).typ_id;
               punktpoczatkowy := Tablica_pociagow(typ(2)).aktualne_id;
            end if;

         end if;

         for i in 1 .. liczba_zwrotnic loop
            Tablica_wierzcholkow(i).id_wierzcholka:=Tablica_zwrotnic(i).id_zwrotnicy;
            for j in 1 .. Tablica_wierzcholkow(i).lista_przejsc'Length loop
               Tablica_wierzcholkow(i).lista_przejsc(j):=-1;
            end loop;

            Tablica_wierzcholkow(i).czy_odwiedzony:=false;
            returned_znajdz_sasiadow:=znajdzSasiadow(i);
            Tablica_wierzcholkow(i).sasiednie_wierzcholki:=returned_znajdz_sasiadow.listaSasiadow;
            Tablica_wierzcholkow(i).dlugosc_sasiednie_wierzcholki:=returned_znajdz_sasiadow.dlugosc;
           -- Put("WYSWIETLAM! ");
           -- Put_Line(Integer'Image(i));
           -- for j in 1 .. Tablica_wierzcholkow(i).dlugosc_sasiednie_wierzcholki loop
           --    Put(Integer'Image(Tablica_wierzcholkow(i).sasiednie_wierzcholki(j)));
           -- end loop;
           --   Put_Line("");

           -- Put_Line("KONIEC WYSWIETLANIA!");
            Tablica_wierzcholkow(i).wielkosc_listy:= 0;

            if (Tablica_wierzcholkow(i).id_wierzcholka=punktpoczatkowy)then
               Tablica_wierzcholkow(i).czy_odwiedzony:=true;
               Tablica_wierzcholkow(i).wielkosc_listy:=0;
               polozenie := i;
            end if;

         end loop;

         aktualnyId := punktpoczatkowy;

         k := Tablica_wierzcholkow(polozenie).dlugosc_sasiednie_wierzcholki;
         iterator := 1;
         if (aktualnyId=punktkoncowy) then
            result(iterator) := aktualnyId;
            returnznajdzsciezke.sciezka:=result;
            returnznajdzsciezke.dlugosc:=1;
            return returnznajdzsciezke;
         end if;

         j:=1;
         --Put("Poszukuje sciezki od :");
         --Put(Integer'Image(punktpoczatkowy));
         --Put(" do:");
         --Put(Integer'Image(punktkoncowy));
         --Put_Line("");
         loop

            if (j=k+1)then
               result := Tablica_wierzcholkow(polozenie).lista_przejsc;
               returnznajdzsciezke.dlugosc:=Tablica_wierzcholkow(polozenie).wielkosc_listy;
               exit;
            end if;

            if (aktualnyId = punktkoncowy) then

               result := Tablica_wierzcholkow(polozenie).lista_przejsc;
               returnznajdzsciezke.dlugosc:=Tablica_wierzcholkow(polozenie).wielkosc_listy;
               exit;
            end if;
            --Put_Line("POZYCJE ODWIEDZONE: ");
            --for z in 1..liczba_zwrotnic loop
            --   if (Tablica_wierzcholkow(z).czy_odwiedzony=true)then
            --      Put(Integer'Image(z));
             --  end if;

           -- end loop;
           -- Put_Line("KONIEC POZYCJE ODWIEDZONE");
            --Put_Line("AKTUALNE ID: ");
            --Put_Line(Integer'Image(Tablica_wierzcholkow(polozenie).id_wierzcholka));
            sasiad := Tablica_wierzcholkow(polozenie).sasiednie_wierzcholki(j);
            --Put_Line("  SASIAD: ");
            --Put_Line(Integer'Image(sasiad));
            idToru := znajdz_id_toru(aktualnyId,sasiad,false);

            if (idToru/=0) then
               possasiada:= findPositionbyId(sasiad);
               --Put_Line(Integer'Image(possasiada));
               if (Tablica_wierzcholkow(possasiada).czy_odwiedzony=false)then

                  Tablica_wierzcholkow(polozenie).ostatni_iterator:=j;
                  Tablica_wierzcholkow(possasiada).pozycja_poprzednika:=polozenie;
                  Tablica_wierzcholkow(possasiada).wielkosc_listy:=Tablica_wierzcholkow(polozenie).wielkosc_listy+1;
                  Tablica_wierzcholkow(possasiada).lista_przejsc:=Tablica_wierzcholkow(polozenie).lista_przejsc;
                  Tablica_wierzcholkow(possasiada).lista_przejsc(Tablica_wierzcholkow(possasiada).wielkosc_listy):=sasiad;
                  Tablica_wierzcholkow(possasiada).czy_odwiedzony:=true;
                  polozenie:=possasiada;
                  aktualnyId :=Tablica_wierzcholkow(polozenie).id_wierzcholka;
                  j := 0;
                  k := Tablica_wierzcholkow(polozenie).dlugosc_sasiednie_wierzcholki;


               end if;
            end if ;

            if (j = k) then
                --                 Put_Line("Powrot! ");
               polozenie := Tablica_wierzcholkow(polozenie).pozycja_poprzednika;
               j := 0;
               k := Tablica_wierzcholkow(polozenie).dlugosc_sasiednie_wierzcholki;
               aktualnyId := Tablica_wierzcholkow(polozenie).id_wierzcholka;
            end if;
                 -- Put("j: ");
          --  Put(Integer'Image(j));
             --                 Put(" k: ");
             --     Put_Line(Integer'Image(k));
            j:=j+1;
         end loop;

         returnznajdzsciezke.sciezka:=result;
         return returnznajdzsciezke;
      end znajdzSciezke;









      task type Naprawa (num : Natural);

      task body Naprawa is
         czy_cos_do_naprawy : Boolean;

         result_check : result_ch (1..2);
         sciezka: trasa_p ( 1 .. 20 );
         id : Integer;
         idToru : Integer;
         return_sciezka: return_znajdz_sciezke;

         czas_naprawy : Integer;

         types : Integer;
         aktualne_id : Integer;
         kolejnosc : Integer;
         dzielnik : Float;
         numer_zwrotnicy: Integer;
         czas_zatrzymania: Integer;
         nastepna_zwrotnica: Integer;
         next : Integer;
         id_toru: Integer;
                  M: Mutex;
      begin
         czy_cos_do_naprawy := false ;
         while true loop
            if (czy_cos_do_naprawy = false)then
               result_check:=check;
               if (result_check(1)/=-1) then
                  czy_cos_do_naprawy:= true;
                  if (tryb="G") then
                     Put("Znaleziono cos do naprawy Wyslano:");
                     Put(Integer'Image(Tablica_pojazdow_naprawczych(num).id_pojazdu_naprawczego));
                     Put(" typ:");
                     Put(Integer'Image(result_check(1)));
                     Put(" id:");
                     Put(Integer'Image(result_check(2)));
                  end if;

               end if;
            end if;
            if (czy_cos_do_naprawy = True) then

               return_sciezka := znajdzSciezke(result_check,num,false);
               sciezka := return_sciezka.sciezka;

               --Put_Line("Obliczona sciezka!!");
               --for i in 1 .. return_sciezka.dlugosc loop
               --   Put(Integer'Image(return_sciezka.sciezka(i)));
               --end loop;
               --Put_Line("koniec Obliczona sciezka!!");
               Tablica_pojazdow_naprawczych(num).trasa:=sciezka;


               --proba rezerwacji
               M.Seize;
               for i in 1 .. return_sciezka.dlugosc loop
                  --Put_Line(Integer'Image(i));
                  id := findPositionbyId(Tablica_pojazdow_naprawczych(num).trasa(i));
                  Tablica_zwrotnic(id).czy_zarezerwowany:=true;
                  if (i>1)then
                     idToru:= znajdz_id_toru(Tablica_pojazdow_naprawczych(num).trasa(i-1) , Tablica_pojazdow_naprawczych(num).trasa(i),false);
                     if (idToru/=-1) then
                        if (idToru<=liczba_torow_postojowych)then
                           Tablica_torow_postojowych(idToru).czy_zarezerwowany:=true;
                        elsif (idToru<=liczba_torow_postojowych+liczba_torow_przejazdowych)then
                           Tablica_torow_przejazdowych(idToru-liczba_torow_postojowych).czy_zarezerwowany:=true;
                        else
                           if (tryb = "G") then
                              Put_Line(" ERROR!!!!! PojazdNaprawczy nie zarezerwowal toru " );
                           end if;

                        end if;

                     else
                        if (tryb = "G") then
                           Put_Line(" ERROR!!!!! PojazdNaprawczy nie znalazl toru ");
                        end if;
                     end if;
                  end if;
               end loop;
               M.Release;

               --dojazd do uszkodzonego miejsca
               kolejnosc := 1 ;
               next := 2 ;
               types  := 3;
               czas_naprawy := Tablica_pojazdow_naprawczych(num).czas_naprawy;
               nastepna_zwrotnica := Tablica_pojazdow_naprawczych(num).trasa(kolejnosc+1);
               aktualne_id:= Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);

               numer_zwrotnicy:= Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);



               while true loop
                  if (return_sciezka.dlugosc = 1)then

                     if (tryb = "G") then
                        Put(czas);
                        Put(" PojazdNaprawczy " );
                        Put(" wjezdza na zwrotnice ");
                        Put_Line(Integer'Image(numer_zwrotnicy));
                     end if;
                     exit;
                  end if;

                  --Put(Integer'Image(Candidate));
                  if (types = 1)then
                     if (Tablica_torow_postojowych(aktualne_id).czy_uszkodzony = true) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy" );
                           Put(" naprawia stacje: ");
                           Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                        end if;

                        delay (1.0/60.0) * czestotliwosc * czas_naprawy;
                     Tablica_torow_postojowych(aktualne_id).czy_uszkodzony:=false;
                     elsif (Tablica_torow_postojowych(aktualne_id).czy_zajety = false) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" dojechal na stacje ");
                           Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                        end if;
                        M.Seize;
                        Tablica_torow_postojowych(aktualne_id).czy_zarezerwowany:= false;
                        Tablica_torow_postojowych(aktualne_id).czy_zajety:= true;
                        delay (1.0/60.0) * czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                        Tablica_torow_postojowych(aktualne_id).czy_zajety := false;
                        M.Release;
                        types := 3;
                        --Put(Integer'Image(Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc)));
                        --Put(" ");
                        --Put(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                        --Put(" ");
                        --Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                        if (Tablica_pojazdow_naprawczych(num).trasa(kolejnosc) = Tablica_torow_postojowych(aktualne_id).od_id)then
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" wyjezdza do zwrotnicy: ");
                              Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                           end if;
                           aktualne_id := Tablica_torow_postojowych(aktualne_id).od_id;

                        else
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" wyjezdza1 do zwrotnicy: ");
                              Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                           end if;
                           aktualne_id := Tablica_torow_postojowych(aktualne_id).do_id ;

                        end if;

                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wjazd na stacje.");
                        end if;
                        delay (1.0/60.0)* czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                     end if;

                  end if;

                  if (types = 2) then
                     if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_uszkodzony =True) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" naprawia tor przejazdowy");
                        end if;
                        delay (1.0/60.0)* czestotliwosc * czas_naprawy ;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_uszkodzony :=false;

                     elsif (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety =false) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" jest na torze przejazdowym ");
                        end if;
                        M.Seize;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety := true;
                        if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc<60)then
                           dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc));
                        else
                           dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(20));
                        end if;
                        delay (1.0/60.0) * Duration(dzielnik) * czestotliwosc *Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety:=false;
                        M.Release;
                        types:=3;
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" przejechal tor przejazdowy. wjazd na zwrotnice: ");
                           Put_Line(Integer'Image(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id));
                        end if;

                        aktualne_id:=Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id;
                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wjazd na tor przejazdowy...");
                        end if;
                        delay (1.0/60.0) * czestotliwosc* Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                     end if;
                  end if;

                  if (types = 3)then
                     numer_zwrotnicy := Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);
                     if (Tablica_zwrotnic(numer_zwrotnicy).czy_uszkodzony = true)then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" naprawia uszkodzona zwrotnice: ");
                           Put_Line(Integer'Image(numer_zwrotnicy));
                        end if;
                        delay (1.0/60.0)*czestotliwosc*czas_naprawy;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_uszkodzony:=false;

                     elsif (Tablica_zwrotnic(numer_zwrotnicy).czy_zajety = false)then
                        M.Seize;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=true;

                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" wjezdza na zwrotnice ");
                           Put_Line(Integer'Image(numer_zwrotnicy));
                        end if;

                        czas_zatrzymania := Tablica_zwrotnic(numer_zwrotnicy).opoznienie;
                        delay (1.0/60.0)*czestotliwosc*czas_zatrzymania;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=false;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zarezerwowany:=false;
                        M.Release;
                        --num := (kolejnosc+1)mod (Tablica_pociagow(Candidate).kolejnosc_przejazdu'Length+1);
                        -- Put("WYGENEROWANY NUM TO!!!!");
                        --Put_Line(Integer'Image(next));
                        nastepna_zwrotnica := Tablica_pojazdow_naprawczych(num).trasa(next);
                        -- Put("JESTEM TUTAJ!!!! ");
                        -- Put(Integer'Image(numer_zwrotnicy));
                        --  Put(" ");
                        --  Put_Line(Integer'Image(nastepna_zwrotnica));
                        if (nastepna_zwrotnica=-1)then

                           exit;
                        end if;


                        id_toru := znajdz_id_toru(numer_zwrotnicy,nastepna_zwrotnica,true);

                        if (id_toru = -1) then

                           if (tryb = "G") then
                              Put(czas);
                              Put(" ERROR!!!!!!!!!!!!!! PojazdNaprawczy " );

                              Put(Integer'Image(numer_zwrotnicy));
                              Put(" ");
                              Put(Integer'Image(nastepna_zwrotnica));
                              Put(" ");
                              Put(Integer'Image(kolejnosc));
                              Put(" ");
                              Put(Integer'Image(next));
                              Put_Line(" ");
                              exit;
                           end if;

                        elsif (id_toru = 0) then
                           if (tryb = "G") then
                              Put(czas);
                              Put_Line(" PojazdNaprawczy: Wszystkie tory sa aktualnie zajete " );
                           end if;

                        else
                           if (id_toru<=liczba_torow_postojowych)then
                              types:=1;
                           elsif (id_toru <=liczba_torow_postojowych+liczba_torow_przejazdowych)then
                              types := 2;
                           else
                              if (tryb = "G") then
                                 Put(czas);
                                 Put(" ERROR!!!!!! PojazdNaprawczy " );
                                 Put(" ");
                                 Put(Integer'Image(numer_zwrotnicy));
                                 Put(" ");
                                 Put(Integer'Image(nastepna_zwrotnica));
                                 Put(" ");
                                 Put(Integer'Image(kolejnosc));
                                 Put(" ");
                                 Put(Integer'Image(next));
                                 Put_Line(" ");
                                 Put("  " );
                                 Put_Line(Integer'Image(id_toru));
                              end if;
                           end if;
                           aktualne_id := id_toru;
                           kolejnosc := kolejnosc +1 ;
                           next := next +1;
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" zjezdza z zwrotnicy ");
                              Put_Line(Integer'Image(numer_zwrotnicy));
                           end if;

                        end if;


                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wolna zwrotnice");
                        end if;
                        delay 1.0;

                     end if;




                  end if;
                  delay 0.5;
                  if (nastepna_zwrotnica=-1) then
                     exit;
                  end if;


               end loop;





               --naprawa

               if (tryb = "G") then
                  Put_Line("Pojazd Naprawczy rozpoczyna naprawe....");
               end if;
               delay (1.0/60.0) * czestotliwosc * czas_naprawy;

               if (result_check(1)=1)then
                  Tablica_torow_postojowych(result_check(2)).czy_uszkodzony:=false;
                  Tablica_torow_postojowych(result_check(2)).czy_wyslano_do_naprawy:=false;
                  if (tryb = "G") then
                     Put("PojazdNaprawczy naprawil tor postojowy: ");
                     Put_Line(Integer'Image(result_check(2)));
                  end if;

               end if;
               if (result_check(1)=2)then
                  Tablica_torow_przejazdowych(result_check(2)).czy_uszkodzony:=false;
                  Tablica_torow_przejazdowych(result_check(2)).czy_wyslano_do_naprawy:=false;
                  if (tryb = "G") then
                     Put("PojazdNaprawczy naprawil tor przejazdowy: ");
                     Put_Line(Integer'Image(result_check(2)));


                  end if;

               end if;
               if (result_check(1)=3)then
                  Tablica_zwrotnic(result_check(2)).czy_uszkodzony:=false;
                  Tablica_zwrotnic(result_check(2)).czy_wyslano_do_naprawy:=false;
                  if (tryb = "G") then
                     Put("PojazdNaprawczy naprawil zwrotnice: ");
                     Put_Line(Integer'Image(result_check(2)));
                  end if;

               end if;
               if (result_check(1)=4)then
                  Tablica_pociagow(result_check(2)).czy_uszkodzony:=false;
                  Tablica_pociagow(result_check(2)).czy_wyslano_do_naprawy:=false;
                  if (tryb = "G") then
                     Put("PojazdNaprawczy naprawil pociag: ");
                     Put_Line(Integer'Image(result_check(2)));
                  end if;

               end if;
               for i in 1 .. Tablica_pojazdow_naprawczych(num).trasa'Length loop
                  Tablica_pojazdow_naprawczych(num).trasa(i):= -1;
               end loop;


               --powrot do domu


               return_sciezka := znajdzSciezke(result_check,num,true);
               sciezka := return_sciezka.sciezka;

              -- Put_Line("Obliczona sciezka Powrotna!!");
               --for i in 1 .. return_sciezka.dlugosc loop
               --   Put(Integer'Image(return_sciezka.sciezka(i)));
              -- end loop;
              -- Put_Line("koniec Obliczona sciezka Powrotna!!");
               Tablica_pojazdow_naprawczych(num).trasa:=sciezka;


               M.Seize;
               for i in 1 .. return_sciezka.dlugosc loop
                  --Put_Line(Integer'Image(i));
                  id := findPositionbyId(Tablica_pojazdow_naprawczych(num).trasa(i));
                  Tablica_zwrotnic(id).czy_zarezerwowany:=true;
                  if (i>1)then
                     idToru:= znajdz_id_toru(Tablica_pojazdow_naprawczych(num).trasa(i-1) , Tablica_pojazdow_naprawczych(num).trasa(i),false);
                     if (idToru/=-1) then
                        if (idToru<=liczba_torow_postojowych)then
                           Tablica_torow_postojowych(idToru).czy_zarezerwowany:=true;
                        elsif (idToru<=liczba_torow_postojowych+liczba_torow_przejazdowych)then
                           Tablica_torow_przejazdowych(idToru-liczba_torow_postojowych).czy_zarezerwowany:=true;
                        else
                           if (tryb = "G") then
                              Put_Line(" ERROR!!!!! PojazdNaprawczy nie zarezerwowal toru " );
                           end if;

                        end if;

                     else
                        if (tryb = "G") then
                           Put_Line(" ERROR!!!!! PojazdNaprawczy nie znalazl toru ");
                        end if;
                     end if;
                  end if;
               end loop;
               M.Release;

               --dojazd do domu
               kolejnosc := 1 ;
               next := 2 ;
               types  := 3;
               czas_naprawy := Tablica_pojazdow_naprawczych(num).czas_naprawy;
               nastepna_zwrotnica := Tablica_pojazdow_naprawczych(num).trasa(kolejnosc+1);
               aktualne_id:= Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);

               numer_zwrotnicy:= Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);



               while true loop
                  if (return_sciezka.dlugosc = 1)then

                     if (tryb = "G") then
                        Put(czas);
                        Put(" PojazdNaprawczy " );
                        Put(" wjezdza na zwrotnice ");
                        Put_Line(Integer'Image(numer_zwrotnicy));
                     end if;
                     exit;
                  end if;

                  --Put(Integer'Image(Candidate));
                  if (types = 1)then
                     if (Tablica_torow_postojowych(aktualne_id).czy_uszkodzony = true) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy" );
                           Put(" naprawia stacje: ");
                           Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                        end if;

                        delay (1.0/60.0) * czestotliwosc * czas_naprawy;
                     Tablica_torow_postojowych(aktualne_id).czy_uszkodzony:=false;
                     elsif (Tablica_torow_postojowych(aktualne_id).czy_zajety = false) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" dojechal na stacje ");
                           Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                        end if;
                        M.Seize;
                        Tablica_torow_postojowych(aktualne_id).czy_zarezerwowany:= false;
                        Tablica_torow_postojowych(aktualne_id).czy_zajety:= true;
                        delay (1.0/60.0) * czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                        Tablica_torow_postojowych(aktualne_id).czy_zajety := false;
                        M.Release;
                        types := 3;
                        --Put(Integer'Image(Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc)));
                        --Put(" ");
                        --Put(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                        --Put(" ");
                        --Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                        if (Tablica_pojazdow_naprawczych(num).trasa(kolejnosc) = Tablica_torow_postojowych(aktualne_id).od_id)then
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" wyjezdza do zwrotnicy: ");
                              Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                           end if;
                           aktualne_id := Tablica_torow_postojowych(aktualne_id).od_id;

                        else
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" wyjezdza1 do zwrotnicy: ");
                              Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                           end if;
                           aktualne_id := Tablica_torow_postojowych(aktualne_id).do_id ;

                        end if;

                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wjazd na stacje.");
                        end if;
                        delay (1.0/60.0)* czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                     end if;

                  end if;

                  if (types = 2) then
                     if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_uszkodzony =True) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" naprawia tor przejazdowy");
                        end if;
                        delay (1.0/60.0)* czestotliwosc *czas_naprawy ;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_uszkodzony :=false;

                     elsif (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety =false) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" jest na torze przejazdowym ");
                        end if;
                        M.Seize;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety := true;
                        if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc<60)then
                           dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc));
                        else
                           dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(20));
                        end if;
                        delay (1.0/60.0) * Duration(dzielnik) * czestotliwosc *Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                        Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety:=false;
                        M.Release;
                        types:=3;
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" przejechal tor przejazdowy. wjazd na zwrotnice: ");
                           Put_Line(Integer'Image(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id));
                        end if;

                        aktualne_id:=Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id;
                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wjazd na tor przejazdowy...");
                        end if;
                        delay (1.0/60.0) * czestotliwosc* Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                     end if;
                  end if;

                  if (types = 3)then
                     numer_zwrotnicy := Tablica_pojazdow_naprawczych(num).trasa(kolejnosc);
                     if (Tablica_zwrotnic(numer_zwrotnicy).czy_uszkodzony = true)then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" naprawia uszkodzona zwrotnice: ");
                           Put_Line(Integer'Image(numer_zwrotnicy));
                        end if;
                        delay (1.0/60.0)*czestotliwosc*czas_naprawy;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_uszkodzony:=false;

                     elsif (Tablica_zwrotnic(numer_zwrotnicy).czy_zajety = false)then
                        M.Seize;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=true;

                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put(" wjezdza na zwrotnice ");
                           Put_Line(Integer'Image(numer_zwrotnicy));
                        end if;

                        czas_zatrzymania := Tablica_zwrotnic(numer_zwrotnicy).opoznienie;
                        delay (1.0/60.0)*czestotliwosc*czas_zatrzymania;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=false;
                        Tablica_zwrotnic(numer_zwrotnicy).czy_zarezerwowany:=false;
                        M.Release;
                        --num := (kolejnosc+1)mod (Tablica_pociagow(Candidate).kolejnosc_przejazdu'Length+1);
                        -- Put("WYGENEROWANY NUM TO!!!!");
                        --Put_Line(Integer'Image(next));
                        nastepna_zwrotnica := Tablica_pojazdow_naprawczych(num).trasa(next);
                        -- Put("JESTEM TUTAJ!!!! ");
                        -- Put(Integer'Image(numer_zwrotnicy));
                        --  Put(" ");
                        --  Put_Line(Integer'Image(nastepna_zwrotnica));
                        if (nastepna_zwrotnica=-1)then

                           exit;
                        end if;


                        id_toru := znajdz_id_toru(numer_zwrotnicy,nastepna_zwrotnica,False);

                        if (id_toru = -1) then

                           if (tryb = "G") then
                              Put(czas);
                              Put(" ERROR!!!!!!!!!!!!!! PojazdNaprawczy " );

                              Put(Integer'Image(numer_zwrotnicy));
                              Put(" ");
                              Put(Integer'Image(nastepna_zwrotnica));
                              Put(" ");
                              Put(Integer'Image(kolejnosc));
                              Put(" ");
                              Put(Integer'Image(next));
                              Put_Line(" ");
                              exit;
                           end if;

                        elsif (id_toru = 0) then
                           if (tryb = "G") then
                              Put(czas);
                              Put("  " );
                              Put_Line(" : Wszystkie tory sa aktualnie zajete " );
                           end if;

                        else
                           if (id_toru<=liczba_torow_postojowych)then
                              types:=1;
                           elsif (id_toru <=liczba_torow_postojowych+liczba_torow_przejazdowych)then
                              types := 2;
                           else
                              if (tryb = "G") then
                                 Put(czas);
                                 Put(" ERROR!!!!!! PojazdNaprawczy " );
                                 Put(" ");
                                 Put(Integer'Image(numer_zwrotnicy));
                                 Put(" ");
                                 Put(Integer'Image(nastepna_zwrotnica));
                                 Put(" ");
                                 Put(Integer'Image(kolejnosc));
                                 Put(" ");
                                 Put(Integer'Image(next));
                                 Put_Line(" ");
                                 Put("  " );
                                 Put_Line(Integer'Image(id_toru));
                              end if;
                           end if;
                           aktualne_id := id_toru;
                           kolejnosc := kolejnosc +1 ;
                           next := next +1;
                           if (tryb = "G") then
                              Put(czas);
                              Put(" PojazdNaprawczy " );
                              Put(" zjezdza z zwrotnicy ");
                              Put_Line(Integer'Image(numer_zwrotnicy));
                           end if;

                        end if;


                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" PojazdNaprawczy " );
                           Put_Line(" czeka na wolna zwrotnice");
                        end if;
                        delay 1.0;

                     end if;




                  end if;
                  delay 0.5;
                  if (nastepna_zwrotnica=-1) then
                     exit;
                  end if;


               end loop;
               if (tryb = "G") then
                  Put(czas);
                  Put(" PojazdNaprawczy " );
                  Put_Line(" powrocil do domu");
               end if;






               czy_cos_do_naprawy:=false;
               result_check(1):=-1;
               result_check(2):=-1;
            end if;





         end loop;
      end Naprawa;


      task type Zwrotnica (num : Natural );

      task body Zwrotnica is
         g : Generator;
         myfloat : Float;
         M : Mutex;
      begin
         while (true) loop
            M.Seize;
            reset(g);
            myfloat := random(g);
            if (myfloat>0.95) then
               Tablica_zwrotnic(num).czy_uszkodzony:=True;
            end if;

            M.Release;
            delay (1.0/60.0) * czestotliwosc * 60;
         end loop;

      end Zwrotnica;

      Task type Tory (num : Natural);

      task body Tory is
         g : Generator;
         myfloat : Float ;
         M: Mutex;
      begin
         while (true) loop
            M.Seize;
            reset(g);
            myfloat := random(g);
            if (myfloat>0.95) then
               if (num<liczba_torow_postojowych) then
                  Tablica_torow_postojowych(num).czy_uszkodzony := true ;
               else
                  Tablica_torow_przejazdowych(num-liczba_torow_postojowych).czy_uszkodzony := true ;
               end if;

            end if;
            M.Release;

            delay (1.0/60.0) * czestotliwosc * 60;
         end loop;

      end Tory;


      task type Time(godzinyw: Natural ; minutyw: Natural ; czestotliwoscw : Natural);

      task body Time is
         godziny : Integer :=godzinyw;
         minuty : Integer := minutyw;
         czestotliwosc : Integer :=czestotliwoscw;
      begin
         czas:=To_Unbounded_String (Integer'Image(godziny))&":"&To_Unbounded_String (Integer'Image(minuty));
         while(true) loop
            delay (1.0/60.0)*czestotliwosc;
            minuty := minuty +1 ;
            if (minuty = 60) then
               minuty:=0;
               godziny := godziny + 1;
            end if;
            if (godziny = 24) then
               godziny := 0;
            end if;
              czas:=To_Unbounded_String (Integer'Image(godziny))&":"&To_Unbounded_String (Integer'Image(minuty));
         end loop;

      end Time;

      task type Menu ;

      task body Menu is
         Str  : String (1 .. 1);
         Last : Natural;
         Rodzaj : Natural;
         akt_id : Natural;
      begin
         while(true)loop
            Put_Line("Oto Twoje dostepne opcje:");
            Put_Line("1. Pokaz, w ktorym miejscu aktualnie znajdujo sie pociagi");
            Put_Line("2. Pokaz rozklad jazdy kazdego pociagu");
            Put_Line("3. Pokaz aktualna godzine (w symulacji)");
            Put_Line("4. Zakoncz dzialanie symulacji");
            Get_Line (Str, Last);
            if (Str = "1")then
               for I in 1..liczba_pociagow loop
                  Put(Tablica_pociagow(I).nazwa_pociagu);
                  Put(" ");
                  Rodzaj := Tablica_pociagow(I).typ_id;
                  akt_id := Tablica_pociagow(I).aktualne_id;
                  if (Rodzaj = 1) then
                     Put("jest na torze postojowym ");
                     Put(Integer'Image(akt_id));
                     Put(" stacja: ");
                     Put_Line(Tablica_torow_postojowych(akt_id).nazwa_stacji);
                  end if;
                  if (Rodzaj =2) then
                     Put("jest na torze przejazdowym ");
                     Put_Line(Integer'Image(akt_id));
                  end if;
                  if (Rodzaj = 3) then
                     Put("jest na zwrotnicy ");
                     Put_Line(Integer'Image(akt_id));
                  end if;

               end loop;

            end if;
            if (Str = "2")then
               null;
               for I in 1..liczba_pociagow loop
                  Put_Line(Tablica_pociagow(I).nazwa_pociagu);
                  for J in Tablica_pociagow(I).kolejnosc_przejazdu'Range loop
                     if (Tablica_pociagow(I).kolejnosc_przejazdu(J) = 0)then
                        exit;
                     end if;

                     Put(" ");
                     Put(Integer'Image(Tablica_pociagow(I).kolejnosc_przejazdu(J)));


                  end loop;
                  Put_Line(" ");
               end loop;

            end if;
            if (Str = "3")then
               Put_Line(czas);
            end if;
            if (Str = "4")then
                     GNAT.OS_Lib.OS_Exit (0);
            end if;

         end loop;

      end Menu;



      task type Checker(Candidate: Natural);

      task body Checker is
         kolejnosc : Integer := 1 ;
         next : Integer := 2 ;
         types : Integer := 3;
         nastepna_zwrotnica : Integer := Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc+1);
         aktualne_id : Integer := Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc);

         numer_zwrotnicy: Integer := Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc);
         czas_zatrzymania: Integer ;
         id_toru : Integer ;

         dzielnik : Float ;

         g : Generator;
         myfloat : Float ;
         M: Mutex;
      begin
         Tablica_pociagow(Candidate).aktualne_id := aktualne_id;
         Tablica_pociagow(Candidate).typ_id := types;
         Put(Integer'Image(Candidate));
         Put_Line(": Uruchomiono pociag" );
         Put(Integer'Image(Candidate));
         Put(": Nazwa pociagu : " );
         Put_Line(Tablica_pociagow(Candidate).nazwa_pociagu );

         while true loop
            reset(g);
            myfloat := random(g);
            if (myfloat>0.95) then
               Tablica_pociagow(Candidate).czy_uszkodzony:=True;
            end if;

            if (Tablica_pociagow(Candidate).czy_uszkodzony=true) then
               if (tryb = "G") then
                  Put(czas);
                  Put(" Pociag " );
                  Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                  Put_Line(" uszkodzony ");
               end if;
               delay (1.0/60.0) * czestotliwosc * 60;
            else

               --Put(Integer'Image(Candidate));
               if (types = 1)then
                  if (Tablica_torow_postojowych(aktualne_id).czy_uszkodzony = true) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" czeka, stacja uszkodzona: ");
                        Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                     end if;

                     delay (1.0/60.0) * czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;

                  elsif(Tablica_torow_postojowych(aktualne_id).czy_zarezerwowany = true) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" czeka, stacja zarezerwowana: ");
                        Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                     end if;

                     delay (1.0/60.0) * czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;

                  elsif (Tablica_torow_postojowych(aktualne_id).czy_zajety = false) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" dojechal na stacje ");
                        Put_Line(Tablica_torow_postojowych(aktualne_id).nazwa_stacji);
                     end if;
                     M.Seize;
                     Tablica_torow_postojowych(aktualne_id).czy_zajety:= true;
                     Tablica_pociagow(Candidate).aktualne_id :=aktualne_id;
                     Tablica_pociagow(Candidate).typ_id := types;
                     delay (1.0/60.0) * czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                     Tablica_torow_postojowych(aktualne_id).czy_zajety := false;
                     M.Release;
                     types := 3;
                     --Put(Integer'Image(Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc)));
                     --Put(" ");
                     --Put(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                     --Put(" ");
                     --Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                     if (Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc) = Tablica_torow_postojowych(aktualne_id).od_id)then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" Pociag " );
                           Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                           Put(" wyjezdza do zwrotnicy: ");
                           Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).od_id));
                        end if;
                        aktualne_id := Tablica_torow_postojowych(aktualne_id).od_id;
                        Tablica_pociagow(Candidate).aktualne_id :=aktualne_id;
                        Tablica_pociagow(Candidate).typ_id := types;
                     else
                        if (tryb = "G") then
                           Put(czas);
                           Put(" Pociag " );
                           Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                           Put(" wyjezdza1 do zwrotnicy: ");
                           Put_Line(Integer'Image(Tablica_torow_postojowych(aktualne_id).do_id));
                        end if;
                        aktualne_id := Tablica_torow_postojowych(aktualne_id).do_id ;
                        Tablica_pociagow(Candidate).aktualne_id :=aktualne_id;
                        Tablica_pociagow(Candidate).typ_id := types;
                     end if;

                  else
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" czeka na wjazd na stacje: ");
                     end if;
                     delay (1.0/60.0)* czestotliwosc * Tablica_torow_postojowych(aktualne_id).minimalny_czas_postoju;
                  end if;

               end if;

               if (types = 2) then
                  if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_uszkodzony =True) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put_Line(" nie moze wjechac na tor przejazdowy-tor uszkodzony ");
                     end if;
                     delay (1.0/60.0)* czestotliwosc * 60;
                  elsif (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zarezerwowany =True) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put_Line(" nie moze wjechac na tor przejazdowy-tor zarezerwowany ");
                     end if;
                     delay (1.0/60.0)* czestotliwosc * 60;


                  elsif (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety =false) then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put_Line(" jest na torze przejazdowym ");
                     end if;
                     M.Seize;
                     Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety := true;
                     Tablica_pociagow(Candidate).aktualne_id:=aktualne_id;
                     Tablica_pociagow(Candidate).typ_id:=types;
                     if (Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc<Tablica_pociagow(Candidate).predkosc_maksymalna)then
                        dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).max_predkosc));
                     else
                        dzielnik := Float(Float(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc)/Float(Tablica_pociagow(Candidate).predkosc_maksymalna));
                     end if;
                     delay (1.0/60.0) * Duration(dzielnik) * czestotliwosc *Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                     Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).czy_zajety:=false;
                     M.Release;
                     types:=3;
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" przejechal tor przejazdowy. wjazd na zwrotnice: ");
                        Put_Line(Integer'Image(Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id));
                     end if;

                     aktualne_id:=Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).do_id;
                     Tablica_pociagow(Candidate).aktualne_id :=aktualne_id;
                     Tablica_pociagow(Candidate).typ_id := types;
                  else
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" czeka na wjazd na tor przejazdowy...");
                     end if;
                     delay (1.0/60.0) * czestotliwosc* Tablica_torow_przejazdowych(aktualne_id-liczba_torow_postojowych).dlugosc;
                  end if;
               end if;

               if (types = 3)then
                  numer_zwrotnicy := Tablica_pociagow(Candidate).aktualne_id;
                  if (Tablica_zwrotnic(numer_zwrotnicy).czy_uszkodzony = true)then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" nie moze wjechac na zwrotnice. Uszkodzona: ");
                        Put_Line(Integer'Image(numer_zwrotnicy));
                     end if;
                     delay (1.0/60.0)*czestotliwosc*20;

                  elsif (Tablica_zwrotnic(numer_zwrotnicy).czy_zarezerwowany = true)then
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" nie moze wjechac na zwrotnice. Zarezerwowana: ");
                        Put_Line(Integer'Image(numer_zwrotnicy));
                     end if;
                     delay (1.0/60.0)*czestotliwosc*20;
                  elsif (Tablica_zwrotnic(numer_zwrotnicy).czy_zajety = false)then
                     M.Seize;
                     Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=true;
                     Tablica_pociagow(Candidate).aktualne_id:=aktualne_id;
                     Tablica_pociagow(Candidate).typ_id:=types;

                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put(" wjezdza na zwrotnice ");
                        Put_Line(Integer'Image(numer_zwrotnicy));
                     end if;

                     czas_zatrzymania := Tablica_zwrotnic(numer_zwrotnicy).opoznienie;
                     delay (1.0/60.0)*czestotliwosc*czas_zatrzymania;
                     Tablica_zwrotnic(numer_zwrotnicy).czy_zajety:=false;
                     M.Release;
                     --num := (kolejnosc+1)mod (Tablica_pociagow(Candidate).kolejnosc_przejazdu'Length+1);
                     -- Put("WYGENEROWANY NUM TO!!!!");
                     --Put_Line(Integer'Image(next));
                     nastepna_zwrotnica := Tablica_pociagow(Candidate).kolejnosc_przejazdu(next);
                     -- Put("JESTEM TUTAJ!!!! ");
                     -- Put(Integer'Image(numer_zwrotnicy));
                     --  Put(" ");
                     --  Put_Line(Integer'Image(nastepna_zwrotnica));

                     id_toru := znajdz_id_toru(numer_zwrotnicy,nastepna_zwrotnica,true);

                     if (id_toru = -1) then
                        if (tryb = "G") then
                           Put(czas);
                           Put(" ERROR!!!!!!!!!!!!!! Pociag " );
                           Put_Line(Tablica_pociagow(Candidate).nazwa_pociagu);
                           Put(Integer'Image(numer_zwrotnicy));
                           Put(" ");
                           Put(Integer'Image(nastepna_zwrotnica));
                           Put(" ");
                           Put(Integer'Image(kolejnosc));
                           Put(" ");
                           Put(Integer'Image(next));
                           Put_Line(" ");
                           exit;
                        end if;

                     elsif (id_toru = 0) then
                        if (tryb = "G") then
                           Put(czas);
                           Put("  " );
                           Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                           Put_Line(" : Wszystkie tory sa aktualnie zajete " );
                        end if;

                     else
                        if (id_toru<=liczba_torow_postojowych)then
                           types:=1;
                        elsif (id_toru <=liczba_torow_postojowych+liczba_torow_przejazdowych)then
                           types := 2;
                        else
                           if (tryb = "G") then
                              Put(czas);
                              Put(" ERROR!!!!!! Pociag " );
                              Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                              Put(" ");
                              Put(Integer'Image(numer_zwrotnicy));
                              Put(" ");
                              Put(Integer'Image(nastepna_zwrotnica));
                              Put(" ");
                              Put(Integer'Image(kolejnosc));
                              Put(" ");
                              Put(Integer'Image(next));
                              Put_Line(" ");
                              Put("  " );
                              Put_Line(Integer'Image(id_toru));
                           end if;
                        end if;
                        aktualne_id := id_toru;
                        kolejnosc := kolejnosc +1 ;
                        next := next +1;
                        if (tryb = "G") then
                           Put(czas);
                           Put(" Pociag " );
                           Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                           Put(" zjezdza z zwrotnicy ");
                           Put_Line(Integer'Image(numer_zwrotnicy));
                        end if;

                     end if;


                  else
                     if (tryb = "G") then
                        Put(czas);
                        Put(" Pociag " );
                        Put(Tablica_pociagow(Candidate).nazwa_pociagu);
                        Put_Line(" czeka na wolna zwrotnice");
                     end if;
                     delay 1.0;

                  end if;




               end if;
               delay 0.5;
               if (kolejnosc = Tablica_pociagow(Candidate).kolejnosc_przejazdu'Length+1 or else Tablica_pociagow(Candidate).kolejnosc_przejazdu(kolejnosc)=0) then
                  kolejnosc := 1 ;
               end if;
               if (next = Tablica_pociagow(Candidate).kolejnosc_przejazdu'Length+1 or else Tablica_pociagow(Candidate).kolejnosc_przejazdu(next)=0 ) then
                  next := 1 ;
               end if;

            end if ;
         end loop;
      end Checker;




      -- When tasks are allocated at runtime, Ada requires that a task
      -- type be declared.  Also, one cannot throw away the result of
      -- an allocation with the 'new' operator, so a useless variable
      -- must also be declared.


   begin
      declare
         type Checker_Pointer is access Checker;
         C: Checker_Pointer;
         type Time_Pointer is access Time;
         T: Time_Pointer;
         type Menu_Pointer is access Menu;
         M : Menu_Pointer;
         type Zwrotnica_Pointer is access Zwrotnica;
         Z : Zwrotnica_Pointer;
         type Tory_Pointer is access Tory;
         TO : Tory_Pointer;
         type Naprawa_Pointer is access Naprawa;
         N: Naprawa_Pointer;
      begin
         T := new Time(godzinyw,minutyw,czestotliwoscw);
         for I in reverse 1..Up_To loop
            C := new Checker(I);
         end loop;
         if (tryb = "S") then
            M := new Menu;
         end if;
         for I in 1.. liczba_zwrotnic loop
            Z := new Zwrotnica(I);
         end loop;
         for I in 1.. liczba_torow_postojowych+liczba_torow_przejazdowych loop
            TO := new Tory(I);
         end loop;
         for I in 1 .. liczba_pojazdow_naprawczych loop
            N := new Naprawa(I);
         end loop;

      end;
   end Simulation;



   licznik_wystapien: Integer:=1;
   temp: Unbounded_String :=To_Unbounded_String("");
   cpy: Unbounded_String :=To_Unbounded_String("");
   iterator: Integer :=1;
   iterator2: Integer:=2;
begin




   Open (File => File,
         Mode => In_File,
         Name => "data2.txt");
   loop
      exit when End_Of_File (File);
      Get_Line (File,line);
      if (line = "Tory_postojowe") then
         Put_Line(line);
         Get_Line (File,line);
         liczba_torow_postojowych := Integer'Value(To_String (line));
         Put_Line(line);
         for i in 1 .. liczba_torow_postojowych loop
            Get_Line (File,line);
            for j in 1 .. Length(line) loop
               if(Slice(line,j,j) = " ")then
                  licznik_wystapien:= licznik_wystapien+1;
                  temp:=To_Unbounded_String("");

               else
                  Append(Source   => temp,
                         New_Item => Slice(line,j,j));
                  if(licznik_wystapien=1)then
                     Put_Line("1:"&temp);
                     Tablica_torow_postojowych(i).od_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=2)then
                     Put_Line("2:"&temp);
                     Tablica_torow_postojowych(i).do_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=3)then
                     Put_Line("3:"&temp);
                     Tablica_torow_postojowych(i).minimalny_czas_postoju := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=4)then
                     Put_Line("4:"&temp);
                     Tablica_torow_postojowych(i).nazwa_stacji := temp;
                  end if;
                  if(licznik_wystapien=5)then
                     Put_Line("5:"&temp);
                     Tablica_torow_postojowych(i).id_toru_postojowego := Integer'Value(To_String (temp));
                  end if;
               end if;



            end loop;
            Tablica_torow_postojowych(i).czy_zajety := false;
            Tablica_torow_postojowych(i).czy_uszkodzony := false;
            Tablica_torow_postojowych(i).czy_zarezerwowany := false;
            licznik_wystapien:=1;
            temp:=To_Unbounded_String("");
            Put_Line(line);
         end loop;
      end if;
      if (line = "Pojazdy_remontowe") then
         Put_Line(line);
         Get_Line (File,line);
         liczba_pojazdow_naprawczych := Integer'Value(To_String (line));
                     Put_Line("liczba");
                     Put_Line(line);
         for i in 1 .. liczba_pojazdow_naprawczych loop
            Get_Line (File,line);

            Put_Line(line);
            for j in 1 .. Length(line) loop
               if(Slice(line,j,j) = " ")then
                  licznik_wystapien:= licznik_wystapien+1;
                  temp:=To_Unbounded_String("");

               else
                  Append(Source   => temp,
                         New_Item => Slice(line,j,j));
                  if(licznik_wystapien=1)then
                     Put_Line("1:"&temp);
                     Tablica_pojazdow_naprawczych(i).od_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=2)then
                     Put_Line("2:"&temp);
                     Tablica_pojazdow_naprawczych(i).do_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=3)then
                     Put_Line("3:"&temp);
                     Tablica_pojazdow_naprawczych(i).id_pojazdu_naprawczego := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=4)then
                     Put_Line("4:"&temp);
                     Tablica_pojazdow_naprawczych(i).czas_naprawy := Integer'Value(To_String (temp));
                  end if;

               end if;


            end loop;
            licznik_wystapien:=1;
            temp:=To_Unbounded_String("");
         end loop;

      end if;


      if (line = "Tory_przejazdowe") then
         Put_Line(line);
         Get_Line (File,line);
         liczba_torow_przejazdowych := Integer'Value(To_String (line));
         --Put_Line(line);
         for i in 1 .. liczba_torow_przejazdowych loop
            Get_Line (File,line);
            Put_Line(line);
            for j in 1 .. Length(line) loop
               if(Slice(line,j,j) = " ")then
                                                      --Put_Line(Integer'Image(j));
                  licznik_wystapien:= licznik_wystapien+1;
                  temp:=To_Unbounded_String("");

               else
                  Append(Source   => temp,
                         New_Item => Slice(line,j,j));
                  if(licznik_wystapien=1)then
                     Put_Line("1:"&temp);
                     Tablica_torow_przejazdowych(i).od_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=2)then
                     Put_Line("2:"&temp);
                     Tablica_torow_przejazdowych(i).do_id := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=3)then
                     Put_Line("3:"&temp);
                     Tablica_torow_przejazdowych(i).dlugosc := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=4)then
                     Put_Line("4:"&temp);
                     Tablica_torow_przejazdowych(i).max_predkosc := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=5)then
                     Put_Line("5:"&temp);
                     Tablica_torow_przejazdowych(i).id_toru_przejazdowego := Integer'Value(To_String (temp));
                  end if;
               end if;



            end loop;
            Tablica_torow_przejazdowych(i).czy_zajety := false;
            Tablica_torow_przejazdowych(i).czy_uszkodzony := false;
            Tablica_torow_przejazdowych(i).czy_zarezerwowany := false;
            licznik_wystapien:=1;
            temp:=To_Unbounded_String("");
         end loop;
      end if;
      if (line = "Zwrotnice") then
         Put_Line(line);
         Get_Line (File,line);
         Put_Line(line);
         liczba_zwrotnic := Integer'Value(To_String (line));
         for i in 1 .. liczba_zwrotnic loop
            Get_Line (File,line);

            for j in 1 .. Length(line) loop
               if(Slice(line,j,j) = " ")then
                  licznik_wystapien:= licznik_wystapien+1;
                  temp:=To_Unbounded_String("");

               else
                  Append(Source   => temp,
                         New_Item => Slice(line,j,j));
                  if(licznik_wystapien=1)then
                     Put_Line("1:"&temp);
                     Tablica_zwrotnic(i).id_zwrotnicy := Integer'Value(To_String (temp));
                  end if;
                  if(licznik_wystapien=2)then
                     Put_Line("2:"&temp);
                     Tablica_zwrotnic(i).opoznienie:= Integer'Value(To_String (temp));
                  end if;


               end if;

            end loop;
            licznik_wystapien:=1;
            temp:=To_Unbounded_String("");
            Tablica_zwrotnic(i).czy_zajety := false;
            Tablica_zwrotnic(i).czy_uszkodzony := false ;
            Tablica_zwrotnic(i).czy_zarezerwowany := false;
         end loop;
      end if;
      if (line = "Pociagi") then

         Put_Line(line);
         Get_Line (File,line);
         Put_Line(line);
         liczba_pociagow := Integer'Value(To_String (line));
         for i in 1 .. liczba_pociagow loop
            for k in 1 .. Tablica_pociagow(i).kolejnosc_przejazdu'Length loop
               Tablica_pociagow(i).kolejnosc_przejazdu(k):=0;
            end loop;
            Get_Line (File,line);
            for j in 1 .. Length(line) loop

               if (iterator2>2)then
                  iterator2:=iterator2-1;


                elsif(Slice(line,j,j) = " ")then
                     licznik_wystapien:= licznik_wystapien+1;
                     temp:=To_Unbounded_String("");

               else
                  Append(Source   => temp,
                         New_Item => Slice(line,j,j));
                  if(licznik_wystapien=1)then
                     Put_Line("1:"&temp);
                     Tablica_pociagow(i).nazwa_pociagu := temp;
                  end if;
                  if(licznik_wystapien=2)then
                     Put_Line("2:"&temp);
                     if (Slice(line,j+1,j+1) /= " ")then
                        Append(Source   => temp,
                               New_Item => Slice(line,j+1,j+1));
                        iterator2:=iterator2+1;
                     end if;

                     Put(To_Unbounded_String("("));
                     cpy := temp;
                     temp:=To_Unbounded_String("");

                     Put_Line(cpy);
                     Put_Line(Integer'Image(iterator));
                     while (iterator<Integer'Value(To_String(cpy))+1)loop
                        --Put_Line("WYKONUJE SIE");
                        if (Slice(line,j+iterator2,j+iterator2) = " ") then
                           Tablica_pociagow(i).kolejnosc_przejazdu(iterator) := Integer'Value(To_String (temp));
                           iterator := iterator +1;
                           Put(temp);
                           Put(To_Unbounded_String(""));
                           temp := To_Unbounded_String("");
                        else

                           Append(Source   => temp,
                                  New_Item => Slice(line,j+iterator2,j+iterator2));


                        end if;
                           iterator2 := iterator2+1;
                     end loop;
                     Put(To_Unbounded_String(")"));
                     Put_Line("");
                     --tu trzeba zaimplementowac kolejke trasy
                     --licznik_wystapien:=licznik_wystapien+1;
                  end if;
                  if (iterator2>2)then
                     iterator2:=iterator2-1;

                  else
                    -- Put_Line(Integer'Image(licznik_wystapien));
                     if(licznik_wystapien=3)then
                        Put_Line("3:"&temp);
                        Tablica_pociagow(i).predkosc_maksymalna:= Integer'Value(To_String (temp));
                     end if;
                     if(licznik_wystapien=4)then
                        Put_Line("4:"&temp);
                        Tablica_pociagow(i).pojemnosc:= Integer'Value(To_String (temp));
                     end if;
                  end if;
               end if;

            end loop;
            iterator :=1;
            iterator2 := 2;
            licznik_wystapien:=1;
            temp:=To_Unbounded_String("");
            Tablica_pociagow(i).czy_uszkodzony := false;
         end loop;
      end if;

   end loop;

   Close (File);

   Open (File => File,
         Mode => In_File,
         Name => "config.txt");
   loop

      exit when End_Of_File (File);
      Get_Line (File,line);
      temp := To_Unbounded_String("");
      iterator:=1;
      for i in 1 .. Length(line) loop
         Append(Source   => temp,
                New_Item => Slice(line,i,i));

         if (iterator =1)then
            if (temp = "Tryb_dzialania:")then
               iterator :=2;
               temp := To_Unbounded_String("");
               --Put_Line("Wykryto: Tryb dzialania");
            elsif (temp = "Tempo_symulacji:")then
               iterator :=3;
               temp := To_Unbounded_String("");
               --Put_Line("Wykryto: Tempo symulacji");
            elsif (temp="Poczatkowa_godzina:")then
               iterator :=4;
               temp := To_Unbounded_String("");
               --Put_Line("Wykryto: Poczatkowa godzina");
            elsif (temp="Poczatkowa_minuta:")then
               iterator :=5;
               temp := To_Unbounded_String("");
               --Put_Line("Wykryto: Poczatkowa minuta");
            end if;
         elsif (iterator>1)then
            if (temp= " ")then
               temp := To_Unbounded_String("");
            else
               if (iterator=2)then
                  tryb := temp;
               end if;

               if (iterator=3)then
                  czestotliwosc := Integer'Value(To_String (temp)) ;
               end if;
               if (iterator=4)then
                  godziny := Integer'Value(To_String (temp)) ;
               end if;
               if (iterator=5)then
                  minuty := Integer'Value(To_String (temp)) ;
               end if;
            end if;
         end if;


      end loop;



      Put_Line(line);
   end loop;

   Close(File);

   --godziny := 20 ;
   --minuty := 00 ;
   --czestotliwosc := 10 ;
   --tryb := To_Unbounded_String("G");
     czas := To_Unbounded_String(godziny);
            Append(Source   => czas,
                New_Item => ":");
            Append(Source   => czas,
                   New_Item => Integer'Image(minuty));
   --for i in 1 .. liczba_pociagow loop
 --Put_Line(Tablica_pociagow(i).nazwa_pociagu);

   -- for j in 1 .. Tablica_pociagow(i).kolejnosc_przejazdu'Length loop
   --    Put_Line(Integer'Image(Tablica_pociagow(i).kolejnosc_przejazdu(j)));
  --end loop;

 --end loop;
   --liczba_torow_postojowych := 2;
   --liczba_torow_przejazdowych := 4;

  -- Tablica_torow_przejazdowych(1) := (2,4,60,30,3,false);
  -- Tablica_torow_przejazdowych(2) := (3,1,60,120,4,false);
  -- Tablica_torow_przejazdowych(3) := (3,1,60,40,5,false);
   --Tablica_torow_przejazdowych(4) := (2,4,60,60,6,false);

   --Tablica_torow_postojowych(1) := (1,2,10,To_Unbounded_String("Miloszowo1"),1,false);
   --Tablica_torow_postojowych(2) := (4,3,10,To_Unbounded_String("Marcinowo1"),2,false);

  -- Tablica_zwrotnic(1) := (1,5,false);
  -- Tablica_zwrotnic(2) := (2,5,false);
  -- Tablica_zwrotnic(3) := (3,10,false);
  -- Tablica_zwrotnic(4) := (4,5,false);


   --Tablica_pociagow(1) := Pociag(5) ;
--   Tablica_pociagow(1) := (To_Unbounded_String("Konstancin"),(1,2,4,3),60,500,-1,-1);
 --  Tablica_pociagow(2) := (To_Unbounded_String("Slowacki"),(1,2,4,3),120,500,-1,-1);
   --;

   Simulation (Up_To => liczba_pociagow,godzinyw => godziny, minutyw => minuty,czestotliwoscw =>czestotliwosc);
exception
   when Storage_Error => Put_Line ("Bummer -- out of memory");
   when others => Put_Line ("ERROR!!!sdf!!!!");

end main;
