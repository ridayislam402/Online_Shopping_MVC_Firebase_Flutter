
const String checkoutProductId = 'productId';
const String checkoutProductName = 'productName';
const String checkoutProductImage = 'productImage';
const String checkoutProductPrice = 'productPrice';
const String checkoutProductQuantity = 'productQuantity';
const String checkoutProductStock = 'productStock';
const String checkoutProductCategory = 'productCategory';

class CheckoutModel{
  String? productId, productName, imageUrl, category;
  num salePrice, quantity, stock;


  CheckoutModel(
      {this.productId,
        this.productName,
        this.imageUrl,
        this.category,
        required this.salePrice,
        required this.stock,
        this.quantity = 1});

  Map<String, dynamic> toMap(){
    return <String, dynamic> {
      checkoutProductId : productId,
      checkoutProductName : productName,
      checkoutProductImage : imageUrl,
      checkoutProductPrice : salePrice,
      checkoutProductQuantity : quantity,
      checkoutProductStock : stock,
      checkoutProductCategory : category,
    };
  }

  factory CheckoutModel.fromMap(Map<String, dynamic> map){
    return CheckoutModel(
      productId: map[checkoutProductId],
      productName: map[checkoutProductName],
      imageUrl: map[checkoutProductImage],
      salePrice: map[checkoutProductPrice],
      quantity: map[checkoutProductQuantity],
      stock: map[checkoutProductStock],
      category: map[checkoutProductCategory],
    );
  }
}