//OPIS: logicki operatori
//RETURN: 7

int main(){

	int a, b, c, d;
	
	a = 4; 
	b = 6;
	c = 7;
	
	if( a < b and b > 5 or c != 6)
		c++;
	else
		b++;
	
	if( a == b or c > 2)
		b++;

	return b;
}
