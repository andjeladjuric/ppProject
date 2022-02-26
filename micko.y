%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int lab_num = -1;
  FILE *output;
  
  int lab_for = -1;
  int level  = 0;
  
  int return_count = 0;
  unsigned tempMV = NO_TYPE;
  int param = 0;
  int args = 0;
  
  int literali[100];
  int lit_count = 0;
  int switch_num = -1;
  int swExp = 0;
  
  int lab_and = 0;
  int lab_or = 0;
  int or_count = 0;
  int and_count = 0;
  
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _FOR
%token _STEP
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token <i> _AROP
%token <i> _RELOP
%token <i> _LOGOP
%token _AND
%token _OR
%token _COMMA
%token <i> _POSTINC
%token <i> _POSTDEC
%token _SWITCH
%token _CASE
%token _OTHERWISE
%token _ENDSWITCH
%token _QUESTION
%token _COLON

%type <i> num_exp exp literal function_call argument rel_exp step_exp if_part conditional_exp
%type <i> multiple_variables multiple_args rel_exp_and rel_exp_or

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : global_list function_list
    {  
     	if(lookup_symbol("main", FUN) == NO_INDEX)
      	err("undefined reference to 'main'");
    }
  ;

global_list
	: /* empty */
	| global_list global_var
	;
	
global_var
	: _TYPE _ID _SEMICOLON
		{
			insert_symbol($2, GVAR, $1, NO_ATR, NO_ATR);
			
			code("\n%s:\n\t\tWORD\t1", $2);
		}
	;
	
function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
  	{
     	fun_idx = lookup_symbol($2, FUN);
      if(fun_idx == NO_INDEX)
      	fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
      else 
      	err("redefinition of function '%s'", $2);   
      	
      	code("\n%s:", $2);
        code("\n\t\tPUSH\t%%14");
        code("\n\t\tMOV \t%%15,%%14"); 
    }
    _LPAREN { param = 0; } parameter _RPAREN body
    {
      
    	if(get_type(fun_idx) != VOID && return_count == 0)
    		warn("function is not of type void and needs a return value!");
      	
      	return_count = 0;	
        
      	set_atr1(fun_idx, param);
      	clear_symbols(fun_idx + param + 1);
        var_num = 0;
        
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
    }
  ;

parameter
  : /* empty */
    { set_atr1(fun_idx, 0); }
  | multiple_parameters
  ;
  
multiple_parameters
	: _TYPE _ID
    {
     	if( $1 == VOID)
      	err("parameters cannot be of void type");
      	
        insert_symbol($2, PAR, $1, ++param, NO_ATR);
    }
  | multiple_parameters _COMMA _TYPE _ID	//OMOGUCEN VECI BROJ PARAMETARA U FUNKCIJI
  	{		
  		if(lookup_symbol($4, VAR|PAR) < fun_idx) //omoguceno da parametri u razlicitim funkcijama nose isti naziv
  			insert_symbol($4, PAR, $3, ++param, NO_ATR);
  		else
  			err("redefinition of parameter '%s'", $4);
  	}
  ;
  
body
  : _LBRACKET variable_list 
  		{
  			if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
  		}
  	statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE { tempMV = $1; } multiple_variables _SEMICOLON
  	{ 
  		if( $1 == VOID)
      	err("variables cannot be of void type");
    }
  ;
  
//DEKLARACIJA VISE PROMJENLJIVIH I OMOGUCENA DODJELA PRILIKOM DEKLARACIJE
multiple_variables
	: _ID
		{
		 	if(lookup_symbol($1, VAR|PAR) == NO_INDEX)
		 		$$ = insert_symbol($1, VAR, tempMV, ++var_num, NO_ATR);
		 	else if(lookup_symbol($1, VAR|PAR) < fun_idx)
		  	$$ = insert_symbol($1, VAR, tempMV, ++var_num, NO_ATR);
		 	else 
		  	err("redefinition of '%s'", $1);
    }
	| multiple_variables _COMMA _ID
	  {
		 	if(lookup_symbol($3, VAR|PAR) == NO_INDEX)
		 		$$ = insert_symbol($3, VAR, tempMV, ++var_num, NO_ATR);
		 	else if(lookup_symbol($3, VAR|PAR) < fun_idx)
		  	$$ = insert_symbol($3, VAR, tempMV, ++var_num, NO_ATR);
		 	else 
		  	err("redefinition of '%s'", $3);
    }
  | _ID _ASSIGN num_exp 
  	{
		  if(lookup_symbol($1, VAR|PAR) == NO_INDEX)
		  	$$ = insert_symbol($1, VAR, tempMV, ++var_num, NO_ATR);
		 	else if(lookup_symbol($1, VAR|PAR) < fun_idx)
		    $$ = insert_symbol($1, VAR, tempMV, ++var_num, NO_ATR);
		  else 
		    err("redefinition of '%s'", $1);
		    
		  gen_mov($3, $$);
  	}
	;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement
  | increment_statement
  | decrement_statement
  | for_statement
  | switch_statement
  | void_function_call
  ;
  
//SWITCH ISKAZ
switch_statement
	: _SWITCH 
			{
				switch_num++;
				code("\n@switch%d:", switch_num);
				lit_count = 0;
				code("\n\t\tJMP\t@switch_body%d", switch_num);
			}
	_ID 
			{
				swExp = lookup_symbol($3, VAR|PAR);
				if(swExp == NO_INDEX)
					err("'%s' undeclared", $3);
			}
		case_statements otherwise_statement _ENDSWITCH
			{
				//code("\n@otherwise%d:", switch_num);
				//code("\n\t\tJMP\t@exit%d", switch_num);
				code("\n@switch_body%d:", switch_num);
				
				int i;
				for(i = 0; i < lit_count; i++){
					gen_cmp(literali[i], swExp);
					code("\n\t\tJEQ\t@case%s", get_name(literali[i]));
				}
				
				if( $<i>6 != 1 )
					code("\n\t\tJMP\t@otherwise%d", switch_num);
				
				code("\n@exit%d:", switch_num);
				
			}
	;

case_statements
	: case
	| case_statements case
	;
	
case
	: _CASE literal
		
		{
			for(int i = 0; i < lit_count; i++) {
				if(literali[i] == $2) {
					err("constant already used!");
					break;
				}
			}
			
			literali[lit_count] = $2;
			lit_count++;
			
			if(get_type(swExp) != get_type($2))
				err("Variable and constant have to be of same type"); 
				
			code("\n@case%s:", get_name($2));
		}
		statement
			{
				code("\n\t\tJMP\t@exit%d", switch_num);
			}
	;
	
otherwise_statement
	: /* empty */ {$<i>$ = 1;}
	| _OTHERWISE { code("\n@otherwise%d:", switch_num); } 
	statement { code("\n\t\tJMP\t@exit%d", switch_num); }
	;

//FOR ISKAZ
step_exp
	: /*empty*/ {$<i>$ = 1;}
	| _SEMICOLON _STEP literal {$<i>$ = $3;}
	;


for_statement
	: _FOR _LPAREN {$<i>$ = ++lab_for; }_TYPE _ID 
			{
				int idx = lookup_symbol($5, VAR|PAR);
				if(idx == NO_INDEX || idx < fun_idx){
					insert_symbol($5, VAR, $4, ++var_num, NO_ATR);
					set_atr2(idx, 1);
				}
				else
					err("Iterator '%s' was already used", $5);	
					
				level++;
				$<i>$ = get_last_element();
				
				code("\n@for_begin%d:", lab_for);
				idx = lookup_symbol($5, VAR|PAR);
		 		code("\n\t\tMOV\t$1,\t");
				gen_sym_name(idx);
				
				code("\n@for%d:", lab_for);
				printf("%d", level);
			}		
		 _SEMICOLON rel_exp	
		 	{
		 		code("\n\t\t%s\t@exit%d", opp_jumps[$8], $<i>3);
		 	}
		 step_exp _RPAREN statement
			{
				int idx = lookup_symbol($5, VAR|PAR);
				if($<i>10 != 1) {
					if($4 != get_type($10))
						err("variable and literal must be of the same type");
						
					if(get_type($<i>10) == INT){
						code("\n\t\tADDS\t");
						gen_sym_name(idx);
						code(",$%d,", atoi(get_name($<i>10)));
						gen_sym_name(idx);
					}
					else{
						code("\n\t\tADDU\t");
						gen_sym_name(idx);
						code(",$%d,", atoi(get_name($<i>10)));
						gen_sym_name(idx);
					}
				}
				else{
				
					if(get_type(idx) == INT){
						code("\n\t\tADDS\t");
						gen_sym_name(idx);
						code(",$1,");
						gen_sym_name(idx);
					}
					else{
						code("\n\t\tADDU\t");
						gen_sym_name(idx);
						code(",$1,");
						gen_sym_name(idx);
					}
				
				}
				
				code("\n\t\tJMP\t\t@for%d", $<i>3);
				code("\n@exit%d:", $<i>3);
			
			level--;
		}
	;

//INCREMENT ISKAZ
increment_statement
	: _ID _POSTINC _SEMICOLON
			{	
				int index = lookup_symbol($1, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			} else if (index < fun_idx){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			}
  				
  				
				if(get_type(index) == INT){
					code("\n\t\tADDS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
				else{
					code("\n\t\tADDU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
  		}
  | _POSTINC _ID _SEMICOLON
  	{	
				int index = lookup_symbol($2, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			} else if (index < fun_idx){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			}
  				
				if(get_type(index) == INT){
					code("\n\t\tADDS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
				else{
					code("\n\t\tADDU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
  		}
	;
	
decrement_statement
	: _ID _POSTDEC _SEMICOLON
			{	
				int index = lookup_symbol($1, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			} else if (index < fun_idx){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			}
  				
  				
				if(get_type(index) == INT){
					code("\n\t\tSUBS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
				else{
					code("\n\t\tSUBU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
  		}
  | _POSTDEC _ID _SEMICOLON
			{	
				int index = lookup_symbol($2, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			} else if (index < fun_idx){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			}
  				
				if(get_type(index) == INT){
					code("\n\t\tSUBS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
				else{
					code("\n\t\tSUBU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
				}
  		}
	;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
				if(idx == NO_INDEX){
  				idx = lookup_symbol($1, GVAR);
  				if(idx == NO_INDEX)
  					err("invalid lvalue '%s' in assignment", $1);
  			} else if (idx < fun_idx){
  				idx = lookup_symbol($1, GVAR);
  				if(idx == NO_INDEX)
  					err("invalid lvalue '%s' in assignment", $1);
  			}
				else if(get_type(idx) != get_type($3)){
						err("incompatible types in assignment");
				}
				else
					if(get_type(idx) != get_type($3))
						err("incompatible types in assignment");
				
						gen_mov($3, idx);
      }
  ;
 
num_exp
  : exp
  	{ $$ = $1;}
  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3)) {
          err("invalid operands: arithmetic operation");
        }
        else{
		      int t1 = get_type($1);
		      code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
		      gen_sym_name($1);
		      code(",");
		      gen_sym_name($3);
		      code(",");
		      
		      free_if_reg($3);
		      free_if_reg($1);
		      
		      $$ = take_reg();
		      gen_sym_name($$);
		      set_type($$, t1);
        }
      }
  ;

exp
  : literal
  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX){
        	$$ = lookup_symbol($1, GVAR);
        	if($$ == NO_INDEX)
          	err("'%s' undeclared", $1);
        }
        else if($$ < fun_idx){
        	$$ = lookup_symbol($1, GVAR);
        	if($$ == NO_INDEX)
          	err("'%s' undeclared", $1);
        }
      }
  | function_call
  		{
  			$$ = take_reg();
        gen_mov(FUN_REG, $$);
  		}
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  | _ID _POSTINC 
  		{	
  			int index = lookup_symbol($1, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			} else if (index < fun_idx){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			}
          
        $$ = take_reg();
        
        gen_mov(index, $$);
        
       	if(get_type(index) == INT){  
       	 	code("\n\t\tADDS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
			 	else{
			 		code("\n\t\tADDU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
  		}
  | _POSTINC _ID 
  		{	
  			int index = lookup_symbol($2, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			} else if (index < fun_idx){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			}
          
        $$ = take_reg();
        
        gen_mov(index, $$);
        
       	if(get_type(index) == INT){  
       	 	code("\n\t\tADDS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
			 	else{
			 		code("\n\t\tADDU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
  		}
  | _ID _POSTDEC
  		{	
  			int index = lookup_symbol($1, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			} else if (index < fun_idx){
  				index = lookup_symbol($1, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $1);
  			}
          
        $$ = take_reg();
        
        gen_mov(index, $$);
        
       	if(get_type(index) == INT){  
       	 	code("\n\t\tSUBS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
			 	else{
			 		code("\n\t\tSUBU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
  		}
  | _POSTDEC _ID
  		{	
  			int index = lookup_symbol($2, VAR|PAR);
  			
  			if(index == NO_INDEX){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			} else if (index < fun_idx){
  				index = lookup_symbol($2, GVAR);
  				if(index == NO_INDEX)
  					err("variable '%s' undeclared", $2);
  			}
          
        $$ = take_reg();
        
        gen_mov(index, $$);
        
       	if(get_type(index) == INT){  
       	 	code("\n\t\tSUBS\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
			 	else{
			 		code("\n\t\tSUBU\t");
					gen_sym_name(index);
					code(",$1,");
					gen_sym_name(index); 
			 	}
  		}
  |	_LPAREN rel_exp _RPAREN _QUESTION conditional_exp _COLON conditional_exp
  		{
  			int reg = take_reg();
  			lab_num++;
  			
  			if(get_type($5) != get_type($7))
  				err("expressions must be of the same type");
  				
  			code("\n\t\t%s\t@false%d", opp_jumps[$2], lab_num);
  			
        code("\n@true%d:", lab_num);
        gen_mov($5, reg);
        
        code("\n\t\tJMP \t@exit%d", lab_num);
       
        code("\n@false%d:", lab_num);
        gen_mov($7, reg);
        
        code("\n@exit%d:", lab_num);
        $$ = reg;
        
  		}
  ;
  
conditional_exp
	: _ID
		{
			$$ = lookup_symbol($1, VAR|PAR|GVAR);
			if($$ == NO_INDEX)
				err("'%s' undeclared", $1);
		}
	| literal
	;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
    _LPAREN { args = 0; } argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $5)
          err("wrong number of args to function '%s'", 
              get_name(fcall_idx));
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($5 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $5 * 4);
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

//POZIV VOID FUNKCIJE
void_function_call
	: function_call _SEMICOLON
		{
			if(get_type(fcall_idx) != VOID)
				err("function '%s' is not of type void!", get_name(fcall_idx));
		}
	;

argument
  : /* empty */
    { $$ = 0; } //trenutni broj argumenata
  | multiple_args
  	{ $$ = args; }
 	;
  
multiple_args
  : num_exp
    { 
    	args++;
      if(get_type(fcall_idx + args) != get_type($1)) //posto su parametri sacuvani u tabeli, args ce biti jednak broju parametara ispod funkcije u tabeli
        err("incompatible type for argument in '%s'",
            get_name(fcall_idx));
      
      code("\n\t\t\tPUSH\t");
      gen_sym_name($1);
      free_if_reg($1);
   
      $$ = args; //broj argumenata se poveca
    }
  | multiple_args _COMMA num_exp 
  	{
  		args++;
  		if(get_type(fcall_idx + args) != get_type($3))
        err("incompatible type for argument in '%s'",
            get_name(fcall_idx));
     
      code("\n\t\t\tPUSH\t");
      gen_sym_name($3);
      free_if_reg($3);
      $$ = args; //opet se povecava broj argumenata
  	}
  ;

if_statement
  : if_part %prec ONLY_IF
  		{ code("\n@exit%d:", $1); }
  | if_part _ELSE statement
  		{ code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN 
  		{
        $<i>$ = ++lab_num;
        code("\n@if%d:", lab_num);
  		}
  	rel_exp_or
  		{
				if(or_count == 0 && and_count == 0)
					code("\n\t\t%s\t@false%d_if%d", opp_jumps[$4], lab_or, lab_num);
			
  			code("\n@last_or%d:\t", $<i>3);
  			if(or_count != 0)
  				code("\n\t\tJMP \t@false%d_if%d", lab_or, $<i>3);
        code("\n@true%d:", $<i>3);
  		}
  	_RPAREN statement
  		{
  			code("\n\t\tJMP \t@exit%d", $<i>3);
        code("\n@false%d_if%d:", lab_or, $<i>3);
        $$ = $<i>3;
        or_count = 0;
        and_count = 0;
  		}
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
        $$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
        gen_cmp($1, $3);
      }
  ;

rel_exp_and
	: rel_exp
	| rel_exp_and 
		{ 
			$<i>$ = ++lab_and; 
			code("\n\t\t%s\t@false%d_if%d", opp_jumps[$1], lab_or, lab_num);
		} 
	_AND { ++and_count;} rel_exp
		{
			code("\n\t\t%s\t@false%d_if%d", opp_jumps[$5], lab_or, lab_num);
			code("\n\t\tJMP \t@true%d", lab_num);
		}
	;
	
rel_exp_or
	: rel_exp_and
	| rel_exp_or 
		{ 
			if(or_count == 0)
				code("\n\t\t%s\t@true%d", jumps[$1], lab_num);
			
			code("\n@false%d_if%d:", lab_or, lab_num);
			$<i>$ = ++lab_or; 
		} 
	_OR {++or_count;} rel_exp_and
		{	
			code("\n\t\t%s\t@true%d", jumps[$5], lab_num);
			
			//code("\n\t\t%s\t@false%d", opp_jumps[$5], $<i>2);
				
		}

return_statement
  : _RETURN num_exp _SEMICOLON
      {
      	if(get_type(fun_idx) == VOID)
      		err("function is of type void and can't have a return value!");
      		
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
          
        return_count++;
        
        gen_mov($2, FUN_REG);
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx)); 
      }
  | _RETURN _SEMICOLON	//DRUGI MOGUCI OBLIK ZA RETURN
  		{	
  			if(get_type(fun_idx) != VOID)
  				warn("function is not of type void and needs a return value!");
  				
  			return_count++;
  		}	
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

