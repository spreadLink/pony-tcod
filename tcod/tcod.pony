actor Main
  new create(env: Env) =>
    let indices = [as I32: 0; 4; 8]
    let colors = [Color(0, 0, 0)
                  Color(255, 0, 0)
                  Color(255, 255, 255)]
    try
      Gradiant.generate(colors, indices)?
    else
      env.out.print("Failed to generate color_map!")
    end

