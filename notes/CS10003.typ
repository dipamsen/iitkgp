#import "template.typ": *

#show: project

= CS10003: Programming and Data Structures [Autumn 2024-25]

- Course Website: https://cse.iitkgp.ac.in/~soumya/pds-th/pds-th.html

- Additional Resources: https://cse.iitkgp.ac.in/pds/notes/

- Instructor: Prof. Pralay Mitra (Section 2)
- Course Coordinator: Prof. Soumyajit Dey

- Class Test Dates: Aug 28th, Oct 29th (7-8)

#dated(datetime(day: 5, month: 8, year: 2024))

Computer hardware is designed to "understand" certain sequences of 0s and 1s (binary code) as instructions, to perform
certain actions. 

When a user interacts with a computer, a third party software ("translator") is required to "translate" the user's
instructions (in a high-level language) into machine code. This software can be an _interpreter_ or a _compiler_.
- *Interpreter* converts high-level code to machine code line-by-line, executing each line immediately.
- *Compiler* converts high-level code to machine code all at once, and the machine code is executed later.

*Syntax* is the rules defining the allowable structure of a program. 

*Semantics* is the meaning of the program.

A program consists of various units. The smallest unit is a *token*, which is a sequence of characters that represents a
single unit of the program. Tokens can be keywords, identifiers, constants, operators, etc. A *statement* is an
instruction which is created by combining tokens. A *program* is a collection of statements.

*Problem Solving*
- Clearly specify the problem.
- Create a flowchart/algorithm.
- Convert it to a program.
- Compile the program.
- Execute the program.

#dated(datetime(day: 6, month: 8, year: 2024))

== Basic structure of a C program

The following program is a simple C program that prints "Hello, World!" on the screen.

```c
#include <stdio.h>
int main()
{
    printf("Hello, World!\n");
    return 0;
}
```

The program consists of the following elements:

- `#include <stdio.h>`: This line imports the library file `stdio.h` which contains the `printf()` function and other
  standard input/output functions.

- `int main()`: This is the main function of the program. The program execution starts from this function. The code inside
  the curly braces `{}` is the body of the function.

- `printf("Hello, World!\n");`: This line prints the string "Hello, World!" to the standard output (usually the screen).
  - The `\n` "escape sequence" is used to print a newline character. (Other escape sequences include `\t` for tab, `\\` for
    backslash, etc.)


== Compilation

We can compile the program using the `gcc` compiler. The command to compile the program is:

```bash
gcc program.c
```

`gcc` compiles our C code into machine code, which is stored in a file named `a.out` (this file is called an executable
file). To run the program, we can use the following command:

```bash
./a.out
```

To change the name of the output file, we can use the `-o` option: ```bash
gcc program.c -o program
./program
```

Steps of compilation:
1. The compiler compiles the source code and generates an object file. (`hello.o`)
2. The linker links the object file with the standard C library to generate an executable file. (`a.out`)

== Variables, Data types and input

A *variable* is a named memory location that stores a value. A *data type* specifies the type of data that a variable
can hold.

In C, the basic data types are:
- `int`: Integer (2/4 bytes, format specifier `%d`)
- `float`: Floating-point number (real number) (4 bytes, format specifier `%f`)
- `char`: Character (1 byte, format specifier `%c`)

To define a variable, you need to specify the data type and the variable name. For example: `int num;` creates a
variable of type `int` named `num`.

The `scanf` function is used to read input from the user. For example, the following program reads an integer from the
user and prints it:

```c
#include <stdio.h>
int main()
{
    int num;
    scanf("%d", &num);
    printf("%d\n", num);
    return 0;
}
```

In the `scanf` function, the `%d` format specifier is used to read an integer. The second argument passed to `scanf` is
`&num`, where the `&` operator is used to get the address of the variable `num`. This is required because `scanf` needs
to know the address of the memory location where the input should be stored. Thus, whatever value is entered by the user
will be stored in the variable `num`.

== Expressions and Operators

Arithmetic operators in C include `+`, `-`, `*`, `/`, `%`. Relational operators include `==`, `!=`, `>`, `<`, `>=`,
`<=`. Logical operators include `&&`, `||`, `!`.

Note that the `/` (division) operator performs integer division if both operands are integers. For example, `5 / 2` will
be `2`. To perform floating-point division, at least one of the operands should be a floating-point number. For example,
`5.0 / 2` will be `2.5`.

```c
#include <stdio.h>
int main()
{
    int a;

    scanf("%d", &a);

    a = a + 10;

    printf("%d\n", a);

    return 0;
}
```

The above program reads an integer from the user, adds 10 to it, and prints the result.

== Characters and Strings

A *character* is a single alphabet, digit, or special symbol enclosed within single quotes (`' '`). A *string* is a
sequence of characters enclosed within double quotes (`" "`).

So, `'A'` is a character, and `"Hello"` is a string. 

In terms of memory, a character occupies 1 byte, while a string occupies multiple bytes depending on the number of
characters. A string is terminated by a null character (`'\0'`), which is automatically added at the end of the string.
So, a string of length `n` occupies `n+1` bytes in memory.