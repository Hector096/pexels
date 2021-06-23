import 'package:dio/dio.dart';
import 'package:pexels/data/model/imageModel.dart';
import 'package:pexels/data/util/apiKey.dart';
import 'package:pexels/data/util/dioClient.dart';

class ImageRepo {
  Dio dio = Dio();

  Future<ImageModel> getImages([String? offset]) async {
    final DioClient dioCl = DioClient(dio);
    var params = {"page": offset};
    try {
      dynamic response = await dioCl.get(imageUrl,
          options: Options(headers: {"Authorization": apiKey}),
          queryParameters: params);
      return ImageModel.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
