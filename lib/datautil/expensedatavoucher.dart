class ExpenseItems {
  ExpenseItems(
      this.itemName, this.quantity, this.price, this.description, this.amount);
  String? itemName;
  int? quantity;
  String? description;
  double? price;
  double? amount;

  ExpenseItems.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    quantity = json['itemQuantity'];
    amount = json['itemSubTotal'];
    description = json['itemDescription'];
    price = json['itemrate'];
  }

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemQuantity": quantity,
        "itemDescription": description,
        "itemSubTotal": amount,
        "itemrate": price
      };
}
