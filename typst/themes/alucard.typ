#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/polylux:0.4.0": *
#import "base.typ": make-theme

#let colors = (
  background: rgb("#FFFBEB"),
  foreground: rgb("#1F1F1F"),
  pink: rgb("#A3144D"),
  purple: rgb("#644AC9"),
  orange: rgb("#A34D14"),
  green: rgb("#14710A"),
  cyan: rgb("#036A96"),
  red: rgb("#CB3A2A"),
  yellow: rgb("#846E15"),
  comment: rgb("#6C664B"),
)

#let theme = make-theme(colors, "./Alucard.tmTheme")

#let slide-title-header = theme.slide-title-header
#let the-footer = theme.the-footer
#let outline = theme.outline
#let progress-bar = theme.progress-bar
#let new-section = theme.new-section
#let focus = theme.focus
#let divider = theme.divider
#let note = theme.note
#let setup = theme.setup
