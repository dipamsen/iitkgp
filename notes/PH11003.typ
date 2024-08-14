#import "@preview/cetz:0.2.2"
#import "template.typ": *
#import "@preview/showybox:2.0.1": *
#show: project


= PH11003: Physics of Waves [Autumn 2024-25]

- Course Website: https://sites.google.com/view/iitkgp-physics-of-waves

- Instructor: Dr. Samudra Roy
- Course Coordinator: Dr. Samudra Roy

- Class Test Dates: 7th September, 9th November (4-7)

#dated(datetime(year: 2024, month: 8, day: 5))

Waves are disturbances that propagate through a medium. They carry energy from one place to another without the transfer
of matter.

The concept of waves is omnipresent in physics. It appears in the following disciplines:

- Mechanics
- Electromagnetism
- Optics
- Quantum Mechanics

Any mathematical quantity which is a function of space and time, is said to be a wave if it satisfies the wave equation.

#let fun = $Phi(x, t)$

#numbered[$
    dd2(fun, t) = 1/v^2 dd2(fun, x)
  $ <base>]

Moving towards electrodynamics, in free space in absence of any source, we can write the following Maxwell's equations:

#let Ef = $arrow(E)$
#let Bf = $arrow(B)$

$
  nabla dot Ef   &= 0\
  nabla dot Bf   &= 0\
  nabla times Ef &= -dd(Bf, t)\
  nabla times Bf &= mu_0 epsilon_0 dd(Ef, t)
$

where, $nabla$ is the del operator, defined as

$
  nabla = dd(, x) hat(i) + dd(, y) hat(j) + dd(, z) hat(k)\
  nabla^2 = lr(|dd2(, x) + dd2(, y) + dd2(, z)|)
$

On solving the above equations, the we obtain:

$
  nabla^2 Ef = mu_0 epsilon_0 dd2(Ef, t)
$

If we consider $Ef$ to be confined in one dimension (say, $x$), then the above equation simplifies to:

#numbered[$
    dd2(Ef, x) = mu_0 epsilon_0 dd2(Ef, t)
  $]

which matches with @base as a wave equation, with $v = 1/sqrt(mu_0 epsilon_0) = c$.

== Simple Harmonic Motion

Considering a spring system, we can find the motion of a block attached to a spring by modelling the spring force with
Hooke's law:

#let xd = $dot(x)$
#let xdd = $dot.double(x)$

$
  F = - k x\
  m xdd + k x     &= 0\
  xdd + (k/m) x   &= 0\
  xdd + omega^2 x &= 0
$

By some manipulation of the second equation, we can prove conservation of mechanical energy:

$
  m xdd + k x                                                                          &= 0\
  m xd xdd + k x xd                                                                    &= 0\
  dd(, t)(1/2 m xd^2 + 1/2 k x^2)                                                      &= 0\
  underbrace(1/2 m xd^2, "Kinetic Energy") + underbrace(1/2 k x^2, "Potential energy") &= E
$

The expression of potential energy can be calculated from $integral_x^0 F dif x$:

General solution for the SHM equation is:

$
  x &= x_0 sin (omega t + phi.alt_0)
$

Alternatively, it can be written in an exponential form involving complex numbers:

$
  x = x_0 e^i(omega t + phi.alt_0)
$
which is said to be "well-behaved" as it is easier to work with. (The real part of the above expression gives the actual
solution.)

For analysing this kind of situations, a helpful tool is a phase diagram, or a phase space plot, which is a plot of $p_x$ vs $x$,
over time.

For the ideal simple harmonic oscillator:

$
  1/2 m xd^2 + 1/2 k x^2 = E\
  p_x^2/(2m) + 1/2 k x^2 = E\
// (p_x)^2/(sqrt(2 E m))^2 + x^2 / display((sqrt((2E)/k))^2) = 1
$

#figure(
  cetz.canvas(
    {
      import cetz.draw: *
       
      line((-2, 0), (2, 0), thickness: 0.1, mark: (end: ">"), name: "x")
      content((), $x$, anchor: "west")
       
      line((0, -1), (0, 1), thickness: 0.1, mark: (end: ">"), name: "y")
      content((), $p_x$ + v(1mm), anchor: "south")
       
      mark((0.8 * calc.cos(30deg), 0.6 * calc.sin(30deg)), (rel: (), to: (-0.1, 0.1)), symbol: "stealth", fill: black)
       
       
       
      circle((0, 0), radius: (0.8, 0.6))
       
      circle((0.8, 0), radius: 0.03)
    },
    length: 2cm,
  ),
  caption: [The $p_x$-$x$ phase plot for an ideal simple harmonic oscillator is an ellipse.],
)

If we calculate the area of the ellipse, it turns out to be proportional to the energy of the system. 

From this observation we can infer, that in case of a damped oscillator, the area of the ellipse will decrease with
time, and the phase plot will spiral inwards.

#dated(datetime(year: 2024, month: 8, day: 6))


The differential equation for a simple harmonic oscillator is:

$
  xdd + omega_0^2 x = 0
$

To solve this equation, it is convenient to rewrite the equation in the energy form:


$
  1/2 m    &xd^2 + 1/2 k x^2 = E\
   
           &xd^2 + k/m x^2 = (2E)/m\ 
   
  dd(x, t) &= sqrt((2E)/m- k/m x^2)\
  dd(x, t) &= sqrt(k/m) sqrt(alpha^2 - x^2)\
  dd(x, t) &= omega_0 sqrt(alpha^2 - x^2)
$
#h(1fr)where $omega_0 = k/m$ and $alpha = sqrt((2E)/k)$.



$
  integral (dif x) / sqrt(alpha^2 - x^2) = omega_0 integral (dif t)\
  sin^(-1)(x/alpha) = omega_0 t + phi.alt_0\
  #box(stroke: 1pt, outset: (x: 3mm, y: 2mm))[$x = alpha sin(omega_0 t + phi.alt_0)$]
$

Many mechanical systems follow such a simple harmonic motion, such as:
- A mass attached to a spring
- A pendulum
- A vibrating string
- A tortional pendulum
etc.

== Eigenfunctions and Eigenvalues

If $H$ is an operator defined on a function space, then the eigenfunctions of $H$ are the functions $f$ such that

$
  H f = lambda f
$

where $lambda$ is the eigenvalue corresponding to the eigenfunction $f$.

For example, for the operator $dd(, t)$, one of the eigenfunctions is $e^(lambda t)$, with the eigenvalue $lambda$.

$
  dd(, t) e^(lambda t) = lambda e^(lambda t)
$

When dealing with a certain operator, it is often useful to work with its eigenfunctions and eigenvalues, as they can
simplify the problem significantly.

In this case, we are concerned with operators $dd(, x)$ and $dd2(, t)$. For both of these operators, the exponential
function $e^(lambda x)$ is an eigenfunction. Thus, it is useful to work with the exponential form of the harmonic
oscillator, $x = e^(i(omega_0 t + phi.alt))$.

Note that functions $sin$ and $cos$ are indeed eigenfunctions of the operator $dd2(, t)$ but not for $dd(, t)$. (The
first order differential operator will show up in our equation when modelling damping.)

== Functions as vectors and Taylor Series

Consider a vector $arrow(v)$ in a vector space. We can expand this vector in terms of a basis set of vectors $arrow(e_i)$:

#grid(columns: (0.3fr, 1fr), align: center + horizon, cetz.canvas({
  import cetz.draw: *
   
  line((0, 0), (0.7, 0.8), name: "v", mark: (end: ">"))
   
  line((0, 0), (0.8, 0), name: "e_1", mark: (end: (symbol: "stealth", fill: black)))
  line((0, 0), (0, 0.8), name: "e_2", mark: (end: (symbol: "stealth", fill: black)))
  content((0.8, 0.8), $arrow(v)$, anchor: "south")
  content((1, 0), $arrow(e_1)$, anchor: "south")
  content((0, 0.9), $arrow(e_2)$, anchor: "south")
}, length: 2cm), $
  arrow(v) &= v_1 arrow(e_1) + v_2 arrow(e_2)\
           &= sum_(i=1)^n v_i arrow(e_i)
$)

Note that the basis vectors $arrow(e_i)$ are *linearly independent* and span the vector space. In this case, they also
are *orthogonal* to each other. The coefficients $v_i$ are components of the vector $arrow(v)$ in the basis $arrow(e_i)$.

Analogously, any function $f(x)$ can be expanded in terms of a basis set of functions $e_i (x)$:

$
  f(x) &= c_1 e_1(x) + c_2 e_2(x) + ... + c_n e_n (x)\
       &= sum_(i=1)^n c_i e_i (x)
$

We must choose the basis functions $e_i (x)$ to be linearly independent. 

Some examples of sets of basis functions that are orthogonal to each other are:

1. ${1, x, x^2, x^3, x^4, ...} $ (polynomials)
2. ${sin(x), sin(2x), sin(3x), ...} $ (sine functions)
3. ${cos(x), cos(2x), cos(3x), ...} $ (cosine functions)


If we consider the set 1. above, we can expand any function $f(x)$ in terms of the basis functions $1, x, x^2, x^3, ...$.
The series thus obtained is called a *Taylor series*.

Similarly, if we consider the set 2/3 above, we can expand any function $f(x)$ in terms of the basis sinusoidal
functions. The series thus obtained is called a *Fourier series*.

To find the coefficients of the Taylor series, we can exploit the fact that differentiating a polynomial reduces its
degree:

$
  f(x) = c_0 + c_1 x + c_2 x^2 + c_3 x^3 + ... + c_n x^n\
$$ c_0 &= f(0)\
c_1 &= f'(x)|_(x=0)\
c_2 &= lr((f''(x))/2!|)_(x=0)\
c_3 &= lr((f'''(x))/3!|)_(x=0)\
    &dots.v $

Thus, 

$
  f(x) = f(0) + f'(0) x + (f''(0))/2! x^2 + (f'''(0))/3! x^3 + ... + (f^n (0))/n! x^n + ...
$

Some common Taylor series expansions are:

$
  e^x = 1 + x + x^2/2! + x^3/3! + x^4/4! + ...\
   
  sin(x) = x - x^3/3! + x^5/5! - x^7/7! + ...\
   
   
  cos(x) = 1 - x^2/2! + x^4/4! - x^6/6! + ...
$

The above three expansions can be correlated with the Euler's formula:

$
  e^(i x) &= 1 + i x - x^2 / 2! - i x^3 / 3! + x^4 / 4! + ...\
   
          & = [1 - x^2 / 2! + x^4 / 4! - ...] + i [x - x^3 / 3! + x^5 / 5! - ...]\
          &= cos(x) + i sin(x)
$

== Damped Harmonic Oscillator

A damping force is modelled by a force term that is proportional to the velocity of the object:

$
  F = - k x - gamma xd\
   
  m xdd + gamma xd + k x = 0\
  dd2(x, t) + gamma/m dd(x, t) + k/m x = 0
$
The above differential equation is a second order ordinary homogeneous linear differential equation with constant
coefficients.

#showybox(title: "Recap: Solving second order ODEs", breakable: true)[
  A second order linear ordinary differential equation is of the form:
   
  $a dd2(y, x) + b dd(y, x) + c y = 0$
   
  Consider a solution
  $
    y tilde e^(m x)
  $
   
  Substituting the above solution in the differential equation, we get:
   
  $
    a m^2 e^(m x) + b m e^(m x) + c e^(m x) &= 0\
    e^(m x) (a m^2 + b m + c)               &= 0\
    a m^2 + b m + c                         &= 0
  $
   
  If $m_1$ and $m_2$ are the roots of the characteristic equation:
   
  $m = (-b plus.minus sqrt(b^2 - 4 a c)) / (2 a)$
   
  Thus, the general solution of the differential equation is:
   
  If $m_1 eq.not m_2$:
   
  $
    y = c_1 e^(m_1 x) + c_2 e^(m_2 x)
  $
   
  If $m_1 = m_2$:
   
  $
    y = (c_1 + c_2 x )e^(m x)
  $
   
]

To solve the damped oscillator, we will rephrase the equation by taking $Gamma = gamma / (2m)$ and $omega_0^2 = k/m$:

$
  dd2(x, t) + 2 Gamma dd(x, t) + omega_0^2 x = 0
$

Substituting $x tilde e^(m t)$, we get:

$
  m^2 + 2 Gamma m + omega_0^2 = 0\
   
  m = -Gamma plus.minus sqrt(Gamma^2 - omega_0^2)
$

Consider $beta = sqrt(Gamma^2 - omega_0^2)$:

Thus the general solutions are:

1. *Case 1*: If $Gamma^2 > omega_0^2$: Overdamping

$
  x(t) = c_1 e^(m_1 t) + c_2 e^(m_2 t)\
  m_1 = -Gamma + sqrt(Gamma^2 - omega_0^2)\
  m_2 = -Gamma - sqrt(Gamma^2 - omega_0^2)\
   
  => #box(stroke: 1pt, outset: 2mm)[$x(t) = e^(-Gamma t) [c_1 e^(beta t) + c_2 e^(-beta t)$]]
$
$c_1$ and $c_2$ are determined by the initial conditions. If we take boundary conditions - $x(t=0) = 0$ and $xd(t=0) = v_0$,
we can find the values of $c_1$ and $c_2$.

#showybox(title: [Hyperbolic Trig functions], breakable: true)[
  $ sinh(x) = (e^x - e^(-x))/2\
  cosh(x) = (e^x + e^(-x))/2\
  tanh(x) = sinh(x)/cosh(x)\ $
][$
    sinh(i x) = i sin(x)\
     
    cosh(i x) = cos(x)\
  $][$
    sinh'(x) = cosh(x)\
     
    cosh'(x) = sinh(x)
  $
   
]

On using the boundary conditions we get

$
  x(t) = v_0 / beta e^(-Gamma t) sinh(beta t)
$

#image("images/overdamp.png", width: 40%)

2. *Case 2*: If $Gamma^2 = omega_0^2$: Critical damping

$
  x(t) = e^(-Gamma t) (c_1 + c_2 t)
$

By using same boundary conditions,

$
  x(t) = v_0 t e^(-Gamma t)
$
#image("images/critical.png", width: 40%)

In this case, the amplitude of the oscillation decays faster than the overdamped case.


3. *Case 3*: If $Gamma^2 < omega_0^2$: Underdamping

In this case values of $m$ will be complex.

$
  m = -Gamma plus.minus sqrt(Gamma^2 - omega_0^2) = -Gamma plus.minus i mu
$

where $mu = sqrt(omega_0^2 - Gamma^2)$

Then, we can get the final expression under same boundary conditions by substituting $beta = i mu$

$
  x(t) = v_0/mu e^(-Gamma t) sin(mu t)
$

// #image("images/underdamp.png", width: 40%)

To recap, the following expressions are for boundary condition - 1 in each case:

1. Overdamping: $x(t) = v_0 / beta e^(-Gamma t) sinh(beta t)$
2. Critical damping: $x(t) = v_0 t e^(-Gamma t)$
3. Underdamping: $x(t) = v_0/mu e^(-Gamma t) sin(mu t)$

where $beta = sqrt(Gamma^2 - omega_0^2)$ and $mu = sqrt(omega_0^2 - Gamma^2)$. $Gamma = gamma/(2m)$ and $omega_0^2 = k/m$.