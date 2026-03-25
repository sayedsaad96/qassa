// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FactoryEntity {

 String get id; String get ownerId; String get name; String get city; List<String> get specialties; int get minQuantity; int get leadTimeDays; double get rating; int get reviewCount; String? get coverImageUrl; List<String> get portfolioImages; bool get isFastResponder; DateTime get createdAt;
/// Create a copy of FactoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactoryEntityCopyWith<FactoryEntity> get copyWith => _$FactoryEntityCopyWithImpl<FactoryEntity>(this as FactoryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.portfolioImages, portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(portfolioImages),isFastResponder,createdAt);

@override
String toString() {
  return 'FactoryEntity(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FactoryEntityCopyWith<$Res>  {
  factory $FactoryEntityCopyWith(FactoryEntity value, $Res Function(FactoryEntity) _then) = _$FactoryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String city, List<String> specialties, int minQuantity, int leadTimeDays, double rating, int reviewCount, String? coverImageUrl, List<String> portfolioImages, bool isFastResponder, DateTime createdAt
});




}
/// @nodoc
class _$FactoryEntityCopyWithImpl<$Res>
    implements $FactoryEntityCopyWith<$Res> {
  _$FactoryEntityCopyWithImpl(this._self, this._then);

  final FactoryEntity _self;
  final $Res Function(FactoryEntity) _then;

/// Create a copy of FactoryEntity
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


/// Adds pattern-matching-related methods to [FactoryEntity].
extension FactoryEntityPatterns on FactoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _FactoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FactoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactoryEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FactoryEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FactoryEntity() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _FactoryEntity extends FactoryEntity {
  const _FactoryEntity({required this.id, required this.ownerId, required this.name, required this.city, required final  List<String> specialties, required this.minQuantity, required this.leadTimeDays, this.rating = 0.0, this.reviewCount = 0, this.coverImageUrl, final  List<String> portfolioImages = const [], this.isFastResponder = false, required this.createdAt}): _specialties = specialties,_portfolioImages = portfolioImages,super._();
  

@override final  String id;
@override final  String ownerId;
@override final  String name;
@override final  String city;
 final  List<String> _specialties;
@override List<String> get specialties {
  if (_specialties is EqualUnmodifiableListView) return _specialties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialties);
}

@override final  int minQuantity;
@override final  int leadTimeDays;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int reviewCount;
@override final  String? coverImageUrl;
 final  List<String> _portfolioImages;
@override@JsonKey() List<String> get portfolioImages {
  if (_portfolioImages is EqualUnmodifiableListView) return _portfolioImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_portfolioImages);
}

@override@JsonKey() final  bool isFastResponder;
@override final  DateTime createdAt;

/// Create a copy of FactoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactoryEntityCopyWith<_FactoryEntity> get copyWith => __$FactoryEntityCopyWithImpl<_FactoryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._portfolioImages, _portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(_specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(_portfolioImages),isFastResponder,createdAt);

@override
String toString() {
  return 'FactoryEntity(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FactoryEntityCopyWith<$Res> implements $FactoryEntityCopyWith<$Res> {
  factory _$FactoryEntityCopyWith(_FactoryEntity value, $Res Function(_FactoryEntity) _then) = __$FactoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String city, List<String> specialties, int minQuantity, int leadTimeDays, double rating, int reviewCount, String? coverImageUrl, List<String> portfolioImages, bool isFastResponder, DateTime createdAt
});




}
/// @nodoc
class __$FactoryEntityCopyWithImpl<$Res>
    implements _$FactoryEntityCopyWith<$Res> {
  __$FactoryEntityCopyWithImpl(this._self, this._then);

  final _FactoryEntity _self;
  final $Res Function(_FactoryEntity) _then;

/// Create a copy of FactoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,Object? createdAt = null,}) {
  return _then(_FactoryEntity(
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
mixin _$RequestEntity {

 String get id; String get brandId; String get brandName; String? get brandAvatarInitial; String get productType; int get quantity; String get material; RequestQuality get quality; double? get targetPricePerPiece; String? get notes; String? get referenceImageUrl; RequestStatus get status; int get offerCount; DateTime get createdAt; String? get requestNumber;
/// Create a copy of RequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestEntityCopyWith<RequestEntity> get copyWith => _$RequestEntityCopyWithImpl<RequestEntity>(this as RequestEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandAvatarInitial, brandAvatarInitial) || other.brandAvatarInitial == brandAvatarInitial)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.material, material) || other.material == material)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.targetPricePerPiece, targetPricePerPiece) || other.targetPricePerPiece == targetPricePerPiece)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.referenceImageUrl, referenceImageUrl) || other.referenceImageUrl == referenceImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestNumber, requestNumber) || other.requestNumber == requestNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,brandId,brandName,brandAvatarInitial,productType,quantity,material,quality,targetPricePerPiece,notes,referenceImageUrl,status,offerCount,createdAt,requestNumber);

@override
String toString() {
  return 'RequestEntity(id: $id, brandId: $brandId, brandName: $brandName, brandAvatarInitial: $brandAvatarInitial, productType: $productType, quantity: $quantity, material: $material, quality: $quality, targetPricePerPiece: $targetPricePerPiece, notes: $notes, referenceImageUrl: $referenceImageUrl, status: $status, offerCount: $offerCount, createdAt: $createdAt, requestNumber: $requestNumber)';
}


}

/// @nodoc
abstract mixin class $RequestEntityCopyWith<$Res>  {
  factory $RequestEntityCopyWith(RequestEntity value, $Res Function(RequestEntity) _then) = _$RequestEntityCopyWithImpl;
@useResult
$Res call({
 String id, String brandId, String brandName, String? brandAvatarInitial, String productType, int quantity, String material, RequestQuality quality, double? targetPricePerPiece, String? notes, String? referenceImageUrl, RequestStatus status, int offerCount, DateTime createdAt, String? requestNumber
});




}
/// @nodoc
class _$RequestEntityCopyWithImpl<$Res>
    implements $RequestEntityCopyWith<$Res> {
  _$RequestEntityCopyWithImpl(this._self, this._then);

  final RequestEntity _self;
  final $Res Function(RequestEntity) _then;

/// Create a copy of RequestEntity
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
as RequestQuality,targetPricePerPiece: freezed == targetPricePerPiece ? _self.targetPricePerPiece : targetPricePerPiece // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,referenceImageUrl: freezed == referenceImageUrl ? _self.referenceImageUrl : referenceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requestNumber: freezed == requestNumber ? _self.requestNumber : requestNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestEntity].
extension RequestEntityPatterns on RequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _RequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String brandId,  String brandName,  String? brandAvatarInitial,  String productType,  int quantity,  String material,  RequestQuality quality,  double? targetPricePerPiece,  String? notes,  String? referenceImageUrl,  RequestStatus status,  int offerCount,  DateTime createdAt,  String? requestNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String brandId,  String brandName,  String? brandAvatarInitial,  String productType,  int quantity,  String material,  RequestQuality quality,  double? targetPricePerPiece,  String? notes,  String? referenceImageUrl,  RequestStatus status,  int offerCount,  DateTime createdAt,  String? requestNumber)  $default,) {final _that = this;
switch (_that) {
case _RequestEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String brandId,  String brandName,  String? brandAvatarInitial,  String productType,  int quantity,  String material,  RequestQuality quality,  double? targetPricePerPiece,  String? notes,  String? referenceImageUrl,  RequestStatus status,  int offerCount,  DateTime createdAt,  String? requestNumber)?  $default,) {final _that = this;
switch (_that) {
case _RequestEntity() when $default != null:
return $default(_that.id,_that.brandId,_that.brandName,_that.brandAvatarInitial,_that.productType,_that.quantity,_that.material,_that.quality,_that.targetPricePerPiece,_that.notes,_that.referenceImageUrl,_that.status,_that.offerCount,_that.createdAt,_that.requestNumber);case _:
  return null;

}
}

}

/// @nodoc


class _RequestEntity extends RequestEntity {
  const _RequestEntity({required this.id, required this.brandId, required this.brandName, this.brandAvatarInitial, required this.productType, required this.quantity, this.material = 'مش محدد', this.quality = RequestQuality.medium, this.targetPricePerPiece, this.notes, this.referenceImageUrl, this.status = RequestStatus.active, this.offerCount = 0, required this.createdAt, this.requestNumber}): super._();
  

@override final  String id;
@override final  String brandId;
@override final  String brandName;
@override final  String? brandAvatarInitial;
@override final  String productType;
@override final  int quantity;
@override@JsonKey() final  String material;
@override@JsonKey() final  RequestQuality quality;
@override final  double? targetPricePerPiece;
@override final  String? notes;
@override final  String? referenceImageUrl;
@override@JsonKey() final  RequestStatus status;
@override@JsonKey() final  int offerCount;
@override final  DateTime createdAt;
@override final  String? requestNumber;

/// Create a copy of RequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestEntityCopyWith<_RequestEntity> get copyWith => __$RequestEntityCopyWithImpl<_RequestEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.brandId, brandId) || other.brandId == brandId)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.brandAvatarInitial, brandAvatarInitial) || other.brandAvatarInitial == brandAvatarInitial)&&(identical(other.productType, productType) || other.productType == productType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.material, material) || other.material == material)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.targetPricePerPiece, targetPricePerPiece) || other.targetPricePerPiece == targetPricePerPiece)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.referenceImageUrl, referenceImageUrl) || other.referenceImageUrl == referenceImageUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.offerCount, offerCount) || other.offerCount == offerCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.requestNumber, requestNumber) || other.requestNumber == requestNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,brandId,brandName,brandAvatarInitial,productType,quantity,material,quality,targetPricePerPiece,notes,referenceImageUrl,status,offerCount,createdAt,requestNumber);

@override
String toString() {
  return 'RequestEntity(id: $id, brandId: $brandId, brandName: $brandName, brandAvatarInitial: $brandAvatarInitial, productType: $productType, quantity: $quantity, material: $material, quality: $quality, targetPricePerPiece: $targetPricePerPiece, notes: $notes, referenceImageUrl: $referenceImageUrl, status: $status, offerCount: $offerCount, createdAt: $createdAt, requestNumber: $requestNumber)';
}


}

/// @nodoc
abstract mixin class _$RequestEntityCopyWith<$Res> implements $RequestEntityCopyWith<$Res> {
  factory _$RequestEntityCopyWith(_RequestEntity value, $Res Function(_RequestEntity) _then) = __$RequestEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String brandId, String brandName, String? brandAvatarInitial, String productType, int quantity, String material, RequestQuality quality, double? targetPricePerPiece, String? notes, String? referenceImageUrl, RequestStatus status, int offerCount, DateTime createdAt, String? requestNumber
});




}
/// @nodoc
class __$RequestEntityCopyWithImpl<$Res>
    implements _$RequestEntityCopyWith<$Res> {
  __$RequestEntityCopyWithImpl(this._self, this._then);

  final _RequestEntity _self;
  final $Res Function(_RequestEntity) _then;

/// Create a copy of RequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? brandId = null,Object? brandName = null,Object? brandAvatarInitial = freezed,Object? productType = null,Object? quantity = null,Object? material = null,Object? quality = null,Object? targetPricePerPiece = freezed,Object? notes = freezed,Object? referenceImageUrl = freezed,Object? status = null,Object? offerCount = null,Object? createdAt = null,Object? requestNumber = freezed,}) {
  return _then(_RequestEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,brandId: null == brandId ? _self.brandId : brandId // ignore: cast_nullable_to_non_nullable
as String,brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,brandAvatarInitial: freezed == brandAvatarInitial ? _self.brandAvatarInitial : brandAvatarInitial // ignore: cast_nullable_to_non_nullable
as String?,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,material: null == material ? _self.material : material // ignore: cast_nullable_to_non_nullable
as String,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as RequestQuality,targetPricePerPiece: freezed == targetPricePerPiece ? _self.targetPricePerPiece : targetPricePerPiece // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,referenceImageUrl: freezed == referenceImageUrl ? _self.referenceImageUrl : referenceImageUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,offerCount: null == offerCount ? _self.offerCount : offerCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,requestNumber: freezed == requestNumber ? _self.requestNumber : requestNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
