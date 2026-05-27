#import "/src/lib.typ": pos, pos.place_at

#let theme = (
  foreground: black,
  background: none,
  lines: {
    let col = oklch(50%, 0.4, 45deg)

    (
      recv: col.rotate(090deg),
      wait: col.rotate(180deg),
      free: col.rotate(270deg),
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

#let height = 144pt
#set page(
  height: height,
  width: 800pt,
  margin: 0pt,
  fill: theme.background,
)
#set text(fill: theme.foreground)

#let bufs = (
  (
    free: 1,
    wait: 1,
    recv: 3,
  ),
  (
    free: 1,
    wait: 2,
    recv: 3,
  ),
  (
    free: 1,
    wait: 2,
    recv: 0,
  ),
)

#let buf(buf) = layout(((width, height)) => {
  let c = pos.config((size: (x: 800pt, y: 144pt)))
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
    (
      (
        (name: theme.lines.keys().last()) // default type in case all edges are the same
          + edges.find(((name, prev, next)) => {
            if prev <= next {
              prev <= slot and slot < next
            } else {
              prev <= slot or slot < next
            }
          })
      ).name
    )
  }

  let stroke = none
  // let stroke = red + 1pt
  rect(
    ..pos.as_size(c.size),
    inset: 0pt,
    // outset: 0pt,
    height: height,
    width: width,
    stroke: stroke,
    {
      let boxes = for b in range(c.box.count) {
        let ty = ty(b)
        place_at(pos.frame_box(c, b), {
          rect(
            ..pos.as_size(c.box.size),
            inset: (x: 10%, y: 20%),
            outset: 0pt,
            stroke: theme.lines.at(ty) + 0.5pt,
            text(size: c.box.size.y * 90%, ty, fill: theme.lines.at(ty)),
          )
        })
      }

      let lines = {
        theme
          .lines
          .pairs()
          .enumerate()
          .map(((l, (name, color))) => (
            arg: (c, buf.at(name), calc.rem-euclid(l, c.line.count)),
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

            let alignment = horizon + right
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
      }

      boxes
      lines
    },
  )
})

// #bufs.map(buf).intersperse(pagebreak()).sum()

#let pos = state("buffer-state", (
  free: 0,
  wait: 2,
  recv: 3,
))
#let update_buf(free: 0, wait: 0, recv: 0) = {
  pos.update(old => (
    free: calc.rem-euclid(old.free + free, 4),
    wait: calc.rem-euclid(old.wait + wait, 4),
    recv: calc.rem-euclid(old.recv + recv, 4),
  ))

  context { buf(pos.get()) }
}

#update_buf()
// #update_buf(wait: 1, recv: 1) // set together with `free`
// #update_buf(free: 1) // no notification for `wait` necessary
