import 'package:bitebox_app/features/catalog/domain/food_category.dart';
import 'package:bitebox_app/features/catalog/domain/food_item.dart';

/// BiteBox Kitchen — 12 Mock SKUs (phase 1). Real photos can replace placeholders later.
const List<FoodItem> kMockFoodItems = [
  FoodItem(
    id: 'classic-beef-burger',
    name: 'Classic Beef Burger',
    description:
        'Angus beef patty, lettuce, tomato, pickles, and house sauce on a toasted bun.',
    category: FoodCategory.burger,
    priceInCents: 899,
    rating: 4.5,
  ),
  FoodItem(
    id: 'double-cheeseburger',
    name: 'Double Cheeseburger',
    description:
        'Two beef patties, melted cheddar, onions, and special sauce.',
    category: FoodCategory.burger,
    priceInCents: 1199,
    rating: 4.7,
  ),
  FoodItem(
    id: 'chicken-burger',
    name: 'Chicken Burger',
    description:
        'Crispy chicken fillet, slaw, and spicy mayo in a soft brioche bun.',
    category: FoodCategory.burger,
    priceInCents: 799,
    rating: 4.3,
  ),
  FoodItem(
    id: 'margherita-pizza',
    name: 'Margherita Pizza',
    description:
        'San Marzano tomato, fresh mozzarella, basil, and olive oil on thin crust.',
    category: FoodCategory.pizza,
    priceInCents: 1299,
    rating: 4.6,
  ),
  FoodItem(
    id: 'pepperoni-pizza',
    name: 'Pepperoni Pizza',
    description:
        'Classic pepperoni, mozzarella, and oregano over tomato sauce.',
    category: FoodCategory.pizza,
    priceInCents: 1499,
    rating: 4.8,
  ),
  FoodItem(
    id: 'veggie-supreme',
    name: 'Veggie Supreme',
    description:
        'Peppers, mushrooms, olives, onions, and mozzarella on a crispy base.',
    category: FoodCategory.pizza,
    priceInCents: 1399,
    rating: 4.2,
  ),
  FoodItem(
    id: 'iced-lemon-tea',
    name: 'Iced Lemon Tea',
    description: 'Brewed black tea with fresh lemon, lightly sweetened and chilled.',
    category: FoodCategory.drink,
    priceInCents: 299,
    rating: 4.4,
  ),
  FoodItem(
    id: 'fresh-orange-juice',
    name: 'Fresh Orange Juice',
    description: 'Freshly squeezed oranges, no concentrate, served cold.',
    category: FoodCategory.drink,
    priceInCents: 399,
    rating: 4.6,
  ),
  FoodItem(
    id: 'cola',
    name: 'Cola',
    description: 'Classic cola over ice. 12 oz can.',
    category: FoodCategory.drink,
    priceInCents: 199,
    rating: 4.1,
  ),
  FoodItem(
    id: 'chocolate-lava-cake',
    name: 'Chocolate Lava Cake',
    description: 'Warm chocolate cake with a molten center, served with cream.',
    category: FoodCategory.dessert,
    priceInCents: 599,
    rating: 4.9,
  ),
  FoodItem(
    id: 'ny-cheesecake',
    name: 'New York Cheesecake',
    description: 'Dense creamy cheesecake on a graham crust with berry glaze.',
    category: FoodCategory.dessert,
    priceInCents: 699,
    rating: 4.5,
  ),
  FoodItem(
    id: 'tiramisu',
    name: 'Tiramisu',
    description: 'Espresso-soaked ladyfingers, mascarpone cream, and cocoa.',
    category: FoodCategory.dessert,
    priceInCents: 699,
    rating: 4.7,
  ),
];
