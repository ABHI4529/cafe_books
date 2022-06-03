class SaleHandler {
  SaleHandler(this.itemName, this.itemQuantity, this.itemUnit, this.rate,
      this.discount, this.subtotal);
  late String itemName;
  late int itemQuantity;
  late double subtotal;
  late String itemUnit;
  late double rate;
  late double discount;

  SaleHandler.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemQuantity = json['itemQuantity'];
    subtotal = json['itemSubTotal'];
    itemUnit = json['itemunit'];
    discount = json['itemdiscount'];
    rate = json['itemrate'];
  }

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemQuantity": itemQuantity,
        "itemSubTotal": subtotal,
        "itemunit": itemUnit,
        "itemdiscount": discount,
        "itemrate": rate
      };
}
