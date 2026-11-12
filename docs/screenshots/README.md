# Screenshots & demo (public slice)

This folder is the **GitHub-facing gallery only**: one English set, flat under `docs/screenshots/`.  
Do **not** re-upload marketplace channel crops (Fiverr / Instagram / Chengjubao) or `raw/` here — those stay in the local working tree (`app/docs/screenshots/…`) to avoid duplicate assets in the public repo.

## Included

| File | Ratio | Language | Purpose |
| :--- | :--- | :--- | :--- |
| `01_home_menu_4x3.png` … `06_sign_in_4x3.png` | 4:3 | English | README / marketplace stills |
| `architecture.png` | 16:9 | English | System overview |
| `demo_video.mp4` | — | English UI | Short ordering-loop demo |

## Still list (core ordering loop)

| # | File | Page | Focus |
| :--- | :--- | :--- | :--- |
| 01 | `01_home_menu_4x3.png` | Menu | Search, category chips, dish list |
| 02 | `02_product_details_4x3.png` | Dish detail | Hero, Add to cart |
| 03 | `03_cart_4x3.png` | Cart | Lines, subtotal, Checkout |
| 04 | `04_checkout_4x3.png` | Checkout | Address, payment, Place order |
| 05 | `05_orders_4x3.png` | Orders | Order card snapshot |
| 06 | `06_sign_in_4x3.png` | Sign in | Welcome title → email form (no dev-mode subtitle) |

## Naming

- Public: `NN_<screen>_4x3.png` at this folder root (no `fiverr/` subfolder)
- Demo clip: `demo_video.mp4` at this folder root
- Local-only (not in this slice): `raw/`, `fiverr/`, `instagram/`, `chengjubao/` under the working `app/` tree

## 30–60s demo script

1. Open Menu → filter Burgers → open Classic Beef Burger  
2. Add to cart → open Cart → Checkout  
3. Place order as guest → show Orders  
4. Optional: Sign in screen  

## Policy

Keep **one flat English gallery** in this public folder. Do not commit multi-channel crops or unedited `raw/` captures — those belong only in the private working tree.
