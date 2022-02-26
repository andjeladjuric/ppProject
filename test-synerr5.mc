//OPIS: sintaksne greske za switch
int main() {
    int a;
    int b = 7;
    int c = 10;
    a = 10;
    
    switch a
    	case 1
    		a = a + 5;
    	case 2 					//nedostaje statement
    	otherwise
    		a = a - 3;
    									//nedostaje end_switch
    							
   switch b
    	case 5
    		b = a + 5;
    	case 7 				
    		b = 6;
    	otherwise
    		b = b - 3;
    									//nedostaje end_switch
    									
    switch c
   		otherwise
   			c = c + 2;
   		case 3
   			a++;
   		case 4
   			c = 2;
   		end_switch
}
