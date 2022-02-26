//OPIS: jednostavan miniC conditional izraz3
//RETURN: 35

int main() {
	int a;
	int b;
	a = 3;
	b = 4;

	a = a + (a > b) ? a : b + 3; //10
	
	b = a + (a < b) ? a : b + a++; //25

	return a + b;
}

