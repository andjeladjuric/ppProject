//Testiranje postinkrementnog operatora
//RETURN: 4
int main(){
	int a,b,c;
	unsigned d,e,f;
	
	a = 2;
	
	a++;			//Moguća upotreba kao statement
	d++;
	
	b = a++ + c;    //Moguća upotreba kao expression
	d = f + ++e;
	--d;
	++d;
	f--;
	
	if(a < b++)
		a = 10;

	return a;
}
