#import "/src/lib.typ": pos, pos.place_at

#let theme = (
  foreground: black,
  background: white,
  lines: {
    let col = oklch(50%, 0.4, 45deg)

    (
      free: col.rotate(270deg),
      recv: col.rotate(090deg),
      wait: col.rotate(180deg),
    )
  },
)

#let is_darkmode = false
#let is_darkmode = true
#if is_darkmode {
  theme += (
    foreground: rgb("#a6a28c"),
    background: rgb("#20201d"),
  )
}

#set page(
  paper: "presentation-16-9",
  margin: 0pt,
  background: rect(width: 100%, height: 100%, fill: theme.background),
)
#set text(fill: theme.foreground)

#let val(..config) = {
  let (i, count, rat, width) = config.named()
  let x = width / (count + count * rat + rat)
  let margin = rat * x
  (
    width: width,

    x: x,
    dx: x * i + margin * i,
    rat: rat,
    margin: margin,

    c: (
      size: (x: width),

      box: (
        count: count,
        margin: (ratio: (x: rat)),
      ),

      line: (count: theme.lines.len()),
    ),
  )
}

#box(layout(((width, height)) => {
  let c = pos.config((size: (x: width)))

  for i in range(c.box.count) {
    place_at(pos.frame_box(c, i), {
      rect(
        ..pos.as_size(c.box.size),
        stroke: theme.foreground + 0.5pt,
      )
    })

    for (l, (name, color)) in theme.lines.pairs().enumerate() {
      place_at(pos.line(c, i, l), line(
        angle: 90deg,
        length: pos.line_length(c, i, l),
        stroke: color + 0.5pt,
      ))
      place_at(pos.line_label(c, i, l), text(c.line.label.size.y, name))
    }
  }
}))
