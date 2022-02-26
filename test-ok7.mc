//OPIS: razlicit return kod razlicitih tipova funkcije
//RETURN: 5

int tipInt(){
	int a = 5;
	return a; //ne prijavljuje ni gresku ni upozorenje
}

unsigned tipUnsigned(){
	unsigned b;
	b = 2u;
	return b;
}

void tipVoid1(int x){
	x++;
} //ne prijavljuje ni gresku ni upozorenje

void tipVoid2(){
	int a;
	//return;
}

int main(){
	int x;
	unsigned y;
	
	x = tipInt();
	y = tipUnsigned();
	
	tipVoid1(2);
	tipVoid2();
	
	return x;
}


