const String productId = 'id';
const String productName = 'name';
const String productCategory = 'category';
const String productDescription = 'description';
const String productImageUrl = 'imageUrl';
const String productSalesPrice = 'salesPrice';
const String productFeatured = 'featured';
const String productAvailable = 'available';
const String productStock = 'stock';
const String productRating = 'rating';
const String productSize = 'size';



class ProductModel{
  String? id, description;
  String name, category, imageUrl;
  num salesPrice, stock;
  double rating;
  bool featured, available;
  String? size = 'free';

  ProductModel({
      this.id,
      this.description,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.salesPrice,
    this.stock = 0,
    this.rating = 0.0,
    this.featured = true,
    this.available = true,
    this.size,
  });

  Map<String, dynamic> toMap(){
    return<String, dynamic>{
      productId: id,
      productName: name,
      productCategory: category,
      productDescription: description,
      productImageUrl: imageUrl,
      productSalesPrice: salesPrice,
      productFeatured: featured,
      productAvailable: available,
      productStock: stock,
      productRating: rating,
      productSize: size,
    };
  }

  factory ProductModel.fromMap(Map<String,dynamic> map){
    return ProductModel(
      id: map[productId],
      name: map[productName],
      category: map[productCategory],
      description: map[productDescription],
      imageUrl: map[productImageUrl],
      salesPrice: map[productSalesPrice],
      featured: map[productFeatured],
      available: map[productAvailable],
      stock: map[productStock] ?? 10,
      rating: map[productRating] ?? 0.0,
      size: map[productSize]
    );
  }
}