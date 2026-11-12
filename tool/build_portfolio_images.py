"""Build portfolio platform images from raw BiteBox screenshots.

Pipeline: raw capture -> crop status bar / overlay capsule -> platform template.
Raw files stay untouched in raw/; finished images go to fiverr/ instagram/
chengjubao/. Per the agreed scope:
  - fiverr/  : English, 4:3
  - instagram/: English, 4:5
  - chengjubao/: Chinese only, 16:9 `_zh` (no English 16:9 here)
"""
from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "docs" / "screenshots" / "raw"
OUT = ROOT / "docs" / "screenshots"

CROP_TOP = 100  # remove status bar + blue "协同中" capsule, keep AppBar

# Palette (coral theme)
BG = (249, 250, 251)
SURFACE = (255, 255, 255)
BORDER = (229, 231, 235)
TEXT = (17, 24, 39)
SECONDARY = (107, 114, 128)

FONT_REG = r"C:\Windows\Fonts\arial.ttf"
FONT_BOLD = r"C:\Windows\Fonts\arialbd.ttf"
FONT_REG_ZH = r"C:\Windows\Fonts\msyh.ttc"
FONT_BOLD_ZH = r"C:\Windows\Fonts\msyhbd.ttc"


def font(size: int, bold: bool = False, locale: str = "en") -> ImageFont.FreeTypeFont:
    if locale == "zh":
        path = FONT_BOLD_ZH if bold else FONT_REG_ZH
    else:
        path = FONT_BOLD if bold else FONT_REG
    return ImageFont.truetype(path, size)


def load_clean(name: str, crop_top: int = CROP_TOP) -> Image.Image:
    with Image.open(RAW / name) as im:
        w, h = im.size
        clean = im.crop((0, crop_top, w, h))
        return clean.convert("RGB")


def rounded_mask(size: tuple[int, int], radius: int) -> Image.Image:
    mask = Image.new("L", size, 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return mask


def fit_height(im: Image.Image, target_h: int) -> Image.Image:
    w, h = im.size
    target_w = round(w * target_h / h)
    return im.resize((target_w, target_h), Image.LANCZOS)


def paste_rounded(canvas: Image.Image, shot: Image.Image, x: int, y: int, radius: int = 18) -> None:
    mask = rounded_mask(shot.size, radius)
    canvas.paste(shot, (x, y), mask)
    d = ImageDraw.Draw(canvas)
    d.rounded_rectangle([x, y, x + shot.size[0] - 1, y + shot.size[1] - 1],
                        radius=radius, outline=BORDER, width=2)


# ---- Platform templates ----------------------------------------------------

def fiverr_4x3(shot: Image.Image, title: str, subtitle: str) -> Image.Image:
    W, H = 1400, 1050
    canvas = Image.new("RGB", (W, H), SURFACE)
    d = ImageDraw.Draw(canvas)

    d.text((72, 56), title, fill=TEXT, font=font(40, True))
    d.text((72, 118), subtitle, fill=SECONDARY, font=font(22))

    shot_h = 800
    shot_r = fit_height(shot, shot_h)
    x = (W - shot_r.size[0]) // 2
    y = 170
    paste_rounded(canvas, shot_r, x, y)
    return canvas


def instagram_4x5(shot: Image.Image, title: str, subtitle: str) -> Image.Image:
    W, H = 1080, 1350
    canvas = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(canvas)

    d.text((72, 72), title, fill=TEXT, font=font(36, True))
    d.text((72, 128), subtitle, fill=SECONDARY, font=font(21))

    shot_h = 1020
    shot_r = fit_height(shot, shot_h)
    x = (W - shot_r.size[0]) // 2
    y = 180
    paste_rounded(canvas, shot_r, x, y)
    return canvas


def chengjubao_16x9(shot: Image.Image, title: str, subtitle: str, locale: str = "zh") -> Image.Image:
    W, H = 1920, 1080
    canvas = Image.new("RGB", (W, H), SURFACE)
    d = ImageDraw.Draw(canvas)

    d.text((72, 64), title, fill=TEXT, font=font(38, True, locale))
    d.text((72, 124), subtitle, fill=SECONDARY, font=font(22, False, locale))

    shot_h = 880
    shot_r = fit_height(shot, shot_h)
    x = (W - shot_r.size[0]) // 2
    y = (H - shot_r.size[1]) // 2
    paste_rounded(canvas, shot_r, x, y)
    return canvas


# ---- Asset manifest ---------------------------------------------------------

# English captures -> fiverr (4:3) and instagram (4:5) only.
ASSETS: list[dict] = [
    {
        "key": "01_home_menu",
        "raw": "01_home_menu_raw.png",
        "title": "Menu",
        "subtitle": "Single-store catalog — burgers, pizza, drinks and desserts",
        "platforms": ["fiverr", "instagram"],
    },
    {
        "key": "02_product_details",
        "raw": "02_product_details_raw.png",
        "title": "Dish details",
        "subtitle": "Description, rating, price and quantity before adding to cart",
        "platforms": ["fiverr", "instagram"],
    },
    {
        "key": "03_cart",
        "raw": "03_cart_raw.png",
        "title": "Shopping cart",
        "subtitle": "Adjust quantities or remove items; subtotal updates live",
        "platforms": ["fiverr", "instagram"],
    },
    {
        "key": "04_checkout",
        "raw": "04_checkout_raw.png",
        "title": "Checkout",
        "subtitle": "Delivery address, demo card or cash on delivery, order summary",
        "platforms": ["fiverr", "instagram"],
    },
    {
        "key": "05_orders",
        "raw": "05_orders_raw.png",
        "title": "Order history",
        "subtitle": "Order number, status, items, payment method and address",
        "platforms": ["fiverr", "instagram"],
    },
    {
        "key": "06_sign_in",
        "raw": "06_sign_in_raw.png",
        "title": "Sign in",
        "subtitle": "Optional account for Supabase sync; Mock mode continues as guest",
        "platforms": ["fiverr", "instagram"],
    },
]

# Chinese captures -> chengjubao 16:9 `_zh` only.
ZH_ASSETS: list[dict] = [
    {
        "key": "01_home_menu",
        "raw": "01_home_menu_raw_zh.png",
        "title": "菜单",
        "subtitle": "单店菜品目录，汉堡、披萨、饮品与甜品分类浏览",
    },
    {
        "key": "02_product_details",
        "raw": "02_product_details_raw_zh.png",
        "title": "菜品详情",
        "subtitle": "配料描述、评分、价格与数量选择，再加入购物车",
    },
    {
        "key": "03_cart",
        "raw": "03_cart_raw_zh.png",
        "title": "购物车",
        "subtitle": "调整数量或删除商品，小计实时更新",
    },
    {
        "key": "04_checkout",
        "raw": "04_checkout_raw_zh.png",
        "title": "结算",
        "subtitle": "配送地址、演示银行卡或货到付款，订单明细与合计",
    },
    {
        "key": "05_orders",
        "raw": "05_orders_raw_zh.png",
        "title": "订单记录",
        "subtitle": "订单号、状态、商品、支付方式与收货地址",
    },
    {
        "key": "06_sign_in",
        "raw": "06_sign_in_raw_zh.png",
        "title": "登录",
        "subtitle": "可选账号用于 Supabase 同步；Mock 模式可游客下单",
    },
]


def main() -> None:
    for asset in ASSETS:
        shot = load_clean(asset["raw"])
        for platform in asset["platforms"]:
            if platform == "fiverr":
                img = fiverr_4x3(shot, asset["title"], asset["subtitle"])
                out_dir = OUT / "fiverr"
                name = f"{asset['key']}_4x3.png"
            else:
                img = instagram_4x5(shot, asset["title"], asset["subtitle"])
                out_dir = OUT / "instagram"
                name = f"{asset['key']}_4x5.png"
            out_dir.mkdir(parents=True, exist_ok=True)
            img.save(out_dir / name, quality=92)
            print(f"wrote {out_dir.name}/{name} {img.size}")

    for asset in ZH_ASSETS:
        shot = load_clean(asset["raw"])
        img = chengjubao_16x9(shot, asset["title"], asset["subtitle"], locale="zh")
        out_dir = OUT / "chengjubao"
        out_dir.mkdir(parents=True, exist_ok=True)
        name = f"{asset['key']}_16x9_zh.png"
        img.save(out_dir / name, quality=92)
        print(f"wrote {out_dir.name}/{name} {img.size}")


if __name__ == "__main__":
    main()
