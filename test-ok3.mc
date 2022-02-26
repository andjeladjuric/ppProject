//OPIS: postinkrement operator
//RETURN: 21
int main() {
    int a, b;
    int c;
    int d;
    
    a = 9;
    b = 10;
    
    a++;
    b++;
    
    c = a + b++;
    d = a++ - b;
    
    return c;
}
