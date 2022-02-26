//OPIS: ocekivane semanticke greske kod funkcija sa vise parametara
int prvaFunk(int a, unsigned b){
	a = 2;
	b = 3u;
	return a;
}

unsigned drugaFunk(unsigned x, unsigned y){
	x = 2u;
	return x;
}

int main(){
	int a, c;
	unsigned b;
	
	a = prvaFunk(2u, 3); //argumenti nisu dobrog tipa
	c = drugaFunk(4u, 6u); //pogresan poziv funkcije - tip promjenljive i povratni tip funkcije nisu isti

	return 0;
}
