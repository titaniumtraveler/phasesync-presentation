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

#let buf_1 = (
  recv: 2,
  wait: 1,
  free: 0,
)

#let buf(buf) = layout(((width, height)) => {
  let c = pos.config((size: (x: width, y: height)))

  let edges = {
    let lines = theme.lines.keys().map(name => (name, buf.at(name)))
    lines.push(lines.first())
    lines.map(((name, pos)) => (name: name, idx: pos))
  }
    .windows(2)
    .map((((name, idx: next), (idx: prev, ..))) => (
      name: name,
      prev: prev,
      next: next,
    ))
  let ty(slot) = {
    edges
      .find(((name, prev, next)) => {
        if prev < next {
          prev <= slot and slot < next
        } else {
          prev <= slot or slot < next
        }
      })
      .name
  }

  rect(
    ..pos.as_size(c.size),
    inset: 0pt,
    outset: 0pt,
    stroke: none,
    {
      for b in range(c.box.count) {
        let ty = ty(b)
        place_at(pos.frame_box(c, b), {
          rect(
            ..pos.as_size(c.box.size),
            outset: 0pt,
            stroke: theme.lines.at(ty) + 0.5pt,
            text(ty, fill: theme.lines.at(ty)),
          )
        })
      }

      theme
        .lines
        .pairs()
        .enumerate()
        .map(((l, (name, color))) => (
          arg: (c, buf.at(name), calc.rem-euclid(l - 1, c.line.count)),
          name: name,
          color: color,
        ))
        .map(((arg, name, color)) => {
          place_at(pos.line(..arg), line(
            angle: 90deg,
            length: pos.line_length(..arg),
            stroke: color + 0.5pt,
          ))
          let stroke = 0pt
          // stroke = 0.1pt + color

          let alignment = top + right
          alignment = horizon + right
          place_at(
            alignment: alignment,
            pos.line_label(..arg),
            rotate(
              -75deg,
              origin: alignment,
              rect(
                inset: (
                  // x: 0pt,
                  x: c.line.label.size.y / 2,
                  y: 0pt,
                ),
                stroke: stroke,
                text(
                  size: c.line.label.size.y,
                  fill: color,
                  name,
                ),
              ),
            ),
          )
        })
        .sum()
    },
  )
})

#buf(buf_1)
