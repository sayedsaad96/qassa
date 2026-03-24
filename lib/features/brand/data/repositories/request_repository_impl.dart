import 'package:dartz/dartz.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_datasource.dart';
import '../models/models.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource _ds;
  RequestRepositoryImpl(this._ds);

  @override
  Future<Either<String, List<RequestEntity>>> getRequestsByBrand(
      String brandId) async {
    try {
      final data = await _ds.getRequestsByBrand(brandId);
      return Right(data.map((j) => RequestModel.fromJson(j).toEntity()).toList());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, List<RequestEntity>>> getAllActiveRequests(
      {String? specialty}) async {
    try {
      final data = await _ds.getAllActiveRequests(specialty: specialty);
      return Right(data.map((j) => RequestModel.fromJson(j).toEntity()).toList());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, RequestEntity>> getRequestById(
      String requestId) async {
    try {
      final data = await _ds.getRequestById(requestId);
      return Right(RequestModel.fromJson(data).toEntity());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, RequestEntity>> createRequest(
      RequestEntity req) async {
    try {
      final insertData = {
        'brand_id': req.brandId,
        'brand_name': req.brandName,
        'brand_avatar_initial': req.brandAvatarInitial,
        'product_type': req.productType,
        'quantity': req.quantity,
        'material': req.material,
        if (req.targetPricePerPiece != null)
          'target_price_per_piece': req.targetPricePerPiece,
        if (req.notes != null) 'notes': req.notes,
        if (req.referenceImageUrl != null)
          'reference_image_url': req.referenceImageUrl,
        'status': 'active',
      };
      final result = await _ds.createRequest(insertData);
      return Right(RequestModel.fromJson(result).toEntity());
    } catch (e) {
      return Left(_err(e));
    }
  }

  @override
  Future<Either<String, void>> cancelRequest(String requestId) async {
    try {
      await _ds.updateRequestStatus(requestId, 'cancelled');
      return const Right(null);
    } catch (e) {
      return Left(_err(e));
    }
  }

  String _err(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('network') || s.contains('socket') ||
        s.contains('connection')) {
      return 'في مشكلة في الإنترنت، جرب تاني';
    }
    return 'حدث خطأ، حاول مرة أخرى';
  }
}
