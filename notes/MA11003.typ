#import "@preview/cetz:0.2.2"
#import "@preview/showybox:2.0.1": *
#import "@preview/ctheorems:1.1.2": *
#import "template.typ": *
#show: project


= MA11003: Advanced Calculus [Autumn 2024-25]

- Course Website: 

- Instructor: Prof. Mousumi Mandal

- Class Test Dates: 

#dated(datetime(year: 2024, month: 8, day: 7))

#showybox(
  title: "Food for thought",
)[
  Multivariable calculus deals with functions of more than one variable. Consider a function
   
  $
    f(x, y): RR^2 -> RR
  $
   
  In single variable calculus, limits are said to exist if the function approaches the same value, if the input approaches
  a certain value either from the left or the right.
   
  #grid(columns: (1fr, auto), $
    lim_(x->a) f(x) "exists iff" lim_(x->a^+) f(x) = lim_(x->a^-) f(x)
  $, cetz.canvas({
    import cetz.draw: *
     
    line((-1, 0), (1, 0))
    circle((0, 0), radius: 0.07, fill: black)
    content((0, 0), v(1mm) + [a], anchor: "north")
     
    mark((-1, 0), (-0.3, 0), symbol: "straight")
    mark((-1, 0), (-0.5, 0), symbol: "straight")
    mark((1, 0), (0.5, 0), symbol: "straight")
    mark((1, 0), (0.3, 0), symbol: "straight")
     
    content((1.3, 0), $RR$)
  }))
   
  However, if we have our domain in $RR^2$, and our input is a point $(x_0, y_0)$ on the domain, then there are infinitely
  many directions in which we can approach the point $(x_0, y_0)$!
   
  #grid(
    columns: (auto, 1fr),
    gutter: 1.5em,
    cetz.canvas({
      import cetz.draw: *
       
      line((-1, 0), (1, 0))
      line((0, -1), (0, 1))
       
      content((1.2, -0.7), $RR^2$)
       
      translate((0.6, 0.4))
       
      line((-0.7, 0), (0.7, 0), stroke: luma(160))
      line((0, -0.7), (0, 0.7), stroke: luma(160))
       
      mark((-1, 0), (-0.2, 0), symbol: "straight", scale: 0.7)
      mark((-1, 0), (-0.4, 0), symbol: "straight", scale: 0.7)
      mark((1, 0), (0.4, 0), symbol: "straight", scale: 0.7)
      mark((1, 0), (0.2, 0), symbol: "straight", scale: 0.7)
       
      mark((0, -1), (0, -0.2), symbol: "straight", scale: 0.7)
      mark((0, -1), (0, -0.4), symbol: "straight", scale: 0.7)
      mark((0, 1), (0, 0.4), symbol: "straight", scale: 0.7)
      mark((0, 1), (0, 0.2), symbol: "straight", scale: 0.7)
       
      circle((0, 0), radius: 0.07, fill: black)
      content((0, 0), h(1mm) + $(x_0, y_0)$ + v(2mm), anchor: "south-west")
    }, length: 1.2cm),
  )[
    In fact, there are infinitely many paths that can be taken to approach the point $(x_0, y_0)$, since the path followed
    can be any curve in the plane!
     
    So, how can we create a consistent definition of the limit for a function of two variables, which is independent of the
    path taken to approach the point?
  ]
   
  Another consequence of the existence of infinite directions, is that reaching $infinity$ can have many different
  meanings, as going away from the origin in $RR^2$ can be done in infinitely many directions!
]

Some basic theorems in Single Variable Calculus:

#theorem(
  name: "Extreme Value Theorem",
)[
  Let $f$ be a continuous function on a closed interval $[a, b]$. Then $f$ must attain a maximum and minimum each at least
  once. 
   
  i.e, $exists c, d in [a, b] st $$ f(c) <= f(x) <= f(d) forall x in [a, b] $
]

#theorem[
  If $f$ is continuous on $[a, b]$ and differentiable on $(a, b)$ and attains maxima or minima at some point $c in (a, b)$,
  then $f'(c) = 0$
]

#theorem(
  name: "Intermediate Value Theorem",
)[
  #grid(
    columns: (1fr, auto),
    [Let $f: [a, b] -> RR$ be continuous in $[a, b]$. Then, $forall u in [f(a), f(b)] exists c in [a, b] st f(c) = u $],
    cetz.canvas({
      import cetz.draw: *
      line((-0.2, 0), (1, 0))
      line((0, -0.2), (0, 1))
       
      let (a, b, c, d) = ((0.2, 0.15), (0.8, 0.8), (0.4, 1), (0.6, 0.2))
       
      line((0, 0.15), (1, 0.15), stroke: (dash: "dotted"))
      line((0, 0.8), (1, 0.8), stroke: (dash: "dotted"))
       
      line((0, 0.4), (1, 0.4), stroke: gray)
      line((0.29, 0), (0.29, 0.4), stroke: gray)
      bezier(a, b, c, d)
    }, length: 1.2cm),
  )
]

#theorem(
  name: "Rolle's Theorem",
)[
  #grid(columns: (1fr, auto), [Let $f: [a, b] -> RR$ be
    + continuous in $[a, b]$
    + differentiable in $(a, b)$
    + $f(a) = f(b)$
     
    Then, $exists c in (a, b) st f'(c) = 0$], cetz.canvas({
    import cetz.draw: *
    line((-0.2, 0), (1, 0)) 
    line((0, -0.2), (0, 1))
     
    let (a, b, c, d) = ((0.1, 0.5), (0.9, 0.5), (0.4, 1.2), (0.6, 0))
    bezier(a, b, c, d)
     
    line((0, 0.5), (1, 0.5), stroke: (dash: "dotted"))
    line((0.15, 0.73), (0.45, 0.73))
    line((0.6, 0.36), (0.85, 0.36))
  }, length: 2cm))
   
  Geometrically, it means that there exists a point $c in (a, b)$ where the tangent to the curve is parallel to the $x$-axis.
]

Applications of Rolle's Theorem:

#theorem(
  name: "Application 1",
)[
  If $p(x)$ is a polynomial of degree $n$ with $n$ real roots, then all the roots of $p'(x)$ are also real.
][
  *Proof*:
   
  Let the roots of $p(x)$ be $alpha_1 < alpha_2 < ... < alpha_n$.
   
  Then, $p(alpha_1) = p(alpha_2) = ... = p(alpha_n) = 0$.
   
  Applying Rolle's theorem in $[alpha_1, alpha_2]$, $[alpha_2, alpha_3]$, ..., $[alpha_(n-1), alpha_n]$, we get that in
  each of these $n-1$ intervals, there exists a point where $p'(x) = 0$.
   
  Hence, $p'(x)$ has $n-1$ real roots.
]

#question(
  title: [
    Q: Using Rolle's Theorem, show that $x^13 + 7 x^3 - 5 = 0$ has exactly one real root in $[0, 1]$.
  ],
)[
  Let $f(x) = x^13 + 7 x^3 - 5$.
   
  $f(0) = -5, f(1) = 0$, thus from the intermediate value theorem, there is at least one root in $[0, 1]$.
   
  Suppose that there exist more than one root in $[0, 1]$. Let any two of them be $alpha, beta$ with $alpha < beta$.
   
  Then, $f(alpha) = f(beta) = 0$. Applying Rolle's theorem in $[alpha, beta]$, we get that there exists a point $c in (alpha, beta)$ where $f'(c) = 0$.
   
  $
    f'(c) = 13 c^12 + 21 c^2 = 0
  $
   
  However, there exists no such $c in (alpha, beta)$ that satisfies the above equation.
   
  Hence, $f(x)$ has only one root in $[0, 1]$.
]

#question(
  title: [
    Q: Prove that if $a_0, a_1, ..., a_n$ are real numbers such that $a_0/(n+1) + a_1/n + ... + a_(n-1)/2 + a_n = 0$, then $exists x in (0, 1) st a_0 x^n + a_1 x^(n-1) + ... + a_(n-1) x + a_n = 0$.
  ],
)[
  Let $f(x) = a_0 x^n + a_1 x^(n-1) + ... + a_(n-1) x + a_n$.
   
  Let $F(x) = integral f(x) dif x = a_0 x^(n+1) / (n + 1) + a_1 x^(n) / (n ) + ... + a_(n-1) x^2 / 2 + a_n x$.
   
  $F(1) = a_0/(n+1) + a_1/n + ... + a_(n-1)/2 + a_n = 0$ (given). Also, $F(0) = 0$.
   
  Applying Rolle's theorem in $[0, 1]$ on $F(x)$, we get that there exists a point $c in (0, 1)$ where $F'(c) = 0$.
   
  Thus, $exists x in (0, 1) st f(x) = 0 $#h(1fr)$qed$
]

#theorem(
  name: "Lagrange's Mean Value Theorem",
)[ 
  #grid(columns: (1fr, auto), [If $f: [a, b] -> RR$ is
    1. continuous in $[a, b]$
    2. differentiable in $(a, b)$
    then $exists c in (a, b) st f'(c) = (f(b) - f(a)) / (b - a)$], cetz.canvas({
    import cetz.draw: *
    line((-0.2, 0), (1, 0)) 
    line((0, -0.2), (0, 1))
     
    let (a, b, c, d) = ((0.1, 0.2), (0.9, 0.6), (0.4, 1.2), (0.6, 0))
    bezier(a, b, c, d)
     
    line((0.1, 0.2), (0.9, 0.6), stroke: (dash: "dotted"))
    line((0.1, 0.5), (rel: (), to: (0.4, 0.2)))
    line((0.55, 0.33), (rel: (), to: (0.4, 0.2)))
  }, length: 2cm))
   
  Geometrically, it means that there exists a point $c in (a, b)$ where the tangent to the curve is parallel to the secant
  line.
][
  *Proof*:
   
  Let $g(x)$ be the equation of the secant line passing through $(a, f(a))$ and $(b, f(b))$.
   
  $g(x) - f(a) = (f(b) - f(a)) / (b - a) (x - a)$
   
  Consider the function $F(x) = f(x) - g(x)$.
   
  $F(a) = F(b) = 0$. (as $g(a) = f(a)$ and $g(b) = f(b)$)
   
  Applying Rolle's theorem in $[a, b]$ on $F(x)$, we get that there exists a point $c in (a, b)$ where $F'(c) = 0$.
   
  $
    => f'(c) - g'(c) = 0\
    => f'(c) = g'(c)\
    => f'(c) = (f(b) - f(a)) / (b - a)
  $ #h(1fr) $qed$
]

