#import "@preview/showybox:2.0.1": *

#let theorem(name: "Theorem", ..body) = {
  showybox(title: name, frame: (title-color: green.darken(20%)), title-style: (weight: 800), ..body)
}

#let question = showybox.with(frame: (title-color: blue))

#let dated(date) = {
  block(fill: blue.lighten(50%), inset: 0.5em, radius: 1em)[Lecture on #date.display()]
}

#let numbered(body) = {
  set math.equation(numbering: "(1)")
  body
}

#let dd(t, b) = $(dif #t)/(dif #b)$
#let dd2(t, b) = $(dif^2 #t)/(dif #b^2)$
#let st = $"s.t."$
#let exists = math.class("relation", math.exists)
#let forall = math.class("relation", math.forall)

#let project(body) = {
  set text(font: "Atkinson Hyperlegible")
   
  show link: underline
   
  show math.equation.where(block: false): math.display
   
  set figure(numbering: none)
   
  show raw.where(block: false): box.with(fill: luma(230), inset: (x: 1mm), outset: (y: 1mm)) 
   
  show raw.where(block: true): set block(fill: luma(240), width: 100%, outset: (y: 0.65em), inset: (x: 0.65em), radius: 2mm, stroke: 1pt + luma(200))
   
  body
}