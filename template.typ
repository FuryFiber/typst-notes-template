
// The project function defines how your document looks.
// It takes your content and some metadata and formats it.
// Go ahead and customize it to your liking!
#let buildMainHeader(mainHeadingContent) = {
  [
    #align(center, smallcaps(mainHeadingContent)) 
    #line(length: 100%)
  ]
}

#let buildSecondaryHeader(mainHeadingContent, secondaryHeadingContent) = {
  [
    #smallcaps(mainHeadingContent)  #h(1fr)  #emph(secondaryHeadingContent) 
    #line(length: 100%)
  ]
}

#let isAfter(secondaryHeading, mainHeading) = {
  let secHeadPos = secondaryHeading.location().position()
  let mainHeadPos = mainHeading.location().position()
  if (secHeadPos.at("page") > mainHeadPos.at("page")) {
    return true
  }
  if (secHeadPos.at("page") == mainHeadPos.at("page")) {
    return secHeadPos.at("y") > mainHeadPos.at("y")
  }
  return false
}

#let getHeader() = {
  locate(loc => {
    // Find if there is a level 1 heading on the current page
    let nextMainHeading = query(selector(heading).after(loc), loc).find(headIt => {
     headIt.location().page() == loc.page() and headIt.level == 1
    })
    if (nextMainHeading != none) {
      return buildMainHeader(nextMainHeading.body)
    }
    // Find the last previous level 1 heading -- at this point surely there's one :-)
    let lastMainHeading = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level == 1
    }).last()
    // Find if the last level > 1 heading in previous pages
    let previousSecondaryHeadingArray = query(selector(heading).before(loc), loc).filter(headIt => {
      headIt.level > 1
    })
    let lastSecondaryHeading = if (previousSecondaryHeadingArray.len() != 0) {previousSecondaryHeadingArray.last()} else {none}
    // Find if the last secondary heading exists and if its after the last main heading
    if (lastSecondaryHeading != none and isAfter(lastSecondaryHeading, lastMainHeading)) {
      return buildSecondaryHeader(lastMainHeading.body, lastSecondaryHeading.body)
    }
    return buildMainHeader(lastMainHeading.body)
  })
}
#let project(title: "", authors: (), logo: "images/logo.jpg", body) = {
  // Set the documents basic properties.
  set document(author: authors, title: title)
  set page(numbering: "1", number-align: center)
  set text(font: "noto sans", lang: "en")
  set raw(theme: "material.tmTheme")
  // Title page.
  // The page can contain a logo if you pass one with `logo: "logo.png"`.
  v(0.6fr)
  if logo != none {
    align(center, image(logo, width: 50%))
  }
  v(2fr)

  align(center, text(2em, weight: 700, title))

  // Author information.
text(..authors.map(author => align(center, strong(author))))

  v(2.4fr)
  pagebreak()

  // Table of contents.
  outline(depth: 3, indent: true, fill:none)
  pagebreak()


  // Formatting the headings
  // General First and then specific headings
  show heading: it => [
    #set align(left)
    #set text(14pt)
    #block(smallcaps(it.body))
  ]
  
  show heading.where(level: 1): it => [
    #pagebreak(weak: true)
    #set align(left)
    #set text(25pt)
    #underline(extent: 2pt)[
      Chapter #counter(heading).display() - #smallcaps(it.body)
      #v(3em)
    ]
  ]

  show heading.where(level:2): it => [
    #set text(19pt)
    #block(counter(heading).display() + " " + smallcaps(it.body))
  ]

  show heading.where(level:3): it => [
    #set text(15pt)
    #block(counter(heading).display() + " " + smallcaps(it.body))
  ]

  show heading.where(level:4): it => [
    #set text(11pt)
    #block(smallcaps(it.body))
  ]

  show heading.where(level:5): it => [
    #set text(9pt)
    #block(smallcaps(it.body))
  ]

  show raw.where(lang: "pseudo"): it => [
    #show regex("function\s+([a-zA-Z_][a-zA-Z0-9_]*)") : definition => text(fill: rgb("ff5370"), definition)
    #show regex("(\(|\)|\{|\}|\[|\]|<|>|\*|\+|=|-|;|\|)") : operands => text(weight: "bold", fill: rgb("#80cbc4"), operands)
    #show regex("\b(var|for|to|function|return|while|if|else|then|or|not|returns|persistent|update|calculate|select)\b") : keyword => text(weight: "bold", fill: rgb("#945eb8"), keyword)
    #show regex("([a-zA-Z_][a-zA-Z0-9_]*)\s*\(") : function_call => text(fill: rgb("ff5370"), function_call)
    #show regex("([a-zA-Z_][a-zA-Z0-9_]*):\s*") : argument => text(fill: rgb("82aaff"), argument)
    #show regex("(\/\/.*|\/\*[\s\S]*?\*\/)") : comment => text(fill: rgb("39adb5"), comment)
    #it
  ]


  // Main body.
  set par(justify: true)
  counter(page).update(1)
  set page(header: getHeader())
  set heading(numbering: "1.1")
  set page(numbering: "1", number-align: center)
  body
}



#let def(title, content) = {
  block(
  fill: blue.lighten(80%),
  stroke: blue.lighten(30%),
  inset: 8pt,
  radius: 4pt,
  [*#underline([Definition: #title])*\
    #text(content)]
  )
}

#let claim(title, content) = {
  block(
  fill: red.lighten(80%),
  stroke: red.lighten(30%),
  inset: 8pt,
  radius: 4pt,
  [
    *#underline([Claim: #title])*\
    #text(content)\
  ]
  )
}

#let algorithm(title, content) = {
  block(
  fill: navy.lighten(90%),
  inset: 8pt,
  radius: 4pt,
  stroke: teal.lighten(30%),
  [*#underline([Algorithm: #title])*\
    #text(content)]
  )
}
#let property(title, content) = {
  block(
  fill: teal.lighten(80%),
  stroke: teal.lighten(30%),
  inset: 8pt,
  radius: 4pt,
  [*#underline([Property: #title])*\
    #text(content)]
  )
}

