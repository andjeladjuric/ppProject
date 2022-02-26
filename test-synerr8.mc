//OPIS: sintaksne greske za logicke izraze

int main(){	
	int a, b, c;
	a = 5;
	b = 6;
	c = 7;
	
	if(a > b and a or b != 2) // logicki operator se mora nalaziti izmedju relacionih izraza
		c = a + 5;

	return 0;
}
