#import "@preview/cetz:0.2.2"
#import "template.typ": *

#show: project


= CS19003: Programming and Data Structures Lab [Autumn 2024-25]

- Course Website: 

- Instructor: Prof. Pralay Mitra


#dated(datetime(year: 2024, month: 8, day: 6))

== Basic UNIX Commands

#let data = (
  "passwd": [change password],
  "pwd": [print current working directory],
  "ls": [list files in current directory
  - `-l`: display in long format
  - `-a`: display hidden files],
  "cd [path]": [change directory to given path
  - `cd ..`: move to parent directory
  - `cd`: move to home directory
  - `cd /`: move to root directory],
  "mkdir [dir]": [create a new directory],
  "gedit [file]": [open a file in text editor],
  "rm [file]": [delete a file],
  "rm -r [dir]": [delete a directory recursively],
  "cp [src] [dest]": [copy a file],
  "cp -r [src] [dest]": [copy a directory recursively],
  "mv [src] [dest]": [move a file],
  "cat [file]": [display contents of a file],
  "cat [file] >> [dest_file]": [append contents of a file to another file],
  "touch [file]": [create an empty file],
  "head [file]": [display first 10 lines of a file],
  "tail [file]": [display last 10 lines of a file],
  "wc [file]": [display word count of a file
  - `-l`, `-w`, `-c`: display lines, words, characters respectively],
  "chmod +x": [add execution permissions to a file],
  "ln -s [filename] [link_name]": [create a symbolic link having alias `link_name`],
  "tar -czvf [archive.tar.gz] [file/directory]": [compress directory to a tarball with name archive.tar.gz],
  "tar -xzvf [archive.tar.gz]": [extract compressed folder],
)

#table(columns: (0.7fr, 1fr), ..for (k, v) in data.pairs() {
  (raw(k), v)
})

== Writing the first C program

Using the command `gedit hello.c`, we can open a text editor to write a C program. The following is a simple program to
print "Hello, World!".

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

`printf` is a function in C to print a message to the output. The `\n` character is used to print a newline character at
the end of the message, so that anything printed after this will be on a new line.

To compile the program, the `gcc` compiler is used. 

```bash
gcc hello.c
```

`gcc` compiles (converts) our source code in the file `hello.c` into machine code. This machine code is stored in a file
called `a.out` by default. This file is called an "executable file", because it can be directly executed by the
computer. To run this file we can write:

```bash
./a.out
```

This will print the message "Hello, World!" to the terminal.

== Accepting User Input

To accept input from the user, we can use the `scanf` function. The following program reads an integer from the user and
prints it back.

```c
#include <stdio.h>

int main() {
    int num;
    scanf("%d", &num);
    printf("%d\n", num);
    return 0;
}
```

In this program, `scanf` reads an integer from the user and stores it in the variable `num`. Note that the second
argument passed to `scanf()` is `&num`, where the `&` operator is used to get the address of the variable `num`. `scanf`
needs to know the address of the memory location where it should store the value read from the user.

`%d` is called a format specifier. The following are a few of the format specifiers used in C:

- `%d`: integer 
- `%f`: float
- `%c`: character

These format specifiers are used to specify the type of data that `scanf` should read from the user. Also, they are used
in `printf` to specify the type of data that should be printed.

The program thus reads an integer from the user and prints the same back.

We can also check the memory address of a variable using the `&` operator.

```c
#include <stdio.h>

int main() {
    int ht;
    float wt;

    scanf("%d %f", &ht, &wt); // read integer and float from user

    printf("%d %d\n", &ht, ht); // print memory address and value of ht

    printf("%x %f\n", &wt, wt); // print memory address and value of wt
}
```

A sample output of this code, when the user enters `20`, and `4.5` is:

```
2018718112 20
785331a4 4.500000
```

Here, the `scanf` function reads an integer and a float from the user and stores them in the variables `ht` and `wt`
respectively. 

The first call to `printf` prints the memory address and value of `ht`. Note that both of these things are printed in
integer format (`%d`). So we see the memory address in decimal (`2018718112`) and the value of `ht` (`20`).

The second call to `printf` prints the memory address and value of `wt`. Here, the memory address is printed in
hexadecimal format (`%x`)#footnote[
Hexadecimal format is a base-16 number system. It uses the digits 0-9 and the letters A-F to represent numbers. It is
often used to represent memory addresses as it is more compact than decimal numbers. For example, the decimal number
`2018718112` is represented as `785331a4` in hexadecimal.
] and the value of `wt` is printed as a float (`%f`).

*Sidenote 1*: If you try to enter a different integer, it is possible that the memory address of `ht` is printed as a
negative number. This happens when the value of the memory address is too large to be stored in an integer within 2/4
bytes, and the value overflows to the negative side.

This can be fixed by using `%ld` instead of `%d` to print the memory address. `%ld` is used to print long integers.

```c
printf("%ld %d\n", &ht, ht);
```

*Sidenote 2*: Other than the `float` data type, there is also a `double` data type in C. The `double` data type has more
precision than the `float` data type. If it is used, the corresponding format specifier to be used is `%lf`.

```c
double wt;
scanf("%lf", &wt);
printf("%x %lf\n", &wt, wt);
```

*Sidenote 3*: Note that when printing the float/double value, 6 decimal places are printed by default. This can be
changed by modifying the format specifier. For example, to print 4 decimal places, use `%.4f` (or `%.4lf`).


== Typecasting

Consider the following program

```c
#include <stdio.h>

int main() {
  int a, b;
  float c;

  a = 10;
  b = 4;

  c = a / b;
  printf("%f\n", c);

  c = (float) a / b;
  printf("%f\n", c);

  c = (a * 1.0) / b;
  printf("%f\n", c);

  c = (float) (a/b);
  printf("%f\n", c);
}
```

The output of this program is: ```
2.000000
2.500000
2.500000
2.000000
```

In the first case, `a/b` is an integer division (as both the numbers `a` and `b` are integers), which results in `2`.
This is then assigned to `c`, which is a float variable.

In the second case, we typecast `a` to a float (by using the syntax `(float) a`), so the division is now a float
division, which results in `2.5`. (During division, if any of the operands is a float, we get float division.)

In the third case, we multiply `a` by `1.0` to convert it to a float, and then divide by `b`. This also results in
`2.5`.

In the fourth case, we first calculate `a/b` (which is `2`), and then typecast it to a float. So, `c` is assigned `2.0`.

