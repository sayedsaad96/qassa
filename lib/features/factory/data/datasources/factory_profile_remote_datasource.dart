import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/upload_image_params.dart';
import '../models/factory_profile_model.dart';

abstract class FactoryProfileRemoteDataSource {
  Future<FactoryProfileModel?> getProfile(String ownerId);
  Future<FactoryProfileModel> createProfile(FactoryProfileModel profile);
  Future<FactoryProfileModel> updateProfile(FactoryProfileModel profile);
  Future<List<String>> uploadPortfolioImages(
    String ownerId,
    List<UploadImageParams> images,
  );
}

class FactoryProfileRemoteDataSourceImpl
    implements FactoryProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  FactoryProfileRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<FactoryProfileModel?> getProfile(String ownerId) async {
    try {
      final response = await supabaseClient
          .from('factories')
          .select()
          .eq('owner_id', ownerId)
          .maybeSingle();

      if (response == null) return null;
      return FactoryProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get factory profile: $e');
    }
  }

  @override
  Future<FactoryProfileModel> createProfile(FactoryProfileModel profile) async {
    try {
      // Build insert payload — exclude server-generated id
      final data = profile.toJson()..remove('id');

      final response = await supabaseClient
          .from('factories')
          .insert(data)
          .select()
          .single();

      return FactoryProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create factory profile: $e');
    }
  }

  @override
  Future<FactoryProfileModel> updateProfile(FactoryProfileModel profile) async {
    try {
      final response = await supabaseClient
          .from('factories')
          .update(profile.toJson())
          .eq('owner_id', profile.ownerId)
          .select()
          .single();

      return FactoryProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update factory profile: $e');
    }
  }

  @override
  Future<List<String>> uploadPortfolioImages(
    String ownerId,
    List<UploadImageParams> images,
  ) async {
    final List<String> uploadedUrls = [];

    for (var image in images) {
      final fileExtension = image.fileName.split('.').last;
      final uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.fileName.hashCode}.$fileExtension';
      final path = '$ownerId/$uniqueName';

      try {
        await supabaseClient.storage
            .from('factory-images')
            .uploadBinary(
              path,
              image.bytes,
              fileOptions: const FileOptions(upsert: true),
            );

        final url = supabaseClient.storage
            .from('factory-images')
            .getPublicUrl(path);
        uploadedUrls.add(url);
      } catch (e) {
        throw Exception('Failed to upload image ${image.fileName}: $e');
      }
    }

    return uploadedUrls;
  }
}
