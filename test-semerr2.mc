//OPIS: promjenljive nisu istog tipa
int main() {
    int a,b,c;
    unsigned d, e;
    a = 3;
    b = 4;
    e = 2u;
    
    d = a + b; //moraju biti istog tipa prilikom dodjele
    
    if( a >= e) //u upotrebi relacionih izraza
    	a++;
   
   return 0;
}
