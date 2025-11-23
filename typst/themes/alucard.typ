#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/polylux:0.4.0": *

#let background = rgb("#FFFBEB")
#let foreground = rgb("#1F1F1F")
#let current-line = rgb("#6C664B")
#let selection = rgb("#CFCFDE")
#let comment = rgb("#6C664B")
#let red = rgb("#CB3A2A")
#let orange = rgb("#A34D14")
#let yellow = rgb("#846E15")
#let green = rgb("#14710A")
#let cyan = rgb("#036A96")
#let purple = rgb("#644AC9")
#let pink = rgb("#A3144D")

#let slide-title-header = toolbox.next-heading(h => {
  show: toolbox.full-width-block.with(fill: background, inset: 1em)
  set text(fill: purple, size: 1.2em)
  strong(h)
})

#let the-footer(content) = {
  set text(size: 0.8em)
  show: pad.with(.5em)
  set align(bottom)
  context text(fill: foreground.lighten(40%), content)
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
  set page(header: none, footer: none, fill: background, margin: 2em)
  set text(fill: orange, size: 1.5em)
  set align(center)
  body
}

#let divider = line(length: 100%, stroke: .1em + pink)

#let note(where, body) = place(
  center + where,
  float: true,
  clearance: 6pt,
  rect(body),
)

#let setup(
  footer: none,
  text-font: "HackGen",
  math-font: "XITS Math",
  code-font: "HackGen Console",
  text-size: 23pt,
  body,
) = {
  set raw(theme: "./Alucard.tmTheme")

  set page(
    paper: "presentation-16-9",
    fill: background,
    margin: (rest: 4em),
    footer: the-footer(footer),
    header: slide-title-header,
  )
  set text(
    font: text-font,
    size: text-size,
    fill: foreground,
  )
  set strong(delta: 100)
  show math.equation: set text(font: math-font)
  show raw: set text(font: code-font)
  set align(horizon)
  show emph: it => text(fill: pink, it.body)
  show heading.where(level: 1): _ => none

  body
}
