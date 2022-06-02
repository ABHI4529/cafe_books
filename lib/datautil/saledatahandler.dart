class SaleHandler {
  SaleHandler(this.itemName, this.itemQuantity, this.itemUnit, this.rate,
      this.discount, this.subtotal);
  String itemName;
  int itemQuantity;
  double subtotal;
  String itemUnit;
  double rate;
  double discount;

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemQuantity": itemQuantity,
        "itemSubTotal": subtotal,
        "itemunit": itemUnit,
        "itemdiscount": discount,
        "itemrate": rate
      };
}
