//OPIS: Sanity check za gramatiku
void v(int a, int b){ 
	a = 5;
}

int f(int x) {
    int y;
    return x + 2 - y;
}

unsigned f2() {
    return 2u;
}

unsigned ff(unsigned x) {
    unsigned y;
    return x + f2() - y;
}

int main() {
    int a;
    int b;
    int aa;
    int bb;
    int c;
    int d;
    unsigned u;
    unsigned w;
    unsigned uu;
    unsigned ww;
    int zbir = 0;
		int razlika = 0;

    //poziv funkcije
    a = f(3);
    
    //poziv void funkcije
    v(3, 4);
   
    //if iskaz sa else delom
    if (a < b)  //1
        a = 1;
    else
        a = -2;

    if (a + c == b + d - 4) //2
        a = 1;
    else
        a = 2;

    if (u == w) {   //3
        u = ff(1u);
        a = f(11);
    }
    else {
        w = 2u;
    }
    if (a + c == b - d - -4) {  //4
        a = 1;
    }
    else
        a = 2;
    a = f(42);

    if (a + (aa-c) - d < b + (bb-a))    //5
        uu = w-u+uu;
    else
        d = aa+bb-c;

    //if iskaz bez else dela
    if (a < b)  //6
        a = 1;

    if (a + c == b - +4)    //7
        a = 1;
        
    // upotreba logickih operatora
    if(a > 3 and b < 4)
    	a++;
    	
    // for iskaz
		for (int i; i <14; step 3){
			zbir = zbir + i;
			razlika = razlika - i;
		}
		for (int n ; n < 7)
			razlika = zbir - n;
    
    // switch iskaz
    switch a
			case 1
				a = a + 5;
			case 5
			{
				b = 3;
			}
			otherwise
				a = a - 1;
		end_switch
		
		//jednolinijski komentar
		/*viselinijski
			komentar*/
     
    return 0;  
}

