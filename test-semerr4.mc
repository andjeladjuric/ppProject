//OPIS: semanticke greske za void

void prvaFunk(int a){
	a++;
	return a;
}

int drugaFunk(void b){ //parametar ne moze biti tipa void
	int c = 4;
	return c;
}

int main(){

	int x,y;
	void z; //promjenljiva ne moze biti tipa void
	
	x = prvaFunk(3); //pogresan poziv funkcije
	
}


