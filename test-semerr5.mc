//OPIS: semanticke greske za return
void v(){
	return 5; //void ne smije da ima povratnu vrijednost
}

unsigned un(unsigned x){
	return 2; //pogresna povratna vrijednost
}

int in(int a){
	return 6u; //pogresna povratna vrijednost
}

int main() {
   	int a;
   	unsigned b;
   	
   	a = un(2u); //razliciti povratni tip i promjenljiva
   	a = v(); //pogresan poziv void funkcije
}

