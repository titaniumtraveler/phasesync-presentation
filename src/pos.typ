#let default_config = {
  let c = (
    size: (x: 0% + 0pt),

    box: (
      count: 8,
      margin: (
        ratio: (
          x: 2 / 5,
        ),
      ),
    ),

    line: (
      count: 3,
    ),
  )
  c
}

#let as_dict(pos, x, y) = (
  (x): pos.x,
  (y): pos.y,
)

#let as_rel(pos) = as_dict(pos, "dx", "dy")
#let as_size(pos) = as_dict(pos, "width", "height")

/// - pos ((x: relative, y: relative)):
/// -> content
#let place_at(pos, body) = {
  let pos = {
    let (x, y: y) = pos
    (dx: x, dy: y)
  }
  box(place(
    top + left,
    ..pos,
    body,
  ))
}


#let config(c) = {
  let c = default_config + c

  let box_width = (
    c.size.x / (c.box.count + (c.box.count + 1) * c.box.margin.ratio.x)
  )
  let box_margin_width = box_width * c.box.margin.ratio.x

  let box_size = (
    x: box_width,
    y: box_margin_width,
  )

  let line_margin = box_margin_width / (c.line.count + 1)

  (
    size: (x: c.size.x),

    frame: (size: (x: box_width + box_margin_width)),

    box: (
      count: c.box.count,
      size: (
        x: box_width,
        y: box_margin_width,
      ),
      margin: (
        size: (x: box_margin_width),
        ratio: (x: c.box.margin.ratio.x),
      ),
    ),

    line: (
      count: c.line.count,
      margin: (size: (x: line_margin)),
      label: (size: (y: line_margin)),
    ),

    // ..c,
  )
}


#let frame(c, frame_idx) = {
  let c = config(c)
  (
    x: frame_idx * c.frame.size.x,
    // y: c.box.margin.size.x,
    y: c.line.margin.size.x,
  )
}

#let frame_box(c, frame_idx) = {
  let c = config(c)
  let pos = frame(c, frame_idx)
  pos.x += c.box.margin.size.x
  pos
}

#let line(c, frame_idx, line_idx) = {
  let c = config(c)
  let pos = frame(c, frame_idx)
  pos.x += (line_idx + 1) * c.line.margin.size.x
  pos
}

#let line_length(c, frame_idx, line_idx) = {
  let c = config(c)
  c.box.size.y + c.line.label.size.y * (c.line.count - line_idx)
}

#let line_end(c, frame_idx, line_idx) = {
  let c = config(c)
  let pos = line(c, frame_idx, line_idx)
  pos.y += line_length(c, frame_idx, line_idx)
  pos
}

#let line_label(c, frame_idx, line_idx) = {
  let c = config(c)
  let pos = line_end(c, frame_idx, line_idx)

  pos.x += 2pt
  pos.y += 2pt - c.line.label.size.y

  pos
}
