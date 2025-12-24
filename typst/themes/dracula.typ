#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/polylux:0.4.0": *
#import "base.typ": make-theme

#let colors = (
  background: rgb("#282a36"),
  foreground: rgb("#f8f8f2"),
  pink: rgb("#ff79c6"),
  purple: rgb("#bd93f9"),
  orange: rgb("#ffb86c"),
  green: rgb("#50fa7b"),
  gray: rgb("#6272a4"),
)

#let theme = make-theme(colors, "./Dracula.tmTheme")

#let slide-title-header = theme.slide-title-header
#let the-footer = theme.the-footer
#let outline = theme.outline
#let progress-bar = theme.progress-bar
#let new-section = theme.new-section
#let focus = theme.focus
#let divider = theme.divider
#let note = theme.note
#let setup = theme.setup
