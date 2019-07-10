//Product Object Class
class Product{
  String name;
  String barcode;
  String code;
  bool loaded=false;
  int qty=1;
  //Constructor
Product(this.name, this.barcode, this.code);

// Return Quantity
int get prodQty{
  return qty;
}
}

