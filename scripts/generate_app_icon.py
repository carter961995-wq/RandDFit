from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
APPICONSET = ROOT / "RandDFit" / "Assets.xcassets" / "AppIcon.appiconset"


def lerp(a: float, b: float, t: float) -> float:
    return a + (b - a) * t


def lerp_rgb(c1: tuple[int, int, int], c2: tuple[int, int, int], t: float) -> tuple[int, int, int]:
    return (
        int(lerp(c1[0], c2[0], t)),
        int(lerp(c1[1], c2[1], t)),
        int(lerp(c1[2], c2[2], t)),
    )


def radial_gradient(size: int, inner: tuple[int, int, int], outer: tuple[int, int, int], center=(0.35, 0.25)) -> Image.Image:
    img = Image.new("RGB", (size, size), outer)
    px = img.load()
    cx = size * center[0]
    cy = size * center[1]
    max_d = (cx * cx + cy * cy) ** 0.5
    max_d = max(max_d, ((size - cx) ** 2 + (size - cy) ** 2) ** 0.5)
    for y in range(size):
        for x in range(size):
            d = ((x - cx) ** 2 + (y - cy) ** 2) ** 0.5
            t = min(1.0, d / max_d)
            px[x, y] = lerp_rgb(inner, outer, t)
    return img


def draw_bell_and_ring(base: Image.Image, *, mode: str) -> Image.Image:
    """
    mode:
      - "light": full-color app icon
      - "dark": full-color but optimized for dark appearance
      - "tinted": transparent background + solid white glyph (template-style)
    """
    size = base.size[0]
    assert base.size == (size, size)

    if mode == "tinted":
        canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        draw = ImageDraw.Draw(canvas)
        fg = (255, 255, 255, 255)
        ring = fg
        shadow = None
    else:
        canvas = base.convert("RGBA")
        draw = ImageDraw.Draw(canvas)
        # teal ring + warm bell
        ring = (79, 227, 214, 150) if mode == "light" else (79, 227, 214, 120)
        fg = (245, 196, 92, 255) if mode == "light" else (255, 210, 105, 255)
        shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    # Ring (outer stroke)
    pad = int(size * 0.10)
    stroke = int(size * 0.040)
    bbox = (pad, pad, size - pad, size - pad)
    draw.ellipse(bbox, outline=ring, width=stroke)

    # Bell geometry
    bell_w = int(size * 0.44)
    bell_h = int(size * 0.46)
    bell_x0 = (size - bell_w) // 2
    bell_y0 = int(size * 0.28)
    bell_x1 = bell_x0 + bell_w
    bell_y1 = bell_y0 + bell_h

    # Shadow behind bell (only for light/dark)
    if shadow is not None:
        sd = ImageDraw.Draw(shadow)
        sd_color = (0, 0, 0, 90) if mode == "light" else (0, 0, 0, 110)
        offset = int(size * 0.018)
        sd.rounded_rectangle(
            (bell_x0 + offset, bell_y0 + int(size * 0.07) + offset, bell_x1 + offset, bell_y1 + offset),
            radius=int(size * 0.08),
            fill=sd_color,
        )
        sd.ellipse(
            (bell_x0 + offset, bell_y0 + offset, bell_x1 + offset, bell_y0 + int(size * 0.22) + offset),
            fill=sd_color,
        )
        shadow = shadow.filter(ImageFilter.GaussianBlur(radius=int(size * 0.018)))
        canvas.alpha_composite(shadow)

    # Dome
    dome_h = int(size * 0.22)
    dome_bbox = (bell_x0, bell_y0, bell_x1, bell_y0 + dome_h)
    draw.ellipse(dome_bbox, fill=fg)

    # Body
    body_bbox = (bell_x0, bell_y0 + int(size * 0.12), bell_x1, bell_y1)
    draw.rounded_rectangle(body_bbox, radius=int(size * 0.09), fill=fg)

    # Base lip
    lip_h = int(size * 0.045)
    lip_bbox = (bell_x0 + int(size * 0.05), bell_y1 - lip_h, bell_x1 - int(size * 0.05), bell_y1)
    lip = (230, 170, 60, 255) if mode != "tinted" else fg
    draw.rounded_rectangle(lip_bbox, radius=int(size * 0.03), fill=lip)

    # Clapper
    clap_r = int(size * 0.045)
    cx = size // 2
    cy = bell_y1 - int(size * 0.07)
    clapper = (255, 238, 210, 255) if mode != "tinted" else fg
    draw.ellipse((cx - clap_r, cy - clap_r, cx + clap_r, cy + clap_r), fill=clapper)

    # Highlight streak (only for light/dark)
    if mode in ("light", "dark"):
        hl = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        hld = ImageDraw.Draw(hl)
        hld_color = (255, 255, 255, 55) if mode == "light" else (255, 255, 255, 45)
        hld.pieslice(
            (bell_x0 - int(size * 0.06), bell_y0 - int(size * 0.02), bell_x1 + int(size * 0.10), bell_y1),
            start=200,
            end=260,
            fill=hld_color,
        )
        hl = hl.filter(ImageFilter.GaussianBlur(radius=int(size * 0.012)))
        canvas.alpha_composite(hl)

    return canvas


def make_icon(mode: str, size: int = 1024) -> Image.Image:
    if mode == "tinted":
        base = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    elif mode == "dark":
        base = radial_gradient(size, inner=(8, 18, 36), outer=(28, 8, 34)).convert("RGBA")
    else:
        base = radial_gradient(size, inner=(12, 36, 76), outer=(106, 44, 145)).convert("RGBA")

    icon = draw_bell_and_ring(base, mode=mode)

    # Subtle vignette for light/dark
    if mode in ("light", "dark"):
        vignette = Image.new("L", (size, size), 0)
        vd = ImageDraw.Draw(vignette)
        vd.ellipse((-int(size * 0.15), -int(size * 0.10), int(size * 1.15), int(size * 1.20)), fill=220)
        vignette = vignette.filter(ImageFilter.GaussianBlur(radius=int(size * 0.08)))
        v = Image.new("RGBA", (size, size), (0, 0, 0, 80 if mode == "light" else 95))
        v.putalpha(Image.eval(vignette, lambda a: 255 - a))
        icon.alpha_composite(v)

    return icon


def main() -> None:
    APPICONSET.mkdir(parents=True, exist_ok=True)

    outputs = {
        "AppIcon.png": make_icon("light"),
        "AppIcon-dark.png": make_icon("dark"),
        "AppIcon-tinted.png": make_icon("tinted"),
    }

    for name, img in outputs.items():
        out = APPICONSET / name
        img.save(out, format="PNG", optimize=True)
        print(f"Wrote {out.relative_to(ROOT)}")


if __name__ == "__main__":
    main()

