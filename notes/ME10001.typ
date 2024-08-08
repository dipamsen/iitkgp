#import "@preview/cetz:0.2.2"
#import "template.typ": *

#show: project


= ME10001: Basic Engineering Mechanics [Autumn 2024-25]

- Course Website: 

- Instructor: Prof. Arnab Roy
- Course Coordinator:

- Class Test Dates: 29th August, 6th November (6:30 - 9)

#dated(datetime(year: 2024, month: 8, day: 5))


== Books
- Statics and Mechanics of Materials by Ferdinand P. Beer, E. Russell Johnston Jr., John T. DeWolf and David F. Mazurek,
  1st edition
- Vector Mechanics for engineers - Statics and Dynamics Ferdinand P. Beer, E. Russell Johnston Jr., and co-authors, 9th
  edition
- Mechanics of Materials P. Beer, E. Russell Johnston Jr., and co-authors, 6th edition

== Introduction

Mechanics is the branch of physics which deals with the study of state of motion of bodies under the action of forces.
- A broad classification of mechanics is as *Classical Mechanics* - deals with macroscopic objects, *Statistical
  Mechanics* - deals with large number of particles, *Quantum Mechanics* - deals with subatomic particles.
- A further subdivision of classical mechanics can be *rigid body dynamics*, *deformable body dynamics* and *fluid
  dynamics*.
- *Statics* deals with the study of bodies at rest or in equilibrium, *Dynamics* deals with the study of bodies in motion.
- This course deals primarily with statics of rigid bodies.

#dated(datetime(year: 2024, month: 8, day: 7))

/ Rigid Body: collection of large number of particles, the distance between any two particles remains constant.

/ Particle: small amount of matter that occupies a single point in space.

== Coordinate System for Vectors


// Cartesian
// #cetz.canvas({
//   import cetz.draw: *
 
//   line((0, 0), (1, 0))
//   line((0, 0), (0, 1))
//   line((0, 0), (0, 0, -1))


// })

#grid(
  columns: 3,
  align: center + horizon,
  figure(image("images/cartesian.png"), caption: [Cartesian Coordinate System\ $(x, y, z)$]),
  figure(image("images/sphericalcoord.png"), caption: [Spherical Coordinate System\ $(r, theta, phi)$]),
  figure(image("images/cylindricalcoord.png", width: 90%), caption: [Cylindrical Coordinate System\ $(r, theta, z)$]),
)

== Types of Vectors

/ Free Vector: can move anywhere in the plane

/ Sliding Vector: is restricted to move along a line, i.e. has unique line of action but no unique point of application

/ Fixed vector: has unique point of application and unique line of action

