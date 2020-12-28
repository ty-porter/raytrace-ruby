# raytrace-ruby

Ruby raytracer

![Header](assets/header.png)

Written in Ruby 2.7 thanks largely to the book [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) by Peter Shirley.

Outputs to .ppm format (you'll need something like [GIMP](https://www.gimp.org/) to view the files).

## Screenshots

### Development, In Screenshots

If you want to follow along with trial-and-error for this project, screenshots in the `assets` directory are prefixed with `a` and `b`. 

* `a` screenshots represent development milestones (i.e. I rendered my first circle, I added antialiasing, etc.). 

* `b` screenshots represent setbacks or funny things I ran across while working (i.e. I tweaked a setting and now it's all broken!).

Each screenshot has a number representing a milestone. For instance, for my first render, screenshot `a01` is the development milestone and `b01` was the worst setback I encountered in the session.

The Good | The Bad
:-------:|:------:
![Surface Normals of a Sphere](assets/a01_surface_normals.png) | ![Rendering Color](assets/b01_color_mistakes.png)
![Rendering the World](assets/a02_world_rendering.png) | ![Rendering Color 2](assets/b02_color_mistakes2.png)
![Antialiasing](assets/a03_antialiased_100_per_px.png) | ![Antialiasing Error](assets/b03_antialiasing_error.png)
![Diffusion](assets/a04_diffusion.png) | ![Diffusion Error](assets/b04_washed_out_diffusion.png)
![Materials Differentiation](assets/a05_metal.png) | ![Materials Mistake](assets/b05_materials_rendering.png)
![Glass](assets/a06_dielectrics.png) | ![Black Hole](assets/b06_black_hole.png)
![Camera](assets/a07_camera.png) | Nothing really went wrong this time :(


## Generate Your Own:

Clone this repository, then:

```shell
ruby main.py
```

It'll generate a new timestamped render in the `images` directory.

## Contact

Tyler Porter

tyler.b.porter@gmail.com