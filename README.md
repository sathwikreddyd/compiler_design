# Compiler Design

# Albitor - Code your way

# Authors - Sathwik Reddy Dontham, Saish Vemulapalli, Rohith Reddy Byreddy, Srilakshmi Sravani Andaluri, Vamsi Krishna Somepalli

**Albitor Programming Language**

Albitor is a programming language designed for easy syntax and efficient execution. This documentation provides an overview of the language's features, implementation details, and usage examples.

### Features

- **Syntax**: Albitor has a simple and intuitive syntax, making it easy to write and understand programs.
- **Lexical Analysis**: The language employs a lexical analyzer to break down programs into tokens, identifying elements such as data types, variables, and operators.
- **Parsing**: Albitor uses a parser to perform syntax analysis and generate parse trees, ensuring correct program structure and identifying any grammatical errors.
- **Evaluation**: The parse tree is then utilized to evaluate the program, ensuring semantic accuracy and executing required calculations.
- **Data Types**: Albitor supports string, integer, and boolean data types, providing flexibility for various programming tasks.
- **Control Structures**: The language includes conditional statements (if-else), loops (for, while), and ternary operators for efficient flow control.
- **Arithmetic Operations**: Albitor supports basic arithmetic operations such as addition, subtraction, multiplication, division, and modulus.
- **Input/Output**: The language allows printing output using the `print` statement, facilitating interaction with users.

### Implementation

- **Grammar Definition**: The grammar rules for Albitor were defined to establish precise syntax and structure.
- **Token Generation**: Python and Lark were used to generate tokens from the grammar rules, breaking down programs into manageable units for evaluation.
- **Evaluation Logic**: Prolog was employed to establish semantic relationships between grammar elements and evaluate program logic.
- **Testing**: The language was tested against various test programs to ensure functionality and correctness.
- **Contributions**: The development process involved collaboration from team members, each contributing to different aspects such as grammar design, parsing, evaluation, testing, and documentation.

### Usage Examples

Sample Albitor programs demonstrate the language's capabilities, including:

- Ternary operator usage
- Arithmetic operations
- Looping constructs (for, while)
- Conditional statements (if-else)
- Logical operations (AND, OR, NOT)

### Getting Started

To use Albitor, follow these steps:

Directions/instructions to install your language

- Prerequisities: Python3, SWI-Prolog
- You need to run the codes from your command line
- clone this repository: https://github.com/RohithReddyByreddy/SER502-Spring2023-Team27
- run command "pip install lark-parser" in cli

Directions/instructions to build and run your language (compiler/runtime).

- Go To command line interface and move to the src directory
- To compile and run the program
  - sh Albitor.sh <path to the program file>
  - Extension to the program file name should be .albi
  - Program should be given as per the grammer defined.

Tools used

- Python3 ,Lark-parser, SWI-Prolog
