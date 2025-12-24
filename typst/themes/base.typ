#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/polylux:0.4.0": *

#let make-theme(
  colors,
  tm-theme-path,
) = {
  let bg = colors.background
  let fg = colors.foreground
  let accent-pink = colors.pink
  let accent-purple = colors.purple
  let accent-orange = colors.orange

  let slide-title-header = toolbox.next-heading(h => {
    show: toolbox.full-width-block.with(fill: bg, inset: 1em)
    set text(fill: accent-purple, size: 1.2em)
    strong(h)
  })

  let the-footer(content) = {
    set text(size: 0.8em)
    show: pad.with(.5em)
    set align(bottom)
    context text(fill: fg.lighten(40%), content)
    h(1fr)
  }

  let outline = toolbox.all-sections((sections, _current) => {
    enum(tight: false, ..sections)
  })

  let progress-bar = toolbox.progress-ratio(ratio => {
    set grid.cell(inset: (y: .03em))
    grid(
      columns: (ratio * 100%, 1fr),
      grid.cell(fill: accent-pink)[],
      grid.cell(fill: accent-purple)[],
    )
  })

  let new-section(name) = slide({
    set page(header: none, footer: none)
    show: pad.with(20%)
    set text(size: 1.5em)
    name
    toolbox.register-section(name)
    progress-bar
  })

  let focus(body) = context {
    set page(header: none, footer: none, fill: bg, margin: 2em)
    set text(fill: accent-orange, size: 1.5em)
    set align(center)
    body
  }

  let divider = line(length: 100%, stroke: .1em + accent-pink)

  let note(where, body) = place(
    center + where,
    float: true,
    clearance: 6pt,
    rect(body),
  )

  let setup(
    footer: none,
    text-font: "HackGen",
    math-font: "XITS Math",
    code-font: "HackGen Console",
    text-size: 23pt,
    body,
  ) = {
    set raw(theme: tm-theme-path)

    set page(
      paper: "presentation-16-9",
      fill: bg,
      margin: (rest: 4em),
      footer: the-footer(footer),
      header: slide-title-header,
    )
    set text(
      font: text-font,
      size: text-size,
      fill: fg,
    )
    set strong(delta: 100)
    show math.equation: set text(font: math-font)
    show raw: set text(font: code-font)
    set align(horizon)
    show emph: it => text(fill: accent-pink, it.body)
    show heading.where(level: 1): _ => none

    body
  }

  (
    slide-title-header: slide-title-header,
    the-footer: the-footer,
    outline: outline,
    progress-bar: progress-bar,
    new-section: new-section,
    focus: focus,
    divider: divider,
    note: note,
    setup: setup,
  )
}
