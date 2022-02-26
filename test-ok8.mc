//OPIS: funkcije sa vise parametara
//RETURN: 13

int istiPar(int a, int b){
	a++;
	return a + b;
}

unsigned razlPar(int x, unsigned y, unsigned z){
	y = 2u;
	x = 3;
	z = 4u;
	return y;
}

int main(){
	int x;
	unsigned b;
	int y = 5;
	y++;
	
	x = istiPar(2, 4);
	b = razlPar(4, 5u, 6u);

	return x + y;
}



