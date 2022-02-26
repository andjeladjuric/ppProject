//OPIS: testiranje void tipa
//RETURN: 0

void v(int a){
	a++;
	return; //funkcija void moze da ima return tip
}

void func(){
	int b = 3; 
} //isto tako ne mora da ima return

int main(){

	int x;
	
	//poziv void funkcije
	v(3);
	func();
	
	return 0;
}
