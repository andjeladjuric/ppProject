//OPIS: sintaksne greske za funkcije sa vise parametara
int funk(int a int b){ //nedostaje zapeta
	a = 4;
	b = 5;
	return a + b;
}

int main(){
	int a, b;
	
	a = funk(2 5); //nedostaje zapeta 
	
}
