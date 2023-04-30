%%
%This is evaluator for the language, takes the parse tree as input and prints the results.
%@author  : Vamsi Krishna Somepalli
%@version : 0.1
%@date    : 04-25-2023
%@comment : This is the initial version of the evaluator file
%
%@author  : Srilakshmi Sravani Andaluri
%@version : 0.2
%@date    : 04-26-2023
%@comment : Added evaluations till Compare Operations
%
%@author  : Sathwik Reddy
%@version : 0.3
%@date    : 04-28-2023
%@comment : Added all the remaining evaluations for boolean, ternary and terminating statements
%
%@author  : Saish Vemulapally
%@version : 0.4
%@date    : 04-28-2023
%@comment : Added evaluations for if conditions
%
%@author  : Rohith Reddy
%@version : 0.5
%@date    : 04-28-2023
%@comment : Added Loops and fixes to the existing code
%
%@author  : Sravani, Vamsi, Sathwik, Rohith, Saish
%@version : 1.0
%@date    : 04-29-2023
%@comment : Final working version of evaluations with all the fixes.
%%
:- discontiguous eval_for_loop/3.
:- discontiguous eval_compare_statement/4.
run_program(P):- eval_program(P, []).

% Predicate for evaluating the program.
eval_program(tree(program,[_,Block,_]), InitialEnv):- eval_block(Block,InitialEnv, _EnvRes).

% Predicate for evaluating the block.
eval_block(tree(block,[_,Cmd,_]), Env, EnvRes):- eval_command(Cmd, Env, EnvRes).

% Predicate for evaluating the command.
eval_command(tree(command,[Stmt,Cmd]),Env, EnvRes):- eval_statement(Stmt,Env, EnvTemp), eval_command(Cmd,EnvTemp, EnvRes).
eval_command(tree(command,[Stmt]), Env, EnvRes):- eval_statement(Stmt, Env, EnvRes).

% Predicate for evaluating statement.
eval_statement(tree(statement,[Print_stmt,_]), Env, EnvRes):- eval_print_statement(Print_stmt, Env, EnvRes).
eval_statement(tree(statement,[Assignment_stmt,_]), Env, EnvRes):- eval_assignment_statement(Assignment_stmt, Env, EnvRes).
eval_statement(tree(statement,[Declaration_stmt]), Env, EnvRes):- eval_declaration_statement(Declaration_stmt, Env, EnvRes).
eval_statement(tree(statement,[For_loop]), Env, EnvRes):- eval_for_loop(For_loop, Env, EnvRes).
eval_statement(tree(statement,[While_loop]), Env, EnvRes):- eval_while_loop(While_loop, Env, EnvRes).
eval_statement(tree(statement,[If_condition]), Env, EnvRes):- eval_if_condition(If_condition, Env, EnvRes).
eval_statement(tree(statement,[Ternary_operation]), Env, EnvRes):- eval_ternary_operation(Ternary_operation, Env, EnvRes).

% Predicate for evaluating Print statement.
eval_print_statement(tree(print_statement,[_,_,Var,_]),Env,Env) :-
    eval_var(Var, Env, Var1),
    search(Var1, Env, X),
    write(X),nl.

% Predicate for evaluating Assignment statement.
eval_assignment_statement(tree(assignment_statement,[Declaration_stmt,_,Expr]),Env, EnvRes):-
    eval_declaration_statement(Declaration_stmt,Env, Env1),
    eval_expression(Expr,Env, Env2, Value),
    assign(Env1, Value, Env2, EnvRes).
    
eval_assignment_statement(tree(assignment_statement,[Var,_,Expr]),Env, EnvRes):-
    eval_var(Var,Env, Env1),
    eval_expression(Expr,Env, Env, Value),
    assign(Env1, Value, Env, EnvRes).

% Predicate for evaluating Declaration statement.
eval_declaration_statement(tree(declaration_statement,[_Data_type, Var]),Env, EnvRes):-
    eval_var(Var, Env, EnvRes).

% Predicate for evaluating for loop.
eval_for_loop(tree(for_loop,[token(_FOR,'for'),_,Assignment_stmt,_,Compare_operations,_, Assignment_stmt_1,_,Block]), Env, EnvRes) :-
    eval_assignment_statement(Assignment_stmt, Env, Env1),
    eval_for_loop1(Compare_operations, Assignment_stmt_1, Block, Env1, EnvRes).

eval_for_loop1(Compare_operations, Assignment_stmt, Block, Env, EnvRes) :-
    eval_compare_operations(Compare_operations, Env, Env1, true),
    eval_block(Block, Env1, Env2),
    eval_assignment_statement(Assignment_stmt, Env2, Env3),
    eval_for_loop1(Compare_operations, Assignment_stmt, Block, Env3, EnvRes).
eval_for_loop1(Compare_operations, _Assignment_stmt, _Block, Env, Env) :-
    eval_compare_operations(Compare_operations, Env, Env, false).


eval_for_loop(tree(for_loop,[token(_FOR,'for'),_,Var,token(_IN,'in'),token(_RANGE,'range'),_,Number,_,Number_1,_,_,Block]),Env,EnvRes):-
    eval_var(Var,Env,Var1),
    eval_arithmetic_operation(Number,Env,Env1,Value),
    assign(Var1,Value,Env1,Env2),
    eval_for_loop2(Var1, Number_1, Block, Env2, EnvRes).

eval_for_loop2(Var, Number, Block, Env, EnvRes) :-
    search(Var, Env, Val1),
    eval_arithmetic_operation(Number, Env, _EnvT, Val2),
    Val1 < Val2,
    eval_block(Block, Env, Env1),
    Val3 is Val1 + 1,
    assign(Var, Val3, Env1, Env2),
    eval_for_loop2(Var, Number, Block, Env2, EnvRes).

eval_for_loop2(Var, Number, _, Env, EnvRes) :-
    search(Var, Env, Val1),
    eval_arithmetic_operation(Number, Env, EnvRes, Val2),
    Val1 >= Val2.

% Predicate for evaluating while loop.
eval_while_loop(tree(while_loop,[token(WHILE,'while'),_,Compare_operations,_,Block]), Env, EnvRes):-
    eval_compare_operations(Compare_operations, Env, Env1, true),
    eval_block(Block, Env1, Env2),
    eval_while_loop(tree(while_loop,[token(WHILE,'while'),_,Compare_operations,_,Block]),  Env2, EnvRes).

eval_while_loop(tree(while_loop,[token(_WHILE,'while'),_,Compare_operations,_,_]), Env, Env):-
    eval_compare_operations(Compare_operations, Env, _Env1, false).

% Predicate for evaluating if block.

% only if true
eval_if_condition(tree(if_condition, [token(_IF,'if'),_,Compare_operations,_,Block]), Env, EnvRes) :-
    eval_compare_operations(Compare_operations, Env, _Env1, true),
    eval_block(Block, Env, EnvRes).

% if-else true
eval_if_condition(tree(if_condition, [token(_IF,'if'),_,Compare_operations,_,Block,token(_ELSE,'else'),_]), Env, EnvRes) :-
    eval_compare_operations(Compare_operations, Env, _Env1, true),
    eval_block(Block, Env, EnvRes).

% if-else false
eval_if_condition(tree(if_condition, [token(_IF,'if'),_,Compare_operations,_,_,token(_ELSE,'else'),Block]), Env, EnvRes) :-
    eval_compare_operations(Compare_operations, Env, _Env1, false),
    eval_block(Block, Env, EnvRes).


% Predicate for evaluating expression.
eval_expression(tree(expression,[Boolean]), Env, EnvRes, Value):-
    eval_boolean(Boolean, Env, EnvRes, Value).

eval_expression(tree(expression,[String_literal]), Env, EnvRes, Value):- 
    eval_string_literal(String_literal, Env, EnvRes, Value).

eval_expression(tree(expression,[Arithmetic_operation]), Env, EnvRes, Value):-
    eval_arithmetic_operation(Arithmetic_operation, Env, EnvRes, Value).


% Predicate used for evaluating the expression for addition and subtraction.
eval_arithmetic_operation(tree(arithmetic_operation,[Arithmetic_operation1,token(_ADDITION,'+'),Arithmetic_operation]), Env,Env, Answer):-
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1),
    eval_arithmetic_operation(Arithmetic_operation, Env, Env1, Value2),
    Answer is Value1 + Value2.

eval_arithmetic_operation(tree(arithmetic_operation,[Arithmetic_operation1,token(_SUBTRACTION,'-'),Arithmetic_operation]), Env,EnvRes, Answer):-
    eval_arithmetic_operation(Arithmetic_operation1, Env, EnvTemp, Value1),
    eval_arithmetic_operation(Arithmetic_operation, EnvTemp, EnvRes, Value2),
    Answer is Value1 - Value2.

eval_arithmetic_operation(tree(arithmetic_operation,[Arithmetic_operation1]), Env,EnvRes, Answer):-
    eval_arithmetic_operation(Arithmetic_operation1, Env, EnvRes, Value1),
    Answer is Value1.


% Predicate used for evaluating the expression for multiplication, division and percentage.
eval_arithmetic_operation(tree(arithmetic_operation1,[Arithmetic_operation2,token(_MULTIPLICATION,'*'),Arithmetic_operation1]), Env,EnvRes, Answer):-
    eval_arithmetic_operation(Arithmetic_operation2, Env, EnvTemp, Value1),
    eval_arithmetic_operation(Arithmetic_operation1, EnvTemp, EnvRes, Value2),
    Answer is Value1 * Value2.

eval_arithmetic_operation(tree(arithmetic_operation1,[Arithmetic_operation2,token(_DIVISION,'/'),Arithmetic_operation1]), Env,EnvRes, Answer):-
    eval_arithmetic_operation(Arithmetic_operation2, Env, EnvTemp, Value1),
    eval_arithmetic_operation(Arithmetic_operation1, EnvTemp, EnvRes, Value2),
    Answer is Value1 / Value2.

eval_arithmetic_operation(tree(arithmetic_operation1,[Arithmetic_operation2,token(_PERCENTAGE,'%'),Arithmetic_operation1]), Env,EnvRes, Answer):- 
    eval_arithmetic_operation(Arithmetic_operation2, Env, EnvTemp, Value1),
    eval_arithmetic_operation(Arithmetic_operation1, EnvTemp, EnvRes, Value2),
    Answer is Value1 mod Value2.

eval_arithmetic_operation(tree(arithmetic_operation1,[Arithmetic_operation2]), Env,EnvRes, Answer):-
    eval_arithmetic_operation(Arithmetic_operation2, Env, EnvRes, Value1),
    Answer is Value1.

% Predicate used for evaluating arithmetic operation2.
eval_arithmetic_operation(tree(arithmetic_operation2,[_,Arithmetic_operation,_]), Env, EnvRes, Value):- 
    eval_arithmetic_operation(Arithmetic_operation, Env, EnvRes, Val1),
    Value is Val1.

% Predicate used for evaluating number
eval_arithmetic_operation(tree(arithmetic_operation2, [token(_NUMBER,Val)]), Env,Env, Value):-
    atom_number(Val,Value).
eval_arithmetic_operation(tree(arithmetic_operation2, [Var]), Env, Env, Value):-
    eval_var(Var, Env, Var1),
    search(Var1, Env, Value).
eval_string_literal(tree(string_literal, [token(_,String)]), Env, Env, String).

% Predicate for compare_operations
eval_compare_operations(tree(compare_operations, [Compare_stmt, token(_LOGICAL_OPERATOR, 'and'), Compare_operations]), Env, EnvRes, true) :-
    eval_compare_statement(Compare_stmt, Env, Env1, true),
    eval_compare_operations(Compare_operations, Env1, EnvRes, true).

eval_compare_operations(tree(compare_operations, [Compare_stmt, token(_LOGICAL_OPERATOR, 'and'), Compare_operations]), Env, EnvRes, false) :-
    not(eval_compare_statement(Compare_stmt, Env, _Env1, true));
    (eval_compare_operations(Compare_operations, _Env1, EnvRes, false)).

% Logical OR operator
eval_compare_operations(tree(compare_operations, [Compare_stmt, token(_LOGICAL_OPERATOR, 'or'), Compare_operations]), Env, EnvRes, true) :-
    (eval_compare_statement(Compare_stmt, Env, _Env1,true);
     eval_compare_operations(Compare_operations, _Env1, EnvRes,true)).

eval_compare_operations(tree(compare_operations, [Compare_stmt, token(_LOGICAL_OPERATOR, 'or'), Compare_operations]), Env, EnvRes, false) :-
    not(eval_compare_statement(Compare_stmt, Env, Env1,true)),
    eval_compare_operations(Compare_operations, Env1, EnvRes,false).


% Predicate for single compare operation
eval_compare_operations(tree(compare_operations, [Compare_stmt]), Env, EnvRes, true) :-
    eval_compare_statement(Compare_stmt, Env, EnvRes,true).

eval_compare_operations(tree(compare_operations, [Compare_stmt]), Env, EnvRes, false) :-
    not(eval_compare_statement(Compare_stmt, Env, EnvRes,true)).


% Predicate used for evaluating compare statement.
eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'>'),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env1, EnvRes, Value2),
    Value1 > Value2.

eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'<'),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env1, EnvRes, Value2),
    Value1 < Value2.

eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'>='),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env1, EnvRes, Value2),
    Value1 >= Value2.

eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'<='),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env1, EnvRes, Value2),
    Value1 =< Value2.

eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'=='),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env1, EnvRes, Value2),
    Value1 = Value2.

eval_compare_statement(tree(compare_statement, [Arithmetic_operation1,token(_COMPARISON_OPERATOR,'!='),Arithmetic_operation2]),Env, EnvRes, true):- 
    eval_arithmetic_operation(Arithmetic_operation1, Env, _Env1, Value1), 
    eval_arithmetic_operation(Arithmetic_operation2, Env, EnvRes, Value2),
    Value1 \= Value2.


% Predicate used for evaluating compare statement.
eval_compare_statement(tree(compare_statement,[Var]),Env, EnvRes) :- 
    eval_var(Var,Env, EnvRes).
eval_compare_statement(tree(compare_statement,[Number]),Env, EnvRes) :-
    eval_number(Number,Env, EnvRes).
eval_compare_statement(tree(compare_statement,[_,_Arithmetic_operation,_]),Env, EnvRes) :-
    eval_var(_Var,Env, EnvRes).

eval_compare_statement(tree(compare_statement,[token(_NOT,'not'), Compare_stmt]), Env, EnvRes, true) :-
    not(eval_compare_statement(Compare_stmt, Env, EnvRes, true)).

eval_compare_statement(tree(compare_statement,[token(_NOT,'not'), Compare_stmt]), Env, EnvRes, false) :-
    eval_compare_statement(Compare_stmt, Env, EnvRes, true).

% Predicate used for evaluating Ternary Operation.
eval_ternary_operation(tree(ternary_operation,[Compare_operations,_,Block,_,_]),Env,EnvRes):- 
    eval_compare_operations(Compare_operations, Env, _EnvTemp, true),
    eval_block(Block, Env, EnvRes).

eval_ternary_operation(tree(ternary_operation,[Compare_operations,_,_,_,Block]),Env,EnvRes):- 
    eval_compare_operations(Compare_operations, Env, _EnvTemp, false),
    eval_block(Block, Env, EnvRes).

%Predicate to evaluate boolean.
eval_boolean(tree(boolean,[token(_TRUE,'true')]),Env,Env,true).
eval_boolean(tree(boolean,[token(_FALSE,'false')]),Env,Env,false).

%Predicate to evaluate number and var
eval_number(tree(number,[Number]),_, Number).
eval_var(tree(var,[token(_VARIABLE_NAME, Var)]),_, Var).

% assign identifiers with values
assign(A, B, [], [(A, B)]).
assign(A, B, [(A, _)|C], [(A, B)|C]).
assign(A, B, [H|T], [H|U]) :-
    H \= (A, _),
    assign(A, B, T, U).

% lookup for a value in variable set
search(A, [(A,B)|_], B).
search(A, [_|B], C) :- search(A, B, C).
