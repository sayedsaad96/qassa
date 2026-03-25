// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factory_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FactoryProfileModel {

 String get id;@JsonKey(name: 'owner_id') String get ownerId; String get name; String get city; List<String> get specialties;@JsonKey(name: 'min_quantity') int get minQuantity;@JsonKey(name: 'lead_time_days') int get leadTimeDays; double get rating;@JsonKey(name: 'review_count') int get reviewCount;@JsonKey(name: 'cover_image_url') String? get coverImageUrl;@JsonKey(name: 'portfolio_images') List<String> get portfolioImages;@JsonKey(name: 'is_fast_responder') bool get isFastResponder;
/// Create a copy of FactoryProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactoryProfileModelCopyWith<FactoryProfileModel> get copyWith => _$FactoryProfileModelCopyWithImpl<FactoryProfileModel>(this as FactoryProfileModel, _$identity);

  /// Serializes this FactoryProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactoryProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.portfolioImages, portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(portfolioImages),isFastResponder);

@override
String toString() {
  return 'FactoryProfileModel(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder)';
}


}

/// @nodoc
abstract mixin class $FactoryProfileModelCopyWith<$Res>  {
  factory $FactoryProfileModelCopyWith(FactoryProfileModel value, $Res Function(FactoryProfileModel) _then) = _$FactoryProfileModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String city, List<String> specialties,@JsonKey(name: 'min_quantity') int minQuantity,@JsonKey(name: 'lead_time_days') int leadTimeDays, double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'portfolio_images') List<String> portfolioImages,@JsonKey(name: 'is_fast_responder') bool isFastResponder
});




}
/// @nodoc
class _$FactoryProfileModelCopyWithImpl<$Res>
    implements $FactoryProfileModelCopyWith<$Res> {
  _$FactoryProfileModelCopyWithImpl(this._self, this._then);

  final FactoryProfileModel _self;
  final $Res Function(FactoryProfileModel) _then;

/// Create a copy of FactoryProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,}) {
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
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FactoryProfileModel].
extension FactoryProfileModelPatterns on FactoryProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactoryProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactoryProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactoryProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _FactoryProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactoryProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _FactoryProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactoryProfileModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder)  $default,) {final _that = this;
switch (_that) {
case _FactoryProfileModel():
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'owner_id')  String ownerId,  String name,  String city,  List<String> specialties, @JsonKey(name: 'min_quantity')  int minQuantity, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  double rating, @JsonKey(name: 'review_count')  int reviewCount, @JsonKey(name: 'cover_image_url')  String? coverImageUrl, @JsonKey(name: 'portfolio_images')  List<String> portfolioImages, @JsonKey(name: 'is_fast_responder')  bool isFastResponder)?  $default,) {final _that = this;
switch (_that) {
case _FactoryProfileModel() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FactoryProfileModel extends FactoryProfileModel {
  const _FactoryProfileModel({required this.id, @JsonKey(name: 'owner_id') required this.ownerId, required this.name, required this.city, final  List<String> specialties = const [], @JsonKey(name: 'min_quantity') this.minQuantity = 100, @JsonKey(name: 'lead_time_days') this.leadTimeDays = 21, this.rating = 0.0, @JsonKey(name: 'review_count') this.reviewCount = 0, @JsonKey(name: 'cover_image_url') this.coverImageUrl, @JsonKey(name: 'portfolio_images') final  List<String> portfolioImages = const [], @JsonKey(name: 'is_fast_responder') this.isFastResponder = false}): _specialties = specialties,_portfolioImages = portfolioImages,super._();
  factory _FactoryProfileModel.fromJson(Map<String, dynamic> json) => _$FactoryProfileModelFromJson(json);

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

/// Create a copy of FactoryProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactoryProfileModelCopyWith<_FactoryProfileModel> get copyWith => __$FactoryProfileModelCopyWithImpl<_FactoryProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FactoryProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactoryProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._portfolioImages, _portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(_specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(_portfolioImages),isFastResponder);

@override
String toString() {
  return 'FactoryProfileModel(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder)';
}


}

/// @nodoc
abstract mixin class _$FactoryProfileModelCopyWith<$Res> implements $FactoryProfileModelCopyWith<$Res> {
  factory _$FactoryProfileModelCopyWith(_FactoryProfileModel value, $Res Function(_FactoryProfileModel) _then) = __$FactoryProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'owner_id') String ownerId, String name, String city, List<String> specialties,@JsonKey(name: 'min_quantity') int minQuantity,@JsonKey(name: 'lead_time_days') int leadTimeDays, double rating,@JsonKey(name: 'review_count') int reviewCount,@JsonKey(name: 'cover_image_url') String? coverImageUrl,@JsonKey(name: 'portfolio_images') List<String> portfolioImages,@JsonKey(name: 'is_fast_responder') bool isFastResponder
});




}
/// @nodoc
class __$FactoryProfileModelCopyWithImpl<$Res>
    implements _$FactoryProfileModelCopyWith<$Res> {
  __$FactoryProfileModelCopyWithImpl(this._self, this._then);

  final _FactoryProfileModel _self;
  final $Res Function(_FactoryProfileModel) _then;

/// Create a copy of FactoryProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,}) {
  return _then(_FactoryProfileModel(
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
as bool,
  ));
}


}

// dart format on
