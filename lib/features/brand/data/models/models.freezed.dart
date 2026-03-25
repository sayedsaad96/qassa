// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FactoryModel {

 String get id;@JsonKey(name: 'owner_id') String get ownerId; String get name; String get city; List<String> get specialties;@JsonKey(name: 'min_quantity') int get minQuantity;@JsonKey(name: 'lead_time_days') int get leadTimeDays; double get rating;@JsonKey(name: 'review_count') int get reviewCount;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;@JsonKey(name: 'portfolio_images') List<String> get portfolioImages;@JsonKey(name: 'is_fast_responder') bool get isFastResponder;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of FactoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactoryModelCopyWith<FactoryModel> get copyWith => _$FactoryModelCopyWithImpl<FactoryModel>(this as FactoryModel, _$identity);

  /// Serializes this FactoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.portfolioImages, portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(portfolioImages),isFastResponder,createdAt);

@override
String toString() {
  return 'FactoryModel(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FactoryModelCopyWith<$Res>  {
  factory $FactoryModelCopyWith(FactoryModel value, $Res Function(FactoryModel) _then) = _$FactoryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String city, List<String> specialties,@JsonKey(name: 'min_quantity') int minQuantity,@JsonKey(name: 'lead_time_days') int leadTimeDays, double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'portfolio_images') List<String> portfolioImages,@JsonKey(name: 'is_fast_responder') bool isFastResponder,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$FactoryModelCopyWithImpl<$Res>
    implements $FactoryModelCopyWith<$Res> {
  _$FactoryModelCopyWithImpl(this._self, this._then);

  final FactoryModel _self;
  final $Res Function(FactoryModel) _then;

/// Create a copy of FactoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,specialties: null == specialties ? _self.specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,minQuantity: null == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int,leadTimeDays: null == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,portfolioImages: null == portfolioImages ? _self.portfolioImages : portfolioImages // ignore: cast_nullable_to_non_nullable
as List<String>,isFastResponder: null == isFastResponder ? _self.isFastResponder : isFastResponder // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FactoryModel].
extension FactoryModelPatterns on FactoryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactoryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactoryModel value)  $default,){
final _that = this;
switch (_that) {
case _FactoryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _FactoryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactoryModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FactoryModel():
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FactoryModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FactoryModel extends FactoryModel {
  const _FactoryModel({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, required this.city, final  List<String> specialties = const [], @JsonKey(name: 'min_quantity') this.minQuantity = 100, @JsonKey(name: 'lead_time_days') this.leadTimeDays = 21, this.rating = 0.0, @JsonKey(name: 'review_count') this.reviewCount = 0, @JsonKey(name: 'cover_image_url') this.coverImageUrl, @JsonKey(name: 'portfolio_images') final  List<String> portfolioImages = const [], @JsonKey(name: 'is_fast_responder') this.isFastResponder = false, @JsonKey(name: 'created_at') required this.createdAt}): _specialties = specialties,_portfolioImages = portfolioImages,super._();
  factory _FactoryModel.fromJson(Map<String, dynamic> json) => _$FactoryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'owner_id') final  String ownerId;
@override final  String name;
@override final  String city;
 final  List<String> _specialties;
@override@JsonKey() List<String> get specialties {
  if (_specialties is EqualUnmodifiableListView) return _specialties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialties);
}

@override@JsonKey(name: 'min_quantity') final  int minQuantity;
@override@JsonKey(name: 'lead_time_days') final  int leadTimeDays;
@override@JsonKey() final  double rating;
@override@JsonKey(name: 'review_count') final  int reviewCount;
@override@JsonKey(name: 'cover_image_url') final  String? coverImageUrl;
 final  List<String> _portfolioImages;
@override@JsonKey(name: 'portfolio_images') List<String> get portfolioImages {
  if (_portfolioImages is EqualUnmodifiableListView) return _portfolioImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_portfolioImages);
}

@override@JsonKey(name: 'is_fast_responder') final  bool isFastResponder;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of FactoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactoryModelCopyWith<_FactoryModel> get copyWith => __$FactoryModelCopyWithImpl<_FactoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FactoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._portfolioImages, _portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(_specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(_portfolioImages),isFastResponder,createdAt);

@override
String toString() {
  return 'FactoryModel(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FactoryModelCopyWith<$Res> implements $FactoryModelCopyWith<$Res> {
  factory _$FactoryModelCopyWith(_FactoryModel value, $Res Function(_FactoryModel) _then) = __$FactoryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String city, List<String> specialties,@JsonKey(name: 'min_quantity') int minQuantity,@JsonKey(name: 'lead_time_days') int leadTimeDays, double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'portfolio_images') List<String> portfolioImages,@JsonKey(name: 'is_fast_responder') bool isFastResponder,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$FactoryModelCopyWithImpl<$Res>
    implements _$FactoryModelCopyWith<$Res> {
  __$FactoryModelCopyWithImpl(this._self, this._then);

  final _FactoryModel _self;
  final $Res Function(_FactoryModel) _then;

/// Create a copy of FactoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,Object? createdAt = null,}) {
  return _then(_FactoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,specialties: null == specialties ? _self._specialties : specialties // ignore: cast_nullable_to_non_nullable
as List<String>,minQuantity: null == minQuantity ? _self.minQuantity : minQuantity // ignore: cast_nullable_to_non_nullable
as int,leadTimeDays: null == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,coverImageUrl: freezed == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String?,portfolioImages: null == portfolioImages ? _self._portfolioImages : portfolioImages // ignore: cast_nullable_to_non_nullable
as List<String>,isFastResponder: null == isFastResponder ? _self.isFastResponder : isFastResponder // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RequestModel {

 String get id;@JsonKey(name: 'brand_id') String get brandId;@JsonKey(name: 'brand_name') String get brandName;@JsonKey(name: 'brand_avatar_initial') String? get brandAvatarInitial;@JsonKey(name: 'product_type') String get productType; int get quantity; String get material; String get quality;@JsonKey(name: 'target_price_per_piece') double? get targetPricePerPiece; String? get notes;@JsonKey(name: 'reference_image_url') String? get referenceImageUrl; String get status;@JsonKey(name: 'offer_count') int get offerCount;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'request_number') String? get requestNumber;
/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestModelCopyWith<RequestModel> get copyWith => _$RequestModelCopyWithImpl<RequestModel>(this as RequestModel, _$identity);

  /// Serializes this RequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandAvatarInitial, brandAvatarInitial) || other.brandAvatarInitial == brandAvatarInitial)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.material, material) || other.material == material)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.targetPricePerPiece, targetPricePerPiece) || other.targetPricePerPiece == targetPricePerPiece)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.referenceImageUrl, referenceImageUrl) || other.referenceImageUrl == referenceImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestNumber, requestNumber) || other.requestNumber == requestNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,brandId,brandName,brandAvatarInitial,productType,quantity,material,quality,targetPricePerPiece,notes,referenceImageUrl,status,offerCount,createdAt,requestNumber);

@override
String toString() {
  return 'RequestModel(id: $id, brandId: $brandId, brandName: $brandName, brandAvatarInitial: $brandAvatarInitial, productType: $productType, quantity: $quantity, material: $material, quality: $quality, targetPricePerPiece: $targetPricePerPiece, notes: $notes, referenceImageUrl: $referenceImageUrl, status: $status, offerCount: $offerCount, createdAt: $createdAt, requestNumber: $requestNumber)';
}


}

/// @nodoc
abstract mixin class $RequestModelCopyWith<$Res>  {
  factory $RequestModelCopyWith(RequestModel value, $Res Function(RequestModel) _then) = _$RequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'brand_id') String brandId,@JsonKey(name: 'brand_name') String brandName,@JsonKey(name: 'brand_avatar_initial') String? brandAvatarInitial,@JsonKey(name: 'product_type') String productType, int quantity, String material, String quality,@JsonKey(name: 'target_price_per_piece') double? targetPricePerPiece, String? notes,@JsonKey(name: 'reference_image_url') String? referenceImageUrl, String status,@JsonKey(name: 'offer_count') int offerCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'request_number') String? requestNumber
});




}
/// @nodoc
class _$RequestModelCopyWithImpl<$Res>
    implements $RequestModelCopyWith<$Res> {
  _$RequestModelCopyWithImpl(this._self, this._then);

  final RequestModel _self;
  final $Res Function(RequestModel) _then;

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? brandId = null,Object? brandName = null,Object? brandAvatarInitial = freezed,Object? productType = null,Object? quantity = null,Object? material = null,Object? quality = null,Object? targetPricePerPiece = freezed,Object? notes = freezed,Object? referenceImageUrl = freezed,Object? status = null,Object? offerCount = null,Object? createdAt = null,Object? requestNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandId: null == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,brandAvatarInitial: freezed == brandAvatarInitial ? _self.brandAvatarInitial : brandAvatarInitial // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,targetPricePerPiece: freezed == targetPricePerPiece ? _self.targetPricePerPiece : targetPricePerPiece // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,referenceImageUrl: freezed == referenceImageUrl ? _self.referenceImageUrl : referenceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requestNumber: freezed == requestNumber ? _self.requestNumber : requestNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestModel].
extension RequestModelPatterns on RequestModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestModel value)  $default,){
final _that = this;
switch (_that) {
case _RequestModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'brand_id')  String brandId, @JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'brand_avatar_initial')  String? brandAvatarInitial, @JsonKey(name: 'product_type')  String productType,  int quantity,  String material,  String quality, @JsonKey(name: 'target_price_per_piece')  double? targetPricePerPiece,  String? notes, @JsonKey(name: 'reference_image_url')  String? referenceImageUrl,  String status, @JsonKey(name: 'offer_count')  int offerCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'request_number')  String? requestNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that.id,_that.brandId,_that.brandName,_that.brandAvatarInitial,_that.productType,_that.quantity,_that.material,_that.quality,_that.targetPricePerPiece,_that.notes,_that.referenceImageUrl,_that.status,_that.offerCount,_that.createdAt,_that.requestNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'brand_id')  String brandId, @JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'brand_avatar_initial')  String? brandAvatarInitial, @JsonKey(name: 'product_type')  String productType,  int quantity,  String material,  String quality, @JsonKey(name: 'target_price_per_piece')  double? targetPricePerPiece,  String? notes, @JsonKey(name: 'reference_image_url')  String? referenceImageUrl,  String status, @JsonKey(name: 'offer_count')  int offerCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'request_number')  String? requestNumber)  $default,) {final _that = this;
switch (_that) {
case _RequestModel():
return $default(_that.id,_that.brandId,_that.brandName,_that.brandAvatarInitial,_that.productType,_that.quantity,_that.material,_that.quality,_that.targetPricePerPiece,_that.notes,_that.referenceImageUrl,_that.status,_that.offerCount,_that.createdAt,_that.requestNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'brand_id')  String brandId, @JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'brand_avatar_initial')  String? brandAvatarInitial, @JsonKey(name: 'product_type')  String productType,  int quantity,  String material,  String quality, @JsonKey(name: 'target_price_per_piece')  double? targetPricePerPiece,  String? notes, @JsonKey(name: 'reference_image_url')  String? referenceImageUrl,  String status, @JsonKey(name: 'offer_count')  int offerCount, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'request_number')  String? requestNumber)?  $default,) {final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that.id,_that.brandId,_that.brandName,_that.brandAvatarInitial,_that.productType,_that.quantity,_that.material,_that.quality,_that.targetPricePerPiece,_that.notes,_that.referenceImageUrl,_that.status,_that.offerCount,_that.createdAt,_that.requestNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestModel extends RequestModel {
  const _RequestModel({required this.id, @JsonKey(name: 'brand_id') required this.brandId, @JsonKey(name: 'brand_name') this.brandName = 'براند', @JsonKey(name: 'brand_avatar_initial') this.brandAvatarInitial, @JsonKey(name: 'product_type') required this.productType, required this.quantity, this.material = 'مش محدد', this.quality = 'medium', @JsonKey(name: 'target_price_per_piece') this.targetPricePerPiece, this.notes, @JsonKey(name: 'reference_image_url') this.referenceImageUrl, this.status = 'active', @JsonKey(name: 'offer_count') this.offerCount = 0, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'request_number') this.requestNumber}): super._();
  factory _RequestModel.fromJson(Map<String, dynamic> json) => _$RequestModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'brand_id') final  String brandId;
@override@JsonKey(name: 'brand_name') final  String brandName;
@override@JsonKey(name: 'brand_avatar_initial') final  String? brandAvatarInitial;
@override@JsonKey(name: 'product_type') final  String productType;
@override final  int quantity;
@override@JsonKey() final  String material;
@override@JsonKey() final  String quality;
@override@JsonKey(name: 'target_price_per_piece') final  double? targetPricePerPiece;
@override final  String? notes;
@override@JsonKey(name: 'reference_image_url') final  String? referenceImageUrl;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'offer_count') final  int offerCount;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'request_number') final  String? requestNumber;

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestModelCopyWith<_RequestModel> get copyWith => __$RequestModelCopyWithImpl<_RequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandAvatarInitial, brandAvatarInitial) || other.brandAvatarInitial == brandAvatarInitial)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.material, material) || other.material == material)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.targetPricePerPiece, targetPricePerPiece) || other.targetPricePerPiece == targetPricePerPiece)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.referenceImageUrl, referenceImageUrl) || other.referenceImageUrl == referenceImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestNumber, requestNumber) || other.requestNumber == requestNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,brandId,brandName,brandAvatarInitial,productType,quantity,material,quality,targetPricePerPiece,notes,referenceImageUrl,status,offerCount,createdAt,requestNumber);

@override
String toString() {
  return 'RequestModel(id: $id, brandId: $brandId, brandName: $brandName, brandAvatarInitial: $brandAvatarInitial, productType: $productType, quantity: $quantity, material: $material, quality: $quality, targetPricePerPiece: $targetPricePerPiece, notes: $notes, referenceImageUrl: $referenceImageUrl, status: $status, offerCount: $offerCount, createdAt: $createdAt, requestNumber: $requestNumber)';
}


}

/// @nodoc
abstract mixin class _$RequestModelCopyWith<$Res> implements $RequestModelCopyWith<$Res> {
  factory _$RequestModelCopyWith(_RequestModel value, $Res Function(_RequestModel) _then) = __$RequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'brand_id') String brandId,@JsonKey(name: 'brand_name') String brandName,@JsonKey(name: 'brand_avatar_initial') String? brandAvatarInitial,@JsonKey(name: 'product_type') String productType, int quantity, String material, String quality,@JsonKey(name: 'target_price_per_piece') double? targetPricePerPiece, String? notes,@JsonKey(name: 'reference_image_url') String? referenceImageUrl, String status,@JsonKey(name: 'offer_count') int offerCount,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'request_number') String? requestNumber
});




}
/// @nodoc
class __$RequestModelCopyWithImpl<$Res>
    implements _$RequestModelCopyWith<$Res> {
  __$RequestModelCopyWithImpl(this._self, this._then);

  final _RequestModel _self;
  final $Res Function(_RequestModel) _then;

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brandId = null,Object? brandName = null,Object? brandAvatarInitial = freezed,Object? productType = null,Object? quantity = null,Object? material = null,Object? quality = null,Object? targetPricePerPiece = freezed,Object? notes = freezed,Object? referenceImageUrl = freezed,Object? status = null,Object? offerCount = null,Object? createdAt = null,Object? requestNumber = freezed,}) {
  return _then(_RequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandId: null == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,brandAvatarInitial: freezed == brandAvatarInitial ? _self.brandAvatarInitial : brandAvatarInitial // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,targetPricePerPiece: freezed == targetPricePerPiece ? _self.targetPricePerPiece : targetPricePerPiece // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,referenceImageUrl: freezed == referenceImageUrl ? _self.referenceImageUrl : referenceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requestNumber: freezed == requestNumber ? _self.requestNumber : requestNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
