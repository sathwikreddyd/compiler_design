"""
    @author: Sathwik Reddy
    @version: 0.1
    @date: 04-16-2023
    @Comment: Initial grammar rules

    @author: Srilakshmi Sravani Andaluri
    @version: 0.2
    @date: 04-16-2023
    @Comment: Added Arithmetic operations and precedence rules

    @author: Vamsi Krishna Someapalli
    @version: 0.3
    @date: 04-18-2023
    @Comment: Updated grammar and added comparision grammar

    @author: Saish
    @version: 0.4
    @date: 04-21-2023
    @Comment: updated grammar and added terminal conditions

    @author: Rohith Reddy
    @version: 1.0
    @date: 04-19-2023
    @Comment: Generated tree from grammar

"""
import lark

def parser_hy(program):
    p = lark.Lark(

    r'''

    program : BEG block END

    block : CBO command CBC

    command :   statement command
                | statement

    statement : print_statement SC
                | assignment_statement SC
                | declaration_statement SC
                | for_loop
                | while_loop
                | if_condition
                | ternary_operation

    print_statement :   PRINT PO var PC

    assignment_statement :  declaration_statement EQ expression
                            | var EQ expression

    declaration_statement : data_type var

    for_loop :  FOR PO assignment_statement SC compare_operations SC assignment_statement PC block
                | FOR PO var IN RANGE PO arithmetic_operation COM arithmetic_operation PC PC block

    while_loop :    WHILE PO compare_operations PC block

    if_condition :  IF PO compare_operations PC block
                    | IF PO compare_operations PC block ELSE block

    expression :    boolean
                    | string_literal
                    | arithmetic_operation

    arithmetic_operation :  arithmetic_operation1 ADDITION arithmetic_operation
                            | arithmetic_operation1 SUBTRACTION arithmetic_operation
                            | arithmetic_operation1

    arithmetic_operation1 : arithmetic_operation2 MULTIPLICATION arithmetic_operation1 
                            | arithmetic_operation2 DIVISION arithmetic_operation1 
                            | arithmetic_operation2 PERCENTAGE arithmetic_operation1
                            | arithmetic_operation2

    arithmetic_operation2 : PO arithmetic_operation PC
                            | NUMBER 
                            | var

    compare_operations :    compare_statement LOGICAL_OPERATOR compare_operations
                            | compare_statement

    compare_statement :     arithmetic_operation COMPARISON_OPERATOR arithmetic_operation
                            | NOT compare_statement


    ternary_operation : compare_operations QUE block COL block

    COMPARISON_OPERATOR:    "<" 
                            | "<="
                            | ">" 
                            | ">=" 
                            | "==" 
                            | "!=" 
    
    LOGICAL_OPERATOR :      "and"
                            | "or" 

    boolean :   TRUE
                | FALSE

    NUMBER :    /[+-]?\d+/

    data_type : INTEGER
                | BOOL
                | STRING


    INTEGER :   "int"
    BOOL    :   "bool"
    STRING  :   "str"
    BEG : "begin"
    END : "end"
    NOT : "not"
    ADDITION : "+"
    SUBTRACTION : "-"
    DIVISION : "/"
    MULTIPLICATION : "*"
    PERCENTAGE : "%"
    EQ : "="
    SC : ";"
    CBO : "{"
    CBC : "}"
    PO : "("
    PC : ")"
    QUE : "?"
    COL : ":"
    DQO : "'"
    DQC : "'"
    IF : "if"
    ELSE : "else"
    IN : "in"
    FOR : "for"
    PRINT : "print"
    TRUE : "true"
    FALSE : "false"
    COM : ","
    RANGE : "range"
    WHILE : "while"
    
    var :   VARIABLE_NAME
    
    string_literal :    /"(\\.|[^\\"])*"/

    %import common.WORD -> VARIABLE_NAME

    
    WHITE : /\s+(?=([^\"]*[\"][^\"]*[\"])*[^\"]*$)/
    %ignore WHITE

    ''',
    parser = 'lalr',
    start = 'program'
    )

    return str(p.parse(program))

def progaram_parser(program):

    tree = parser_hy(program)

    return tree
