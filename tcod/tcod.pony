actor Main
  new create(env: Env) =>
    let indices = [as I32: 0; 4; 8]
    let colors = [Color.from_RGB(0, 0, 0)
                  Color.from_RGB(255, 0, 0)
                  Color.from_RGB(255, 255, 255)]
    try
      Color.gen_map(colors, indices)?
    else
      env.out.print("Failed to generate color_map!")
    end

