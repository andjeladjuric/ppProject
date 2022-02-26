//OPIS: semanticke greske za switch

int main(){

	int a, b;
	unsigned y;
	a = 3;
	
	switch x //x nije definisana
		case 1
			a = a + 2;
		case 1 //konstanta je vec upotrebljena
			b = a + 3;
		case 2u
			y = 5u; //konstanta i promjenljiva moraju biti istog tipa
	end_switch
	
	return 0;
}
