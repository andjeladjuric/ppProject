//OPIS: semanticka provjera za deklarisanje vise promjenljivih
//RETURN: 6

int func(int a){
	a = 5;
	return a;
}

int main(){
	int a,b,c; // promjenljiva istog naziva se moze definisati opet u sledecoj funkciji
	unsigned x,y,z;
	int d = 1; 
	
	b = func(5);
	c = b + d++;
	d = b + --d;

	return c;
}



