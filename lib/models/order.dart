//Order class
class Order{
  
  String id;
  String driver;
  String destination;
  String truck;

  Map<String, dynamic> map;

  Order(this.id, this.map, this.driver, this.destination, this.truck);
}