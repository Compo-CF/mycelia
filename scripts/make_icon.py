"""
Generate Mycelia's 1024x1024 AppIcon.

Design: a single bioluminescent fruiting body — pale cap, glowing gills,
on a Hollow Black ground. Reads at home-screen scale because there is
exactly one bright moment in a sea of dark, which is the whole point of
the visual identity.

Usage:
    python scripts/make_icon.py
Output:
    Mycelia/Resources/Assets.xcassets/AppIcon.appiconset/icon-1024.png
"""

from PIL import Image, ImageDraw, ImageFilter
from pathlib import Path

W = H = 1024

HOLLOW_BLACK = (0x0B, 0x10, 0x0D)
SPORE_DUST   = (0xD6, 0xC9, 0xA8)
FOXFIRE_TEAL = (0x5B, 0xC9, 0xB0)
DAMP_BARK    = (0x3D, 0x2F, 0x25)


def make_icon() -> Image.Image:
    img = Image.new("RGBA", (W, H), HOLLOW_BLACK + (255,))

    # Big diffuse glow behind the mushroom (sets the mood).
    big_glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    g = ImageDraw.Draw(big_glow)
    cx, cy = W // 2, int(H * 0.58)
    r = 360
    g.ellipse((cx - r, cy - r, cx + r, cy + r),
              fill=FOXFIRE_TEAL + (120,))
    big_glow = big_glow.filter(ImageFilter.GaussianBlur(radius=110))
    img = Image.alpha_composite(img, big_glow)

    # Build the mushroom on its own layer so we can mask glows against it.
    mushroom = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    md = ImageDraw.Draw(mushroom)

    # Stem first (will be partly covered by cap).
    stem_w, stem_h = 150, 280
    stem_x = W // 2 - stem_w // 2
    stem_y = int(H * 0.46)
    md.rounded_rectangle(
        (stem_x, stem_y, stem_x + stem_w, stem_y + stem_h),
        radius=stem_w // 2,
        fill=SPORE_DUST + (255,),
    )

    # Cap — dome-shaped, drawn on top of the stem so only the lower stem shows.
    cap_w, cap_h = 600, 440
    cap_x = W // 2 - cap_w // 2
    cap_y = int(H * 0.46) - cap_h // 2 - 30
    md.ellipse(
        (cap_x, cap_y, cap_x + cap_w, cap_y + cap_h),
        fill=SPORE_DUST + (255,),
    )

    img = Image.alpha_composite(img, mushroom)

    # Tight glow under the cap (the "gills" — where Panellus stipticus
    # actually glows). Halo only around the mushroom, not over it.
    gill_glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    gg = ImageDraw.Draw(gill_glow)
    gw, gh = int(cap_w * 0.95), int(cap_h * 0.75)
    gx = W // 2 - gw // 2
    gy = cap_y + int(cap_h * 0.55)
    gg.ellipse((gx, gy, gx + gw, gy + gh),
               fill=FOXFIRE_TEAL + (230,))
    gill_glow = gill_glow.filter(ImageFilter.GaussianBlur(radius=28))

    mushroom_mask = mushroom.split()[3]
    inv_mask = Image.eval(mushroom_mask, lambda v: 255 - v)
    haloed = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    haloed.paste(gill_glow, mask=inv_mask)
    img = Image.alpha_composite(img, haloed)

    # Soft ground shadow.
    ground_shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sd = ImageDraw.Draw(ground_shadow)
    sd.ellipse(
        (W // 2 - 240, int(H * 0.79), W // 2 + 240, int(H * 0.85)),
        fill=(0, 0, 0, 200),
    )
    ground_shadow = ground_shadow.filter(ImageFilter.GaussianBlur(radius=22))
    img = Image.alpha_composite(img, ground_shadow)

    # Flatten to RGB — App Store icons must not have an alpha channel.
    flat = Image.new("RGB", (W, H), HOLLOW_BLACK)
    flat.paste(img, mask=img.split()[3])
    return flat


def main() -> None:
    out = Path(__file__).resolve().parent.parent \
        / "Mycelia" / "Resources" / "Assets.xcassets" \
        / "AppIcon.appiconset" / "icon-1024.png"
    out.parent.mkdir(parents=True, exist_ok=True)
    img = make_icon()
    img.save(out, "PNG")
    print(f"wrote {out}  ({out.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    main()
