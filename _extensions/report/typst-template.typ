// typst-template.typ
//
// Defines the tcdsb() document template function.
// No brand-color references here — this file is processed BEFORE Quarto
// injects brand-color from _brand.yml.
//
// The font parameter has no default; it MUST be supplied by typst-show.typ
// (via the mainfont Quarto variable set in _quarto.yml from _brand.yml).
// This prevents silent fallback to a non-brand font.
//
// Pandoc metadata is wired to _tcdsb-* globals for use in typst-show.typ.

// --- Pandoc metadata wiring -----------------------------------------

$if(title)$
#let _tcdsb-title = [$title$]
$else$
#let _tcdsb-title = []
$endif$

$if(subtitle)$
#let _tcdsb-subtitle = [$subtitle$]
$else$
#let _tcdsb-subtitle = []
$endif$

$if(dept)$
#let _tcdsb-dept = "$dept$"
$else$
#let _tcdsb-dept = ""
$endif$

$if(date)$
#let _tcdsb-date = "$date$"
$else$
#let _tcdsb-date = ""
$endif$

$if(author)$
#let _tcdsb-author = "$author$"
$else$
#let _tcdsb-author = ""
$endif$


// --- Document template function -------------------------------------
// Colour parameters are filled from brand-color in typst-show.typ.

#let tcdsb(
  margin: (x: 1in, y: 1in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  color-primary: rgb("#951B1E"),
  color-secondary: rgb("#2D0026"),
  color-accent: rgb("#BA7D6B"),
  color-link: rgb("#6BCAD4"),
  doc,
) = {

  // Page layout — clear Quarto's brand-injected logo background,
  // set running header and branded footer.
  set page(
    paper: paper,
    margin: margin,
    numbering: none,
    background: none,
    header: align(right)[
      #set text(size: 10pt, weight: "light", fill: color-primary)
      #_tcdsb-title
    ],
    footer: grid(
      columns: (33.33%, 33.33%, 33.33%),
      rows: (auto, 60pt),
      gutter: 3pt,
      align: (left, center + horizon, right + horizon),
      [],
      text(weight: "light", size: 12pt, fill: color-primary)[Research & Analytics],
      context counter(page).display("1/1", both: true),
    ),
  )

  // Text properties
  set text(
    lang: lang,
    region: region,
    font: font,
    size: fontsize,
    fill: black,
  )

  set par(leading: 0.8em)

  set table(
    align: left,
    inset: 7pt,
    stroke: (x: none, y: 0.5pt),
  )

  // Heading styles using colour parameters
  show heading.where(level: 1): it => block(width: 100%, below: 1em)[
    #set align(center)
    #set text(size: 20pt, weight: "regular", fill: color-primary)
    #smallcaps(it.body)
  ]

  show heading.where(level: 2): it => block(below: 1em)[
    #text(size: 16pt, weight: "bold", fill: color-secondary, upper(it.body))
  ]

  show heading.where(level: 3): it => block(below: 1em)[
    #text(size: 14pt, weight: "bold", style: "italic", fill: color-accent, upper(it.body))
  ]

  // Link styles
  show link: underline
  show link: set underline(stroke: 1pt, offset: 2pt)
  show link: set text(fill: color-link)

  doc
}
