package main

import (
  "bufio"
  	"sync"
  "log"
  "os"
  "strconv"
  "strings"
  "time"
  "fmt"
  "math/rand"
)

type Tor_przejazdowy struct {
	mu sync.Mutex
   od_id int
   do_id int
   dlugosc int
   max_predkosc int
   id_toru_przejazdowego int
   czy_zajety bool
   czy_uszkodzony bool
   czy_zarezerwowany bool
   czy_wyslano_do_naprawy bool
}

type Tor_postojowy struct {
	mu sync.Mutex
   od_id int
   do_id int
   minimalny_czas_postoju int
   nazwa_stacji string
   id_toru_postojowego int
   czy_zajety bool
   czy_uszkodzony bool
   czy_zarezerwowany bool
   czy_wyslano_do_naprawy bool
}
type Zwrotnica struct{
	mu sync.Mutex
	opoznienie int
	id_zwrotnicy int
    czy_zajety bool
    czy_uszkodzony bool
	czy_zarezerwowany bool
	czy_wyslano_do_naprawy bool
}
type Pociag struct{
	nazwa_pociagu string
	kolejnosc_przejazdu [] int
	predkosc_maksymalna int
	pojemnosc int
	aktualne_id int
	typ_id int
	czy_uszkodzony bool
	czy_wyslano_do_naprawy bool
}
type PojazdNaprawczy struct{
	mu sync.Mutex
	od_id int
	do_id int
	id_pojazdu_naprawczego int 
	trasa [] int
	czas_naprawy int
}
type Wierzcholek struct{
	id_wierzcholka int
	sasiednie_wierzcholki [] int
	czy_odwiedzony bool
	lista_przejsc [] int
	pozycja_poprzednika int
	ostatni_iterator int
}

	var Tablica_torow_przejazdowych []Tor_przejazdowy
	var Tablica_torow_postojowych  []Tor_postojowy
	var Tablica_zwrotnic []Zwrotnica
	var Tablica_pociagow []Pociag
	var Tablica_pojazdow_naprawczych []PojazdNaprawczy
	var godziny int
	var minuty int
	var czestotliwosc int
	var czas string

	var liczba_torow_przejazdowych int
	var liczba_torow_postojowych int
	var liczba_pojazdow_naprawczych int 
	
	var tryb string
func main() {



  // open a file
  if file, err := os.Open("data2.txt"); err == nil {

    // make sure it gets closed
    defer file.Close()

    // create a new scanner and read the file line by line
    scanner := bufio.NewScanner(file)
	var flag int = 0
    for scanner.Scan() {
		var x string
		x=scanner.Text()
		if x== "Tory_postojowe"{
			//fmt.Println("Zaczynam wczytywac TORY POSTOJOWE")
			flag=1
			scanner.Scan()
			x=scanner.Text()
			i, err := strconv.Atoi(x)
			if err != nil {
				// handle error
				fmt.Println(err)
				os.Exit(2)
			}
			liczba_torow_postojowych = i
			//fmt.Println(len(Tablica_torow_postojowych))
			var iterator int =0
			for iterator<i{
				scanner.Scan()
				x=scanner.Text()
				//fmt.Println(x)
				
				temp := strings.Split(x, " ")
				Tablica_torow_postojowych = append(Tablica_torow_postojowych,Tor_postojowy{})
				Tablica_torow_postojowych[iterator].od_id, err =strconv.Atoi(temp[0])
				Tablica_torow_postojowych[iterator].do_id, err =strconv.Atoi(temp[1])
				Tablica_torow_postojowych[iterator].minimalny_czas_postoju, err =strconv.Atoi(temp[2])
				Tablica_torow_postojowych[iterator].nazwa_stacji =temp[3]
				Tablica_torow_postojowych[iterator].id_toru_postojowego, err =strconv.Atoi(temp[4])
				Tablica_torow_postojowych[iterator].czy_zajety= false
				Tablica_torow_postojowych[iterator].czy_uszkodzony= false 
				Tablica_torow_postojowych[iterator].czy_zarezerwowany= false 
				Tablica_torow_postojowych[iterator].czy_wyslano_do_naprawy= false 
				iterator++

			}
		}
		
		if x== "Pojazdy_remontowe"{
			//fmt.Println("Zaczynam wczytywac TORY POSTOJOWE")
			flag=1
			scanner.Scan()
			x=scanner.Text()
			i, err := strconv.Atoi(x)
			if err != nil {
				// handle error
				fmt.Println(err)
				os.Exit(2)
			}
			liczba_pojazdow_naprawczych = i
			//fmt.Println(len(Tablica_torow_postojowych))
			var iterator int =0
			for iterator<i{
				scanner.Scan()
				x=scanner.Text()
				//fmt.Println(x)
				
				temp := strings.Split(x, " ")
				Tablica_pojazdow_naprawczych = append(Tablica_pojazdow_naprawczych,PojazdNaprawczy{})
				Tablica_pojazdow_naprawczych[iterator].od_id, err =strconv.Atoi(temp[0])
				Tablica_pojazdow_naprawczych[iterator].do_id, err =strconv.Atoi(temp[1])
				Tablica_pojazdow_naprawczych[iterator].id_pojazdu_naprawczego, err =strconv.Atoi(temp[2])
				Tablica_pojazdow_naprawczych[iterator].czas_naprawy, err =strconv.Atoi(temp[3])				
				iterator++

			}
		}
		
		if x== "Tory_przejazdowe"{
			//fmt.Println("Zaczynam wczytywac TORY PRZEJAZDOWE")
			flag=2
			scanner.Scan()
			x=scanner.Text()
			i, err := strconv.Atoi(x)
			if err != nil {
				// handle error
				fmt.Println(err)
				os.Exit(2)
			}
			liczba_torow_przejazdowych = i
			//fmt.Println(i)
			var iterator int =0
			for iterator<i{
				scanner.Scan()
				x=scanner.Text()
				//fmt.Println(x)
				
				temp := strings.Split(x, " ")
				Tablica_torow_przejazdowych = append(Tablica_torow_przejazdowych,Tor_przejazdowy{})
				Tablica_torow_przejazdowych[iterator].od_id, err =strconv.Atoi(temp[0])
				Tablica_torow_przejazdowych[iterator].do_id, err =strconv.Atoi(temp[1])
				Tablica_torow_przejazdowych[iterator].dlugosc, err =strconv.Atoi(temp[2])
				Tablica_torow_przejazdowych[iterator].max_predkosc, err =strconv.Atoi(temp[3])
				Tablica_torow_przejazdowych[iterator].id_toru_przejazdowego, err =strconv.Atoi(temp[4])
				Tablica_torow_przejazdowych[iterator].czy_zajety= false
				Tablica_torow_przejazdowych[iterator].czy_uszkodzony= false
				Tablica_torow_przejazdowych[iterator].czy_zarezerwowany= false
				Tablica_torow_przejazdowych[iterator].czy_wyslano_do_naprawy= false
				iterator++
			}
		}
		if x=="Zwrotnice"{
			//fmt.Println("Zaczynam wczytywac ZWROTNICE")
			flag=3
			scanner.Scan()
			x=scanner.Text()
			i, err := strconv.Atoi(x)
			if err != nil {
				// handle error
				fmt.Println(err)
				os.Exit(2)
			}
			//fmt.Println(i)
			var iterator int =0
			for iterator<i{
				scanner.Scan()
				x=scanner.Text()
				//fmt.Println(x)
				
				temp := strings.Split(x, " ")
				Tablica_zwrotnic = append(Tablica_zwrotnic,Zwrotnica{})
				Tablica_zwrotnic[iterator].id_zwrotnicy, err = strconv.Atoi(temp[0])
				Tablica_zwrotnic[iterator].opoznienie, err = strconv.Atoi(temp[1])
				Tablica_zwrotnic[iterator].czy_zajety=false
				Tablica_zwrotnic[iterator].czy_uszkodzony = false
				Tablica_zwrotnic[iterator].czy_zarezerwowany = false
				Tablica_zwrotnic[iterator].czy_wyslano_do_naprawy= false
				iterator++
			}
		}
		if x== "Pociagi"{
			//fmt.Println("Zaczynam wczytywac POCIAGI")
			flag=4
			scanner.Scan()
			x=scanner.Text()

			i, err := strconv.Atoi(x)
			if err != nil {
				// handle error
				fmt.Println(err)
				os.Exit(2)
			}
				
			//fmt.Println(i)
			var iterator int =0
			for iterator<i{
				scanner.Scan()
				x=scanner.Text()
				//fmt.Println(x)
				
				temp := strings.Split(x, " ")
				Tablica_pociagow = append(Tablica_pociagow,Pociag{})
				Tablica_pociagow[iterator].nazwa_pociagu=temp[0]
				var dlugosc_trasy int
				dlugosc_trasy,err =strconv.Atoi(temp[1])
				var iterator2 int =0
				for iterator2<dlugosc_trasy{
					var temporary int 
					temporary, err = strconv.Atoi(temp[iterator2+2])
					Tablica_pociagow[iterator].kolejnosc_przejazdu = append(Tablica_pociagow[iterator].kolejnosc_przejazdu,temporary)
					iterator2++
				}
				Tablica_pociagow[iterator].predkosc_maksymalna,err=strconv.Atoi(temp[iterator2+2])
				Tablica_pociagow[iterator].pojemnosc,err=strconv.Atoi(temp[iterator2+3])
				Tablica_pociagow[iterator].aktualne_id=-1
				Tablica_pociagow[iterator].typ_id=-1
				Tablica_pociagow[iterator].czy_uszkodzony= false;
				Tablica_pociagow[iterator].czy_wyslano_do_naprawy= false
				
				iterator++
			}
		}

		//fmt.Println(x)
		//fmt.Println(flag)
		if flag== 0{
		
		}
    }

    // check for errors
    if err = scanner.Err(); err != nil {
      log.Fatal(err)
    }

  } else {
    log.Fatal(err)
  }

  var poczatekgodzina int
  var poczatekminuta int
  var czestotliwoscplik int
    // open a file
  if file, err := os.Open("config.txt"); err == nil {

    // make sure it gets closed
    defer file.Close()

    // create a new scanner and read the file line by line
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
		var x = scanner.Text()
		temp := strings.Split(x, " ")
		if temp[0]== "Tryb_dzialania:"{
			tryb=temp[1]
		}
		if temp[0]== "Tempo_symulacji:"{
			czestotliwoscplik,err=strconv.Atoi(temp[1])
		}
		if temp[0]== "Poczatkowa_godzina:"{
			poczatekgodzina,err=strconv.Atoi(temp[1])
		}
		if temp[0]== "Poczatkowa_minuta:"{
			poczatekminuta,err=strconv.Atoi(temp[1])
		}
        //fmt.Println(x)
    }

    // check for errors
    if err = scanner.Err(); err != nil {
     log.Fatal(err)
    }

  } else {
    log.Fatal(err)
  }
  
  
	if tryb == "G"{
		fmt.Println("URUCHOMIONO TRYB 'GADATLIWY'")
	}
	if tryb == "S"{
		fmt.Println("URUCHOMIONO TRYB 'SPOKOJNY'")
	}
  
  
  


    //c := make(chan bool)
	//go goZegar(c,poczatekgodzina,poczatekminuta,czestotliwoscplik)
	go goZegar(poczatekgodzina,poczatekminuta,czestotliwoscplik)
	for i := range(Tablica_pociagow){
		  if tryb == "G"{
		  fmt.Println("Tworzymy nowy pociąg o nazwie: " + Tablica_pociagow[i].nazwa_pociagu)
	  }
		   // go goPociag(c,i)
		go goPociag(i)
	}
	//go goPociag(c,0)
	for i := 1 ; i<liczba_torow_postojowych+liczba_torow_przejazdowych; i++{
		//go goTory(c,i)
		go goTory(i)
	}
	for i := range(Tablica_zwrotnic){
		//go goZwrotnica(c,i);
		go goZwrotnica(i);
	}
	for i := range(Tablica_pojazdow_naprawczych){
		 /*if tryb == "G"{
		  fmt.Println("Tworzymy nowy pociąg o nazwie: " + Tablica_pociagow[i].nazwa_pociagu)
	  }*/
		   // go goNaprawa(c,i);
		   go goNaprawa(i);
		
	}

	if tryb == "S"{
		//go goMenu(c)
		go goMenu()
	}
	for{
	
	}
		//<- c


}

//func goNaprawa (c chan bool, num int){
func goNaprawa (num int){
	var czy_cos_do_naprawy bool
	var resultcheck [2]int
	var sciezka []int
	czy_cos_do_naprawy = false;
	for {
		if czy_cos_do_naprawy==false{
			resultcheck = check();
			if (resultcheck[0]!=-1){
					czy_cos_do_naprawy= true;
					if (tryb == "G"){
						fmt.Println("Pojazd naprawczy :"+ strconv.Itoa(num) +" Znaleziono cos do naprawy! ")					
					}

			}
		}
		if czy_cos_do_naprawy==true{
				Tablica_pojazdow_naprawczych[num].mu.Lock();
				sciezka = znajdzSciezke(resultcheck,num,false)
				for j := range(sciezka){
					Tablica_pojazdow_naprawczych[num].trasa=append(Tablica_pojazdow_naprawczych[num].trasa,sciezka[j])				
				}		

			for i := range (Tablica_pojazdow_naprawczych[num].trasa){
				var id int
				id = findPositionbyId(Tablica_pojazdow_naprawczych[num].trasa[i])
				Tablica_zwrotnic[id].czy_zarezerwowany=true
				var idToru int
				if i > 0 {
					idToru = znajdzIdToru(Tablica_pojazdow_naprawczych[num].trasa[i-1],Tablica_pojazdow_naprawczych[num].trasa[i],true)
					if (idToru!=-1){
						if (idToru<=liczba_torow_postojowych){
							Tablica_torow_postojowych[idToru-1].czy_zarezerwowany=true
						}else if (idToru<= liczba_torow_postojowych+liczba_torow_przejazdowych){
							Tablica_torow_przejazdowych[idToru-liczba_torow_postojowych-1].czy_zarezerwowany=true		
						}else{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy nie zarezerwował toru " )						
							}

						}					
					
					}else{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy nie znalazl toru " )						
							}
					}

				}
			}
			/*fmt.Println("------")
			for j := range (Tablica_torow_postojowych){
				fmt.Println(Tablica_torow_postojowych[j].czy_zarezerwowany)
			}
			fmt.Println("--")
			for j := range (Tablica_torow_przejazdowych){
				fmt.Println(Tablica_torow_przejazdowych[j].czy_zarezerwowany)
			}
			fmt.Println("------")*/
			Tablica_pojazdow_naprawczych[num].mu.Unlock();
			
			var predkosc = 60;
			var czas_naprawy= Tablica_pojazdow_naprawczych[num].czas_naprawy ;
			var kolejnosc int =0
			var types int =3 //1-tor postojowy 2-tor przejazdowy 3-zwrotnica
			var nastepna_zwrotnica int
			//fmt.Println(Tablica_pojazdow_naprawczych[num].trasa)
			if len(Tablica_pojazdow_naprawczych[num].trasa)>1{
				nastepna_zwrotnica = Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc+1)]
			}else{
				nastepna_zwrotnica = Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc)]
			}	
			//fmt.Println(nastepna_zwrotnica)
			var aktualne_id= Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]
			for true{
				if len(Tablica_pojazdow_naprawczych[num].trasa) == 1{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy:"+ strconv.Itoa(num) +" dojechal na zwrotnice: " + strconv.Itoa(Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]))				
						}				
					break ;
				}
				if types == 1 {
					if Tablica_torow_postojowych[aktualne_id-1].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy: "+ strconv.Itoa(num) +" naprawia "+ Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)* time.Duration(czas_naprawy) );
							Tablica_torow_postojowych[aktualne_id-1].czy_uszkodzony = false
							continue;
					}

					if Tablica_torow_postojowych[aktualne_id-1].czy_zajety== false{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy:"+ strconv.Itoa(num) +" dojechal na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}
						Tablica_torow_postojowych[aktualne_id-1].mu.Lock();
						Tablica_torow_postojowych[aktualne_id-1].czy_zajety=true
						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
						Tablica_torow_postojowych[aktualne_id-1].mu.Unlock();
						Tablica_torow_postojowych[aktualne_id-1].czy_zarezerwowany=false;
						Tablica_torow_postojowych[aktualne_id-1].czy_zajety=false
						types=3
						if Tablica_pojazdow_naprawczych[num].trasa[kolejnosc] == Tablica_torow_postojowych[aktualne_id-1].od_id{
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +"  wyjezdża do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].od_id))					
							}
							aktualne_id=Tablica_torow_postojowych[aktualne_id-1].od_id
						}else{
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +" wyjezdża do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].do_id))
							}
							
							aktualne_id=Tablica_torow_postojowych[aktualne_id-1].do_id
						}
					} else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +"  czeka na wjazd na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}

						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
					}
				}
				if types == 2 {
					if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " PojazdNaprawczy"+ strconv.Itoa(num) +" naprawia tor: " + strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].id_toru_przejazdowego))				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*time.Duration(czas_naprawy) );
							Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_uszkodzony = false
							continue;
					}
					if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety == false{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy"+ strconv.Itoa(num) +" jest na torze przejazdowym ")			
						}
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Lock();
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety=true
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Unlock();
						var dzielenie float64
						if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc<predkosc{
							dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc) *1000
										//fmt.Println(dzielenie)
						}else{
							dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(predkosc) *1000
										//fmt.Println(dzielenie)			
						}
						time.Sleep((time.Millisecond / 60)* time.Duration(dzielenie)  * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));

						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety= false
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zarezerwowany = false 
						types=3
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +" przejechał tor przejazdowy. wjazd na zwrotnice: ", strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id))				
						}

						aktualne_id=Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id
					}else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +" czeka na wjazd na tor przejazdowy...")
						}
						
						time.Sleep((time.Millisecond / 60)* 1000 * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));
					}
				}
				if types == 3 {
					var numer_zwrotnicy int = Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]
					if Tablica_zwrotnic[numer_zwrotnicy-1].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " PojazdNaprawczy:"+ strconv.Itoa(num) +" naprawia zwrotnice: " + strconv.Itoa(Tablica_zwrotnic[numer_zwrotnicy-1].id_zwrotnicy))				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)* time.Duration(czas_naprawy) );
							Tablica_zwrotnic[numer_zwrotnicy-1].czy_uszkodzony = false ;
							continue;
					}

					if Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety == false{
						Tablica_zwrotnic[numer_zwrotnicy-1].mu.Lock();
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety=true
						Tablica_zwrotnic[numer_zwrotnicy-1].mu.Unlock();
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +" wjeżdza na zwrotnice: "+ strconv.Itoa(numer_zwrotnicy))				
						}

						var czas_zatrzymania int =Tablica_zwrotnic[numer_zwrotnicy-1].opoznienie
						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(czas_zatrzymania));
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety= false
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zarezerwowany = false ;
						nastepna_zwrotnica= Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc+1)%len(Tablica_pojazdow_naprawczych[num].trasa)]
						//fmt.Println(strconv.Itoa(numer_zwrotnicy)+ " "+ strconv.Itoa(nastepna_zwrotnica))
						var id_toru int = znajdzIdToru(numer_zwrotnicy,nastepna_zwrotnica,false)
						if id_toru ==-1{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!!!!!!!!!!! PojazdNaprawczy:"+ strconv.Itoa(num))					
							}
							break;
						}else if id_toru == 0{
							if tryb == "G"{
								fmt.Println(czas + " Pojazd naprawczy:"+ strconv.Itoa(num) +" Wszystkie tory sa aktualnie zajete")					
							}

						}else{
							if (id_toru<=liczba_torow_postojowych){
								types=1
							}else if (id_toru<= liczba_torow_postojowych+liczba_torow_przejazdowych){
								types=2			
							}else{
								if tryb == "G"{
									fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy:"+ strconv.Itoa(num))						
								}

							}
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy: "+ strconv.Itoa(num) +" zjeżdża z zwrotnicy :"+strconv.Itoa(numer_zwrotnicy))					
							}
							aktualne_id=id_toru
							kolejnosc++;



						}

					}else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy:"+ strconv.Itoa(num) +" czeka na wolna zwrotnice")				
						}

						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) );
					}
				}

				if kolejnosc==len(Tablica_pojazdow_naprawczych[num].trasa)-1{
					break;
				}
			}
			if (tryb == "G"){
				fmt.Println("PojazdNaprawczy: "+ strconv.Itoa(num) +" dojechal do" + strconv.Itoa(Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]))			
			}

			// zaimplementowac naprawe
			//Tablica_pojazdow_naprawczych[num].trasa= Tablica_pojazdow_naprawczych[num].trasa[:len(Tablica_pojazdow_naprawczych[num].trasa)-1];
			Tablica_pojazdow_naprawczych[num].trasa= Tablica_pojazdow_naprawczych[num].trasa[:0];
			//fmt.Println(Tablica_pojazdow_naprawczych[num].trasa)	
			
			//naprawa
			if tryb == "G"{
					fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" rozpoczyna naprawę... " )				
			}	
			time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*time.Duration(czas_naprawy) );
			if resultcheck[0]==1{
				Tablica_torow_postojowych[resultcheck[1]].czy_uszkodzony=false;
				Tablica_torow_postojowych[resultcheck[1]].czy_wyslano_do_naprawy=false;
				if tryb == "G"{
					fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" naprawil tor postojowy " )				
				}	
			}
			if resultcheck[0]==2{
				Tablica_torow_przejazdowych[resultcheck[1]].czy_uszkodzony=false;
				Tablica_torow_przejazdowych[resultcheck[1]].czy_wyslano_do_naprawy=false;
				if tryb == "G"{
					fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) + " naprawil tor przejazdowy " )				
				}	
			}
			if resultcheck[0]==3{
				Tablica_zwrotnic[resultcheck[1]].czy_uszkodzony=false;
				Tablica_zwrotnic[resultcheck[1]].czy_wyslano_do_naprawy=false;
				if tryb == "G"{
					fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" naprawil zwrotnice " )				
				}
			}
			if resultcheck[0]==4{
				Tablica_pociagow[resultcheck[1]].czy_uszkodzony=false;
				Tablica_pociagow[resultcheck[1]].czy_wyslano_do_naprawy=false;
				if tryb == "G"{
					fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" naprawil pociag " )				
				}
			}			
			
			//trasapowrotna
			Tablica_pojazdow_naprawczych[num].mu.Lock();
			sciezka = znajdzSciezke(resultcheck,num,true)
			//fmt.Println("----POWROT-----" )	
			//fmt.Println(sciezka )	
			//fmt.Println("----KONIECPOWROTU-----" )				
			for j := range(sciezka){
				Tablica_pojazdow_naprawczych[num].trasa=append(Tablica_pojazdow_naprawczych[num].trasa,sciezka[j])				
			}		

			for i := range (Tablica_pojazdow_naprawczych[num].trasa){
				var id int
				id = findPositionbyId(Tablica_pojazdow_naprawczych[num].trasa[i])
				Tablica_zwrotnic[id].czy_zarezerwowany=true
				var idToru int
				if i > 0 {
					idToru = znajdzIdToru(Tablica_pojazdow_naprawczych[num].trasa[i-1],Tablica_pojazdow_naprawczych[num].trasa[i],true)
					if (idToru!=-1){
						if (idToru<=liczba_torow_postojowych){
							Tablica_torow_postojowych[idToru-1].czy_zarezerwowany=true
						}else if (idToru<= liczba_torow_postojowych+liczba_torow_przejazdowych){
							Tablica_torow_przejazdowych[idToru-liczba_torow_postojowych-1].czy_zarezerwowany=true		
						}else{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy: "+ strconv.Itoa(num) +" nie zarezerwował toru " )						
							}

						}					
					
					}else{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy "+ strconv.Itoa(num) +" nie znalazl toru " )						
							}
					}

				}
			}
			Tablica_pojazdow_naprawczych[num].mu.Unlock();
			kolejnosc  =0
			types  =3 //1-tor postojowy 2-tor przejazdowy 3-zwrotnica
			//fmt.Println(Tablica_pojazdow_naprawczych[num].trasa)
			if len(Tablica_pojazdow_naprawczych[num].trasa)>1{
				nastepna_zwrotnica = Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc+1)]
			}else{
				nastepna_zwrotnica = Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc)]
			}	
			//fmt.Println(nastepna_zwrotnica)
			aktualne_id= Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]
			for true{
				if len(Tablica_pojazdow_naprawczych[num].trasa) == 1{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy "+ strconv.Itoa(num) +" dojechal na zwrotnice: " + strconv.Itoa(Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]))				
						}
					Tablica_zwrotnic[Tablica_pojazdow_naprawczych[num].trasa[0]-1].czy_zarezerwowany = false ;
					break ;
				}
				if types == 1 {
					if Tablica_torow_postojowych[aktualne_id-1].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy "+ strconv.Itoa(num) +" naprawia "+ Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)* time.Duration(czas_naprawy) );
							Tablica_torow_postojowych[aktualne_id-1].czy_uszkodzony = false
							continue;
					}

					if Tablica_torow_postojowych[aktualne_id-1].czy_zajety== false{
						if tryb == "G"{
							fmt.Println(czas+  " Pojazd naprawczy "+ strconv.Itoa(num) +" dojechal na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}
						Tablica_torow_postojowych[aktualne_id-1].mu.Lock();
						Tablica_torow_postojowych[aktualne_id-1].czy_zajety=true
												Tablica_torow_postojowych[aktualne_id-1].mu.Unlock();
						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
						Tablica_torow_postojowych[aktualne_id-1].czy_zarezerwowany=false;
						Tablica_torow_postojowych[aktualne_id-1].czy_zajety=false
						types=3
						if Tablica_pojazdow_naprawczych[num].trasa[kolejnosc] == Tablica_torow_postojowych[aktualne_id-1].od_id{
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" wyjezdża do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].od_id))					
							}
							aktualne_id=Tablica_torow_postojowych[aktualne_id-1].od_id
						}else{
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" wyjezdża do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].do_id))
							}
							
							aktualne_id=Tablica_torow_postojowych[aktualne_id-1].do_id
						}
					} else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +"  czeka na wjazd na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
						}

						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
					}
				}
				if types == 2 {
					if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" naprawia tor: " + strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].id_toru_przejazdowego))				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*time.Duration(czas_naprawy) );
							Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_uszkodzony = false
							continue;
					}
					if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety == false{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" jest na torze przejazdowym ")			
						}
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Lock();
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety=true
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Unlock();
						var dzielenie float64
						if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc<predkosc{
							dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc) *1000
										//fmt.Println(dzielenie)
						}else{
							dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(predkosc) *1000
										//fmt.Println(dzielenie)			
						}
						time.Sleep((time.Millisecond / 60)* time.Duration(dzielenie)  * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));

						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety= false
						Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zarezerwowany = false 
						types=3
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" przejechał tor przejazdowy. wjazd na zwrotnice: ", strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id))				
						}

						aktualne_id=Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id
					}else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" czeka na wjazd na tor przejazdowy...")
						}
						
						time.Sleep((time.Millisecond / 60)* 1000 * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));
					}
				}
				if types == 3 {
					var numer_zwrotnicy int = Tablica_pojazdow_naprawczych[num].trasa[kolejnosc]
					if Tablica_zwrotnic[numer_zwrotnicy-1].czy_uszkodzony == true{
						if tryb == "G"{
							fmt.Println(czas+  " PojazdNaprawczy "+ strconv.Itoa(num) +" naprawia zwrotnice: " + strconv.Itoa(Tablica_zwrotnic[numer_zwrotnicy-1].id_zwrotnicy))				
						}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)* time.Duration(czas_naprawy) );
							Tablica_zwrotnic[numer_zwrotnicy-1].czy_uszkodzony = false ;
							continue;
					}

					if Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety == false{
						Tablica_zwrotnic[numer_zwrotnicy-1].mu.Lock();
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety=true
						Tablica_zwrotnic[numer_zwrotnicy-1].mu.Unlock();
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" wjeżdza na zwrotnice: "+ strconv.Itoa(numer_zwrotnicy))				
						}

						var czas_zatrzymania int =Tablica_zwrotnic[numer_zwrotnicy-1].opoznienie
						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(czas_zatrzymania));
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety= false
						Tablica_zwrotnic[numer_zwrotnicy-1].czy_zarezerwowany = false ;
						nastepna_zwrotnica= Tablica_pojazdow_naprawczych[num].trasa[(kolejnosc+1)%len(Tablica_pojazdow_naprawczych[num].trasa)]
						//fmt.Println(strconv.Itoa(numer_zwrotnicy)+ " "+ strconv.Itoa(nastepna_zwrotnica))
						var id_toru int = znajdzIdToru(numer_zwrotnicy,nastepna_zwrotnica,false)
						if id_toru ==-1{
							if tryb == "G"{
								fmt.Println(czas+   " ERROR!!!!!!!!!!!!!! PojazdNaprawczy "+ strconv.Itoa(num))					
							}
							break;
						}else if id_toru == 0{
							if tryb == "G"{
								fmt.Println(czas + " Pojazd naprawczy: "+ strconv.Itoa(num) + " Wszystkie tory sa aktualnie zajete")					
							}

						}else{
							if (id_toru<=liczba_torow_postojowych){
								types=1
							}else if (id_toru<= liczba_torow_postojowych+liczba_torow_przejazdowych){
								types=2			
							}else{
								if tryb == "G"{
									fmt.Println(czas+   " ERROR!!!!! PojazdNaprawczy")						
								}

							}
							if tryb == "G"{
								fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" zjeżdża z zwrotnicy :"+strconv.Itoa(numer_zwrotnicy))					
							}
							aktualne_id=id_toru
							kolejnosc++;



						}

					}else{
						if tryb == "G"{
							fmt.Println(czas+   " PojazdNaprawczy "+ strconv.Itoa(num) +" czeka na wolna zwrotnice")				
						}

						time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) );
					}
				}

				if kolejnosc==len(Tablica_pojazdow_naprawczych[num].trasa)-1{
					break;
				}
			}
			Tablica_pojazdow_naprawczych[num].trasa= Tablica_pojazdow_naprawczych[num].trasa[:0];
			if (tryb == "G"){
				fmt.Println("PojazdNaprawczy "+ strconv.Itoa(num) +" powrocil do:" + strconv.Itoa(Tablica_pojazdow_naprawczych[num].od_id))			
			}


			

			//fmt.Println("Naprawiono:",resultcheck[0], "id:",resultcheck[1]);
			resultcheck[0]=-1;
			resultcheck[1]=-1;
			czy_cos_do_naprawy =false;
		}
			time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*5 );
	}

}

func znajdzSciezke (typ [2]int, odkogo int,czy_powrotna bool) []int{
	//fmt.Println("------------------------" );
				//fmt.Println(sciezka);
	var result []int	
	var punktpoczatkowy int
	var punktkoncowy int
	
	if czy_powrotna==false{
		punktpoczatkowy = Tablica_pojazdow_naprawczych[odkogo].od_id
		if typ[0]==1{
			punktkoncowy = Tablica_torow_postojowych[typ[1]].od_id
		}
		//zepsul sie tor przejazdowy
		if typ[0]==2{
			punktkoncowy = Tablica_torow_przejazdowych[typ[1]].od_id
		}
		//zepsula sie zwrotnica
		if typ[0] ==3{
			punktkoncowy = Tablica_zwrotnic[typ[1]].id_zwrotnicy
		}
		//zepsul sie pociag
		if typ[0] ==4{
			typ[0]=Tablica_pociagow[typ[1]].typ_id;
			punktkoncowy = Tablica_pociagow[typ[1]].aktualne_id
		}
	}else{
		punktkoncowy = Tablica_pojazdow_naprawczych[odkogo].od_id
		if typ[0]==1{
			punktpoczatkowy = Tablica_torow_postojowych[typ[1]].od_id
		}
		//zepsul sie tor przejazdowy
		if typ[0]==2{
			punktpoczatkowy = Tablica_torow_przejazdowych[typ[1]].od_id
		}
		//zepsula sie zwrotnica
		if typ[0] ==3{
			punktpoczatkowy = Tablica_zwrotnic[typ[1]].id_zwrotnicy
		}
		//zepsul sie pociag
		if typ[0] ==4{
			//punktpoczatkowy = Tablica_pociagow[typ[1]]
			typ[0]=Tablica_pociagow[typ[1]].typ_id;
			punktpoczatkowy = Tablica_pociagow[typ[1]].aktualne_id
		}
	}

	
	
	
	var Tablica_wierzcholkow []Wierzcholek
	var polozenie int
	//fmt.Println("---OBLICZENI SASIEDZI WG IDZWROTNICY---");
	for i := range (Tablica_zwrotnic){
		Tablica_wierzcholkow = append(Tablica_wierzcholkow,Wierzcholek{});
		Tablica_wierzcholkow[i].id_wierzcholka=Tablica_zwrotnic[i].id_zwrotnicy
		Tablica_wierzcholkow[i].czy_odwiedzony=false
		Tablica_wierzcholkow[i].sasiednie_wierzcholki=znajdzSasiadow(i+1)	
		if Tablica_wierzcholkow[i].id_wierzcholka==punktpoczatkowy{
			Tablica_wierzcholkow[i].czy_odwiedzony=true
			polozenie = i
		}
	//	fmt.Print(strconv.Itoa(Tablica_wierzcholkow[i].id_wierzcholka)+ ": ")
	//	fmt.Print(Tablica_wierzcholkow[i].sasiednie_wierzcholki);
	//			fmt.Println(Tablica_wierzcholkow[i].czy_odwiedzony);
	}
	//fmt.Println("---KONIEC OBLICZENI SASIEDZI WG IDZWROTNICY---");
	var aktualnyId int
	aktualnyId = punktpoczatkowy
	var k int 
	var sasiad int
	var idToru int
	k = len(Tablica_wierzcholkow[polozenie].sasiednie_wierzcholki)
	//fmt.Println("Poszukuje sciezki od: "+ strconv.Itoa(punktpoczatkowy)+ "do : "+ strconv.Itoa(punktkoncowy));
	if (aktualnyId==punktkoncowy){
		result= append(result,aktualnyId)
		//fmt.Println("WYNIK KONCOWY:");
		//fmt.Println(result);
		//fmt.Println("------------------------------------");
		return result
		}
	for j := 0; j< k; j++{

		if (aktualnyId==punktkoncowy){
			result = Tablica_wierzcholkow[polozenie].lista_przejsc 
			break;
		}

		sasiad = Tablica_wierzcholkow[polozenie].sasiednie_wierzcholki[j]
		idToru = znajdzIdToru(aktualnyId,sasiad,false);
		//fmt.Println("ID aktualnego wierzcholka:"+ strconv.Itoa(aktualnyId)+ " sasiad : "+ strconv.Itoa(sasiad));
		if (idToru!=0){
			var possasiada int
			possasiada=findPositionbyId(sasiad)
			if (Tablica_wierzcholkow[possasiada].czy_odwiedzony==false){
				//fmt.Println("sasiad NIEODWIEDZONY : "+ strconv.Itoa(sasiad));
				Tablica_wierzcholkow[polozenie].ostatni_iterator=j
				
				Tablica_wierzcholkow[possasiada].pozycja_poprzednika=polozenie
				Tablica_wierzcholkow[possasiada].lista_przejsc = Tablica_wierzcholkow[polozenie].lista_przejsc
				Tablica_wierzcholkow[possasiada].lista_przejsc = append(Tablica_wierzcholkow[possasiada].lista_przejsc,sasiad)
				Tablica_wierzcholkow[possasiada].czy_odwiedzony=true 
				polozenie=possasiada
				aktualnyId=Tablica_wierzcholkow[polozenie].id_wierzcholka 
				j =-1
				k = len(Tablica_wierzcholkow[polozenie].sasiednie_wierzcholki)			
			}
		}
		
		if (j==k-1){
			polozenie =Tablica_wierzcholkow[polozenie].pozycja_poprzednika
			j= -1
			k= len(Tablica_wierzcholkow[polozenie].sasiednie_wierzcholki)
			aktualnyId=Tablica_wierzcholkow[polozenie].id_wierzcholka 
		}
	
	}
	
	//fmt.Println("WYNIK KONCOWY:");
	//fmt.Println(result);
	//fmt.Println("------------------------------------");
	return result

}

func znajdzSasiadow(num int)[]int{
	var listaSasiadowtemp [] int
	var listaSasiadow [] int
	
	for i := range(Tablica_torow_postojowych){
		if Tablica_torow_postojowych[i].od_id==num{
			listaSasiadowtemp=append(listaSasiadowtemp,Tablica_torow_postojowych[i].do_id)
		}
		if Tablica_torow_postojowych[i].do_id==num{
			listaSasiadowtemp=append(listaSasiadowtemp,Tablica_torow_postojowych[i].od_id)
		}
	}
	for i := range(Tablica_torow_przejazdowych){
		if Tablica_torow_przejazdowych[i].od_id==num{
			listaSasiadowtemp=append(listaSasiadowtemp,Tablica_torow_przejazdowych[i].do_id)
		}
	}
	
	for i:= range(listaSasiadowtemp){
		var powtorzenie bool
		powtorzenie = false
		for j := range (listaSasiadow){
			if (listaSasiadow[j]==listaSasiadowtemp[i]){
				powtorzenie = true
			}
		}
		if powtorzenie == false{
			listaSasiadow = append (listaSasiadow,listaSasiadowtemp[i])
		}
	}
	
	return listaSasiadow;

	//return listaSasiadowtemp


}
func check ()[2]int{
	var result [2]int
	result[0]=-1
	result[1]=-1

	for i := range(Tablica_pociagow){
		if Tablica_pociagow[i].czy_uszkodzony==true && Tablica_pociagow[i].czy_wyslano_do_naprawy == false{
			Tablica_pociagow[i].czy_wyslano_do_naprawy = true
			result[0]=4;
			result[1]=i;
			return result;
		}		
	}
	
	
	for i := range(Tablica_torow_postojowych){
		if Tablica_torow_postojowych[i].czy_uszkodzony== true && Tablica_torow_postojowych[i].czy_wyslano_do_naprawy == false{
			Tablica_torow_postojowych[i].czy_wyslano_do_naprawy = true
			result[0]=1;
			//result[1]=Tablica_torow_postojowych[i].id_toru_postojowego;
			result[1]=i;
			return result;
		}		
	}
	for i := range(Tablica_torow_przejazdowych){
		if Tablica_torow_przejazdowych[i].czy_uszkodzony==true && Tablica_torow_przejazdowych[i].czy_wyslano_do_naprawy == false{
			Tablica_torow_przejazdowych[i].czy_wyslano_do_naprawy = true
			result[0]=2;
			//result[1]=Tablica_torow_przejazdowych[i].id_toru_przejazdowego;
			result[1]=i;
			return result;
		}		
	}
	for i := range(Tablica_zwrotnic){
		if Tablica_zwrotnic[i].czy_uszkodzony==true && Tablica_zwrotnic[i].czy_wyslano_do_naprawy== false{
			Tablica_zwrotnic[i].czy_wyslano_do_naprawy= true
			result[0]=3;
			//result[1]=Tablica_zwrotnic[i].id_zwrotnicy;
			result[1]=i;
			return result;
		}		
	}
	
	
	

	
	return result;
}

func findPositionbyId(position int) int{
	
	for i := range (Tablica_zwrotnic){
		if Tablica_zwrotnic[i].id_zwrotnicy==position{
			return i;
		
		}
	
	}
	return -1;

}


//func goTory (c chan bool , num int){
func goTory (num int){
		for (true){
			if (rand.Float64()>0.95){
				if (num<liczba_torow_postojowych){
					Tablica_torow_postojowych[num].czy_uszkodzony = true ;
				}else{
					Tablica_torow_przejazdowych[num-liczba_torow_postojowych].czy_uszkodzony = true ;
				}
			}
			time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 60 );
		}


	//c <- true
}
//func goZwrotnica (c chan bool , num int){
func goZwrotnica ( num int){
		for (true){
			if (rand.Float64()>0.95){
				Tablica_zwrotnic[num].czy_uszkodzony=true;
			}
			time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 60 );
		}


	//c <- true
}

//func goPociag(c chan bool,num int) {
func goPociag(num int) {
	if tryb=="G"{
		fmt.Println(czas+   " Pociąg "+ Tablica_pociagow[num].nazwa_pociagu+ " rusza na trase")	
	}

	var kolejnosc int =0
	var types int =3 //1-tor postojowy 2-tor przejazdowy 3-zwrotnica
	var nastepna_zwrotnica int = Tablica_pociagow[num].kolejnosc_przejazdu[(kolejnosc+1)]
	var aktualne_id= Tablica_pociagow[num].kolejnosc_przejazdu[kolejnosc]
	Tablica_pociagow[num].aktualne_id=aktualne_id;
	Tablica_pociagow[num].typ_id=types;
	for true{
	
		if (rand.Float64()>0.99){
			Tablica_pociagow[num].czy_uszkodzony= true ;
		}
	
		if (Tablica_pociagow[num].czy_uszkodzony==true){
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " zostal uszkodzony!")				
				}
			time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*60 );
			continue;
		}
		if types == 1 {
			if Tablica_torow_postojowych[aktualne_id-1].czy_uszkodzony == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji+ " stacja uszkodzona")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*10 );
					continue;
			}
			if Tablica_torow_postojowych[aktualne_id-1].czy_zarezerwowany == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji+ " tor zarezerwowany")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)*10 );
					continue;
			}
			if Tablica_torow_postojowych[aktualne_id-1].czy_zajety== false{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "dojechal na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
				}
				Tablica_torow_postojowych[aktualne_id-1].mu.Lock();
				Tablica_torow_postojowych[aktualne_id-1].czy_zajety=true
				Tablica_torow_postojowych[aktualne_id-1].mu.Unlock();
				Tablica_pociagow[num].aktualne_id=aktualne_id;
				Tablica_pociagow[num].typ_id=types;
				time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
				Tablica_torow_postojowych[aktualne_id-1].czy_zajety=false
				types=3
				if Tablica_pociagow[num].kolejnosc_przejazdu[kolejnosc] == Tablica_torow_postojowych[aktualne_id-1].od_id{
					if tryb == "G"{
						fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " wyjezdża123123 do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].od_id))					
					}
					aktualne_id=Tablica_torow_postojowych[aktualne_id-1].od_id
				}else{
					if tryb == "G"{
						fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " wyjezdża do zwrotnicy: ", strconv.Itoa(Tablica_torow_postojowych[aktualne_id-1].do_id))
					}
					
					aktualne_id=Tablica_torow_postojowych[aktualne_id-1].do_id
				}
			} else{
				if tryb == "G"{
					fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " czeka na wjazd na stacje: " + Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji)				
				}

				time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_postojowych[aktualne_id-1].minimalny_czas_postoju));
			}
		}
		if types == 2 {
			if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_uszkodzony == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na tor: " + strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].id_toru_przejazdowego)+ " tor uszkodzony")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 10 );
					continue;
			}
			if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zarezerwowany == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na tor: " + strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].id_toru_przejazdowego)+ " tor zarezerwowany")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 10 );
					continue;
			}
			if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety == false{
				if tryb == "G"{
					fmt.Println(czas+   " Pociag"+ Tablica_pociagow[num].nazwa_pociagu+ " jest na torze przejazdowym ")			
				}
				Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Lock();
				Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety=true
				Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].mu.Unlock();
				Tablica_pociagow[num].aktualne_id=aktualne_id;
				Tablica_pociagow[num].typ_id=types;
				var dzielenie float64
				if Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc<Tablica_pociagow[num].predkosc_maksymalna{
					dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].max_predkosc) *1000
								//fmt.Println(dzielenie)
				}else{
					dzielenie = float64(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc)/float64(Tablica_pociagow[num].predkosc_maksymalna) *1000
								//fmt.Println(dzielenie)			
				}
				time.Sleep((time.Millisecond / 60)* time.Duration(dzielenie)  * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));

				Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].czy_zajety=false
				types=3
				if tryb == "G"{
					fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " przejechał tor przejazdowy. wjazd na zwrotnice: ", strconv.Itoa(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id))				
				}

				aktualne_id=Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].do_id
			}else{
				if tryb == "G"{
					fmt.Println(czas+   " Pociag"+ Tablica_pociagow[num].nazwa_pociagu+ " czeka na wjazd na tor przejazdowy...")
				}
				
				time.Sleep((time.Millisecond / 60)* 1000 * time.Duration(czestotliwosc)  * time.Duration(Tablica_torow_przejazdowych[aktualne_id-1-liczba_torow_postojowych].dlugosc));
			}
		}
		if types == 3 {
			var numer_zwrotnicy int = Tablica_pociagow[num].kolejnosc_przejazdu[kolejnosc]
			if Tablica_zwrotnic[numer_zwrotnicy-1].czy_uszkodzony == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na zwrotnice: " + strconv.Itoa(Tablica_zwrotnic[numer_zwrotnicy-1].id_zwrotnicy)+ " zwrotnica uszkodzona")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 10  );
					continue;
			}
			if Tablica_zwrotnic[numer_zwrotnicy-1].czy_zarezerwowany == true{
				if tryb == "G"{
					fmt.Println(czas+  " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ "nie moze wjechac na zwrotnice: " + strconv.Itoa(Tablica_zwrotnic[numer_zwrotnicy-1].id_zwrotnicy)+ " zwrotnica zarezerwowana")				
				}		
							time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) * 10  );
					continue;
			}
			if Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety == false{
				Tablica_zwrotnic[numer_zwrotnicy-1].mu.Lock();
				Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety=true
				Tablica_zwrotnic[numer_zwrotnicy-1].mu.Unlock();
				Tablica_pociagow[num].aktualne_id=aktualne_id;
				Tablica_pociagow[num].typ_id=types;
				if tryb == "G"{
					fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " wjeżdza na zwrotnice: "+ strconv.Itoa(numer_zwrotnicy))				
				}

				var czas_zatrzymania int =Tablica_zwrotnic[numer_zwrotnicy-1].opoznienie
				time.Sleep((time.Second / 60) * time.Duration(czestotliwosc)  * time.Duration(czas_zatrzymania));
									Tablica_zwrotnic[numer_zwrotnicy-1].czy_zajety=false
				nastepna_zwrotnica= Tablica_pociagow[num].kolejnosc_przejazdu[(kolejnosc+1)%len(Tablica_pociagow[num].kolejnosc_przejazdu)]
				var id_toru int = znajdzIdToru(numer_zwrotnicy,nastepna_zwrotnica,false)
				if id_toru ==-1{
					if tryb == "G"{
						fmt.Println(czas+   " ERROR!!!!!!!!!!!!!! Pociag " + Tablica_pociagow[num].nazwa_pociagu)					
					}

					break;
				}else if id_toru == 0{
					if tryb == "G"{
						fmt.Println(czas + " "+ Tablica_pociagow[num].nazwa_pociagu + " : Wszystkie tory sa aktualnie zajete")					
					}

				}else{
					if (id_toru<=liczba_torow_postojowych){
						types=1
					}else if (id_toru<= liczba_torow_postojowych+liczba_torow_przejazdowych){
						types=2			
					}else{
						if tryb == "G"{
							fmt.Println(czas+   " ERROR!!!!! Pociag " +  Tablica_pociagow[num].nazwa_pociagu )						
						}

					}
					if tryb == "G"{
						fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " zjeżdża z zwrotnicy :"+strconv.Itoa(numer_zwrotnicy))					
					}
					aktualne_id=id_toru
					kolejnosc++;



				}

			}else{
				if tryb == "G"{
					fmt.Println(czas+   " Pociag "+ Tablica_pociagow[num].nazwa_pociagu+ " czeka na wolna zwrotnice")				
				}

				time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) );
			}
		}

		if kolejnosc==len(Tablica_pociagow[num].kolejnosc_przejazdu){
			kolejnosc=0
		}
		
	}
    //c <- true
}

func znajdzIdToru(od int, do int,czy_uwzgledniac_ze_zajety bool)int{

	var czy_znaleziono bool=false
	for i := range(Tablica_torow_przejazdowych){
		if Tablica_torow_przejazdowych[i].od_id == od && Tablica_torow_przejazdowych[i].do_id == do{
			if Tablica_torow_przejazdowych[i].czy_zajety == false{
						return Tablica_torow_przejazdowych[i].id_toru_przejazdowego
			}else{
				czy_znaleziono= true
			}

		}
	}

	for i := range(Tablica_torow_postojowych) {

		if (Tablica_torow_postojowych[i].od_id == od && Tablica_torow_postojowych[i].do_id == do) || (Tablica_torow_postojowych[i].do_id == od && Tablica_torow_postojowych[i].od_id == do) {
			if Tablica_torow_postojowych[i].czy_zajety == false{
				return Tablica_torow_postojowych[i].id_toru_postojowego
			}else{
				czy_znaleziono= true
			}
		}
	}
	if czy_znaleziono == false{
		return -1
	}else{
		return 0
	}

}
//func goZegar(c chan bool, godzinyw int, minutyw int, czestotliwoscw int ){
func goZegar( godzinyw int, minutyw int, czestotliwoscw int ){
	godziny=godzinyw
	minuty=minutyw
	czestotliwosc=czestotliwoscw
	czas=strconv.Itoa(godziny)+":"+strconv.Itoa(minuty)
	for true{
		//fmt.Println(strconv.Itoa(godziny)+ " : " + strconv.Itoa(minuty) + " ")
		time.Sleep((time.Second / 60) * time.Duration(czestotliwosc) );
		minuty++
		if minuty == 60{
			minuty= 0
			godziny++
		}
		if godziny == 24{
			godziny = 0
		}
		czas=strconv.Itoa(godziny)+":"+strconv.Itoa(minuty)
	}
	//c <- true
}
//func goMenu (c chan bool){
func goMenu (){
	fmt.Println("WITAJ W TRYBIE SPOKOJNYM")	
	for true{
			fmt.Println("Oto Twoje dostepne opcje:")
			fmt.Println("1. Pokaż, w którym miejscu aktualnie znajdujo się pociągi")
			fmt.Println("2. Pokaż rozklad jazdy każdego pociągu")
			fmt.Println("3. Pokaż aktualną godzine (w symulacji)")
			fmt.Println("4. Zakończ działanie symulacji")
			scanner := bufio.NewScanner(os.Stdin)
			var temp string
			for scanner.Scan() {
				temp = scanner.Text()
				fmt.Println("Wybrano opcje:" + temp)	
				break;
			}
			if err := scanner.Err(); err != nil {
				fmt.Println("reading standard input:", err)
			}
			switch temp {
				case "1":
					for i := range (Tablica_pociagow){
						var rodzaj int
						rodzaj = Tablica_pociagow[i].typ_id
						var aktualne_id int = Tablica_pociagow[i].aktualne_id
						if rodzaj == 1 {
							fmt.Println(Tablica_pociagow[i].nazwa_pociagu + "jest na torze postojowym "+ strconv.Itoa(aktualne_id)+ " stacja: "+ Tablica_torow_postojowych[aktualne_id-1].nazwa_stacji )
						}
						if rodzaj == 2 {
							fmt.Println(Tablica_pociagow[i].nazwa_pociagu + "jest na torze przejazdowym "+ strconv.Itoa(aktualne_id))
						}
						if rodzaj == 3 {
							fmt.Println(Tablica_pociagow[i].nazwa_pociagu + "jest na zwrotnicy "+ strconv.Itoa(aktualne_id))
						}

					}
					//TODO: Pokazywanie, gdzie znajdujo sie pociongi
				case "2":
					//fmt.Println("Tu pokaze rozklad jazdy kazdego pociagu")
					for i := range(Tablica_pociagow){
						fmt.Println(Tablica_pociagow[i].nazwa_pociagu)
						for j := range (Tablica_pociagow[i].kolejnosc_przejazdu){
							fmt.Print(" "+ strconv.Itoa(Tablica_pociagow[i].kolejnosc_przejazdu[j]))
						}
						fmt.Println("")
					} 
				case "3":
					fmt.Println("Aktualna godzina: " + czas)
				case "4":
					os.Exit(1)
				}

	}
	//c <- true
}