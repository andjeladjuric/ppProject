//OPIS: provjera switch iskaza
//RETURN: 20 
int main(){

	int suma;
	int i;
	suma = 0;
	i = 1;
	
	switch i
		case 0
			suma = 5;
		case 1
			suma = 10;
		otherwise
			suma = 2;
	end_switch
	
	switch suma
		case 5
			i = 5;
		case 10
			i = 10;
	end_switch
	
	return suma + i;

}
