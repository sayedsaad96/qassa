import 'package:dartz/dartz.dart';
import '../entities/entities.dart';

abstract class RequestRepository {
  Future<Either<String, List<RequestEntity>>> getRequestsByBrand(String brandId);
  Future<Either<String, List<RequestEntity>>> getAllActiveRequests({String? specialty});
  Future<Either<String, RequestEntity>> getRequestById(String requestId);
  Future<Either<String, RequestEntity>> createRequest(RequestEntity request);
  Future<Either<String, void>> cancelRequest(String requestId);
}
