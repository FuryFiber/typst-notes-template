#import "template.typ": *
// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: "Title",
  authors: (
    "Your name here",
  ),
)

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!

= Introduction
#def[Some definition][#lorem(10)]

== In this paper
#lorem(20)
#claim[Some claim][#lorem(20)]

=== Contributions
#property[Some property][#lorem(15)]

====
#algorithm[Some algorithm][
  ```pseudo
  function some_function(arg1, arg2){
    arg1 + arg2
    while true{
      arg1 ++
    }
  }
  ```
]
= #lorem(1)

