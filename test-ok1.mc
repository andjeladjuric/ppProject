//OPIS: testiranje osnovnih elemenata
//RETURN: 7

int testFunc(int a){
	int b;
	a = 3;
	b = 2;
	return a + b; 
	
	// jednolinijski komentar
	
	/* viselinijski 
		 komentar */
		 
	/**** i
				ovo
				je
				komentar ****/
}


int main() {
		// identifikatori
    int a;
    int b;
    int c;
    
    unsigned x = 2u; // omogucena je i ovakva dodjela
    
    // dodjela
    a = 2;
    b = 3;
    
    // relacioni izrazi, if iskaz (bez else)
    if (a > 1)
    	a = a + 5;
    
    // operatori za sabiranje i oduzimanje
    b = a + 4;
    c = 5 + 2;
    
    // if else iskaz
    if (b <= 3)
    	b = 6;
    else
    	b = 0;   
    	
    return a + b;
}
