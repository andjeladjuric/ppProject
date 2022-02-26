//OPIS: provjera za for iskaz
//RETURN:15

int f(){
	int a, b;
	a = 2;
	b = 3;
	for(int i; i < 4; step 2){ //ugnjezdeni for 
		for(int j; j < 6){ //drugi for nema step
			a = a + i;
			b = b - j;
		}
	}
	
	return a;
}


int main(){
	int a;
	int b = 6;
	a = 5;
	
	for(int i; i < 5){ //u razlicitim funkcijama iterator moze imati istu oznaku; nema step dio
		a = a + i;
	}
	
	for(int n; n < 8; step 2){ //u istoj funkciji ne smiju postojati dva for iskaza sa iteratorom sa istom oznakom
		b = b - n;
	}


	return a;
}
