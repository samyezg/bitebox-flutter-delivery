-- BiteBox single-store menu + authenticated orders (phase 5)

create table if not exists public.menu_items (
  id text primary key,
  name text not null,
  description text not null,
  category text not null check (category in ('burger', 'pizza', 'drink', 'dessert')),
  price_in_cents integer not null check (price_in_cents >= 0),
  rating numeric(2, 1) not null check (rating >= 0 and rating <= 5),
  image_asset_path text,
  available boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists menu_items_category_sort_idx
  on public.menu_items (category, sort_order, id);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number bigserial,
  user_id uuid not null references auth.users (id) on delete cascade,
  total_cents integer not null check (total_cents >= 0),
  status text not null,
  address_text text not null,
  payment_method text not null,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists orders_user_id_created_at_idx
  on public.orders (user_id, created_at desc);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  item_id text not null,
  name text not null,
  price_in_cents integer not null check (price_in_cents >= 0),
  quantity integer not null check (quantity > 0),
  category text not null check (category in ('burger', 'pizza', 'drink', 'dessert'))
);

create index if not exists order_items_order_id_idx
  on public.order_items (order_id);

alter table public.menu_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

-- Public menu readable by everyone (anon browse + authenticated)
drop policy if exists menu_items_select_all on public.menu_items;
create policy menu_items_select_all
  on public.menu_items
  for select
  to anon, authenticated
  using (true);

drop policy if exists orders_select_own on public.orders;
create policy orders_select_own
  on public.orders
  for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists orders_insert_own on public.orders;
create policy orders_insert_own
  on public.orders
  for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists order_items_select_own on public.order_items;
create policy order_items_select_own
  on public.order_items
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.orders o
      where o.id = order_id and o.user_id = auth.uid()
    )
  );

drop policy if exists order_items_insert_own on public.order_items;
create policy order_items_insert_own
  on public.order_items
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.orders o
      where o.id = order_id and o.user_id = auth.uid()
    )
  );

grant usage on schema public to anon, authenticated;
grant select on table public.menu_items to anon, authenticated;
grant select, insert on table public.orders to authenticated;
grant select, insert on table public.order_items to authenticated;
grant usage, select on sequence public.orders_order_number_seq to authenticated;

insert into public.menu_items (
  id, name, description, category, price_in_cents, rating, sort_order
) values
  ('classic-beef-burger', 'Classic Beef Burger', 'Angus beef patty, lettuce, tomato, pickles, and house sauce on a toasted bun.', 'burger', 899, 4.5, 1),
  ('double-cheeseburger', 'Double Cheeseburger', 'Two beef patties, melted cheddar, onions, and special sauce.', 'burger', 1199, 4.7, 2),
  ('chicken-burger', 'Chicken Burger', 'Crispy chicken fillet, slaw, and spicy mayo in a soft brioche bun.', 'burger', 799, 4.3, 3),
  ('margherita-pizza', 'Margherita Pizza', 'San Marzano tomato, fresh mozzarella, basil, and olive oil on thin crust.', 'pizza', 1299, 4.6, 4),
  ('pepperoni-pizza', 'Pepperoni Pizza', 'Classic pepperoni, mozzarella, and oregano over tomato sauce.', 'pizza', 1499, 4.8, 5),
  ('veggie-supreme', 'Veggie Supreme', 'Peppers, mushrooms, olives, onions, and mozzarella on a crispy base.', 'pizza', 1399, 4.2, 6),
  ('iced-lemon-tea', 'Iced Lemon Tea', 'Brewed black tea with fresh lemon, lightly sweetened and chilled.', 'drink', 299, 4.4, 7),
  ('fresh-orange-juice', 'Fresh Orange Juice', 'Freshly squeezed oranges, no concentrate, served cold.', 'drink', 399, 4.6, 8),
  ('cola', 'Cola', 'Classic cola over ice. 12 oz can.', 'drink', 199, 4.1, 9),
  ('chocolate-lava-cake', 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center, served with cream.', 'dessert', 599, 4.9, 10),
  ('ny-cheesecake', 'New York Cheesecake', 'Dense creamy cheesecake on a graham crust with berry glaze.', 'dessert', 699, 4.5, 11),
  ('tiramisu', 'Tiramisu', 'Espresso-soaked ladyfingers, mascarpone cream, and cocoa.', 'dessert', 699, 4.7, 12)
on conflict (id) do update set
  name = excluded.name,
  description = excluded.description,
  category = excluded.category,
  price_in_cents = excluded.price_in_cents,
  rating = excluded.rating,
  sort_order = excluded.sort_order,
  available = true;
