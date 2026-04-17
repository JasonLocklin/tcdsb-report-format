// typst-show.typ
//
// This file is processed AFTER Quarto injects brand-color from _brand.yml,
// so brand-color.*, brand-logo.*, and brand.typography.* are available here.
//
// Defines document helper functions (tcdsb-title-page, tcdsb-contents-page)
// and wires brand values into the tcdsb() template function.


// --- Title page -----------------------------------------------------

#let tcdsb-title-page() = {
  page(
    margin: 0in,
    // Quarto bug: paths in Typst template partials are not resolved relative to
    // the partial's location — they are emitted verbatim into the generated .typ
    // and resolved relative to the project root at compile time. The image must
    // therefore be referenced by its project-root path, not a bare filename.
    // Track: https://github.com/quarto-dev/quarto-cli/issues (path resolution
    // in typst template partials). When fixed, this can revert to
    // "title_page_background.png".
    background: image(
      "_extensions/report/title_page_background.png",
      height: 35%,
      fit: "cover",
    ),
    header: none,
    footer: none,
  )[
    // TCDSB logo (brand-logo.large) top-right
    #place(right, dy: 60pt, dx: -60pt)[
      #box(height: 150pt, image(brand-logo.large.path, height: 95%))
    ]

    #place(left + horizon, dy: -2in, dx: 1.25in)[
      #text(weight: "light", size: 30pt, fill: brand-color.primary, _tcdsb-title)
    ]

    #place(left + horizon, dy: -1.5in, dx: 1.25in)[
      #text(weight: "light", size: 26pt, fill: brand-color.primary, _tcdsb-subtitle)
    ]

    #place(left + horizon, dy: -1in, dx: 1.25in)[
      #text(weight: "light", size: 24pt, fill: brand-color.primary, _tcdsb-dept)
    ]

    #place(left + horizon, dy: 1in, dx: 1.25in)[
      #text(weight: "light", size: 24pt, fill: brand-color.primary, _tcdsb-date)
    ]

    #place(left + horizon, dy: 1.75in, dx: 1.25in)[
      #text(weight: "light", size: 20pt, fill: brand-color.blue_light, _tcdsb-author)
    ]

    // R&A logo (brand-logo.small) centred at page bottom
    #place(center + bottom, dy: -36pt)[
      #block(height: 150pt)[
        #box(inset: (x: 12pt), line(length: 100%, angle: 90deg, stroke: 0.5pt + white))
        #box(image(brand-logo.small.path, width: 50%))
      ]
    ]
  ]
}


// --- Contents page --------------------------------------------------

#let tcdsb-contents-page() = {
  page(header: none, footer: none)[
    #outline(indent: 1.5em)
  ]
}


// --- Display mechanics ----------------------------------------------

// Figures: allow page breaking across pages
#show figure: set block(breakable: true)

// Tables: allow multi-page tables
#show table: set block(breakable: true)

// Lists: consistent spacing below
#show list: set block(below: 0.75em)

// Block quotes: breathing room above and below
#show quote: set block(above: 0.75em, below: 0.75em)


// --- Apply document template ----------------------------------------
// Font is sourced from _brand.yml via brand.typography.base.family.
// mainfont (document frontmatter) takes precedence if set.
// If neither is set the build panics — we never silently fall back
// to a non-brand font.

$if(mainfont)$
#let _tcdsb-font = ("$mainfont$",)
$elseif(brand.typography.base.family)$
#let _tcdsb-font = $brand.typography.base.family$
$else$
#let _ = panic(
  "tcdsb PDF format: no brand font found. " +
  "Set typography.base.family in _brand.yml."
)
#let _tcdsb-font = ()
$endif$

#show: doc => tcdsb(
  font: _tcdsb-font,
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
  color-primary: brand-color.primary,
  color-secondary: brand-color.purple_deep,
  color-accent: brand-color.maroon_medium,
  color-link: brand-color.blue_bright,
  doc,
)
