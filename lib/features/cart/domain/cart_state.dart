import 'package:bitebox_app/features/cart/domain/cart_line.dart';

class CartState {
  const CartState({this.lines = const []});

  final List<CartLine> lines;

  bool get isEmpty => lines.isEmpty;

  int get totalItemCount =>
      lines.fold(0, (sum, line) => sum + line.quantity);

  int get subtotalInCents =>
      lines.fold(0, (sum, line) => sum + line.lineTotalInCents);

  CartLine? lineFor(String itemId) {
    for (final line in lines) {
      if (line.itemId == itemId) return line;
    }
    return null;
  }
}
