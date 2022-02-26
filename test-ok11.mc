//OPIS: provjera switch iskaza
//RETURN: 4
int main(){

	int a = 6;
	int b = 4;
	int c = 5;
	
	//switch iskaz bez otherwise dijela
	switch a
		case 6
			a = a + 2;
		case 2
			a = a - b;
	end_switch
	
	//sa otherwise dijelom
	switch b
		case 3
			b = b + 2;
		case 4
			b = a - b;
		otherwise 
			c = b++;
	end_switch
	
	
	return b;

}
