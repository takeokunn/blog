#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/polylux:0.4.0": *

#let blue = rgb("#282a36")
#let white = rgb("#f8f8f2")
#let pink = rgb("#ff79c6")
#let purple = rgb("#bd93f9")
#let orange = rgb("#ffb86c")
#let green = rgb("#50fa7b")
#let gray = rgb("#6272a4")

#let slide-title-header = toolbox.next-heading(h => {
  show: toolbox.full-width-block.with(fill: blue, inset: 1em)
  set text(fill: purple, size: 1.2em)
  strong(h)
})

#let the-footer(content) = {
  set text(size: 0.8em)
  show: pad.with(.5em)
  set align(bottom)
  context text(fill: white.lighten(40%), content)
  h(1fr)
}

#let outline = toolbox.all-sections((sections, _current) => {
  enum(tight: false, ..sections)
})

#let progress-bar = toolbox.progress-ratio(ratio => {
  set grid.cell(inset: (y: .03em))
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: pink)[],
    grid.cell(fill: purple)[],
  )
})

#let new-section(name) = slide({
  set page(header: none, footer: none)
  show: pad.with(20%)
  set text(size: 1.5em)
  name
  toolbox.register-section(name)
  progress-bar
})

#let focus(body) = context {
  set page(header: none, footer: none, fill: blue, margin: 2em)
  set text(fill: orange, size: 1.5em)
  set align(center)
  body
}

#let divider = line(length: 100%, stroke: .1em + pink)

#let setup(
  footer: none,
  text-font: "Migu",
  math-font: "Fira Math",
  code-font: "Fira Code",
  text-size: 23pt,
  body,
) = {
  set page(
    paper: "presentation-16-9",
    fill: blue,
    margin: (rest: 4em),
    footer: the-footer(footer),
    header: slide-title-header,
  )
  set text(
    font: text-font,
    size: text-size,
    fill: white,
  )
  set strong(delta: 100)
  show math.equation: set text(font: math-font)
  show raw: set text(font: code-font)
  set align(horizon)
  show emph: it => text(fill: pink, it.body)
  show heading.where(level: 1): _ => none

  body
}
