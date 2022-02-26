//OPIS: semanticke provjere
//RETURN: 2

int f(int a){
	int x = 2;
	unsigned y = 4u;
	return x;
}

unsigned func(unsigned a){
	a = 2u;
	return a;
}

int main(){
	int a;
	int b, c;
	unsigned x;
	unsigned y = 5u;
	
	a = 3;  //da li su promjenljiva i vrijednost istog tipa 
	b = 6;
	
	c = f(3); //da li su promjenljiva i funkcija istog tipa
	x = func(4u); 
	
	b++; //promjenljiva mora biti ranije definisana
	
	if(a == b) //promjenljive u relacionim izrazima moraju biti istog tipa
		c++;
	else
		c = 2;
	
	return c;
}
