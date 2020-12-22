# raytrace-ruby

Ruby raytracer

Written in Ruby 2.7 thanks largely to the book [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) by Peter Shirley.

Outputs to .ppm format (you'll need something like [GIMP](https://www.gimp.org/) to view the files).

## Screenshots
### The Good
![Surface Normals of a Sphere](assets/surface_normals.png)
![Rendering the World](assets/world_rendering.png)

### The Bad
![Rendering Color](assets/color_mistakes.png)
![Rendering Color 2](assets/color_mistakes2.png)

## Generate Your Own:

Clone this repository, then:

```shell
ruby main.py
```

It'll generate a new timestamped render in the `images` directory.

## Contact

Tyler Porter

tyler.b.porter@gmail.com