class StockItem {
  StockItem(this.itemName, this.itemQuantity, this.itemUnit, this.rate,
      this.subtotal, this.currentStock, this.docID);
  late String itemName;
  late int itemQuantity;
  late double subtotal;
  late String itemUnit;
  late double rate;
  int? currentStock;
  late String docID;

  StockItem.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemQuantity = json['itemQuantity'];
    subtotal = json['itemSubTotal'];
    itemUnit = json['itemunit'];
    currentStock = json['currentStock'];
    docID = json['docID'];
    rate = json['itemrate'];
  }

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "itemQuantity": itemQuantity,
        "itemSubTotal": subtotal,
        "itemunit": itemUnit,
        "docID": docID,
        "itemrate": rate,
        "currentStock": currentStock
      };
}
