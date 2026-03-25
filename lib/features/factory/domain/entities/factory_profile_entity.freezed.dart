// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'factory_profile_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FactoryProfileEntity {

 String get id; String get ownerId; String get name; String get city; List<String> get specialties; int get minQuantity; int get leadTimeDays; double get rating; int get reviewCount; String? get coverImageUrl; List<String> get portfolioImages; bool get isFastResponder;
/// Create a copy of FactoryProfileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FactoryProfileEntityCopyWith<FactoryProfileEntity> get copyWith => _$FactoryProfileEntityCopyWithImpl<FactoryProfileEntity>(this as FactoryProfileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FactoryProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other.specialties, specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other.portfolioImages, portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(portfolioImages),isFastResponder);

@override
String toString() {
  return 'FactoryProfileEntity(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder)';
}


}

/// @nodoc
abstract mixin class $FactoryProfileEntityCopyWith<$Res>  {
  factory $FactoryProfileEntityCopyWith(FactoryProfileEntity value, $Res Function(FactoryProfileEntity) _then) = _$FactoryProfileEntityCopyWithImpl;
@useResult
$Res call({
 String id, String ownerId, String name, String city, List<String> specialties, int minQuantity, int leadTimeDays, double rating, int reviewCount, String? coverImageUrl, List<String> portfolioImages, bool isFastResponder
});




}
/// @nodoc
class _$FactoryProfileEntityCopyWithImpl<$Res>
    implements $FactoryProfileEntityCopyWith<$Res> {
  _$FactoryProfileEntityCopyWithImpl(this._self, this._then);

  final FactoryProfileEntity _self;
  final $Res Function(FactoryProfileEntity) _then;

/// Create a copy of FactoryProfileEntity
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


/// Adds pattern-matching-related methods to [FactoryProfileEntity].
extension FactoryProfileEntityPatterns on FactoryProfileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FactoryProfileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FactoryProfileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FactoryProfileEntity value)  $default,){
final _that = this;
switch (_that) {
case _FactoryProfileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FactoryProfileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FactoryProfileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FactoryProfileEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder)  $default,) {final _that = this;
switch (_that) {
case _FactoryProfileEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String ownerId,  String name,  String city,  List<String> specialties,  int minQuantity,  int leadTimeDays,  double rating,  int reviewCount,  String? coverImageUrl,  List<String> portfolioImages,  bool isFastResponder)?  $default,) {final _that = this;
switch (_that) {
case _FactoryProfileEntity() when $default != null:
return $default(_that.id,_that.ownerId,_that.name,_that.city,_that.specialties,_that.minQuantity,_that.leadTimeDays,_that.rating,_that.reviewCount,_that.coverImageUrl,_that.portfolioImages,_that.isFastResponder);case _:
  return null;

}
}

}

/// @nodoc


class _FactoryProfileEntity implements FactoryProfileEntity {
  const _FactoryProfileEntity({required this.id, required this.ownerId, required this.name, required this.city, required final  List<String> specialties, required this.minQuantity, required this.leadTimeDays, this.rating = 0.0, this.reviewCount = 0, this.coverImageUrl, final  List<String> portfolioImages = const [], this.isFastResponder = false}): _specialties = specialties,_portfolioImages = portfolioImages;
  

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

/// Create a copy of FactoryProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FactoryProfileEntityCopyWith<_FactoryProfileEntity> get copyWith => __$FactoryProfileEntityCopyWithImpl<_FactoryProfileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FactoryProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&const DeepCollectionEquality().equals(other._specialties, _specialties)&&(identical(other.minQuantity, minQuantity) || other.minQuantity == minQuantity)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&const DeepCollectionEquality().equals(other._portfolioImages, _portfolioImages)&&(identical(other.isFastResponder, isFastResponder) || other.isFastResponder == isFastResponder));
}


@override
int get hashCode => Object.hash(runtimeType,id,ownerId,name,city,const DeepCollectionEquality().hash(_specialties),minQuantity,leadTimeDays,rating,reviewCount,coverImageUrl,const DeepCollectionEquality().hash(_portfolioImages),isFastResponder);

@override
String toString() {
  return 'FactoryProfileEntity(id: $id, ownerId: $ownerId, name: $name, city: $city, specialties: $specialties, minQuantity: $minQuantity, leadTimeDays: $leadTimeDays, rating: $rating, reviewCount: $reviewCount, coverImageUrl: $coverImageUrl, portfolioImages: $portfolioImages, isFastResponder: $isFastResponder)';
}


}

/// @nodoc
abstract mixin class _$FactoryProfileEntityCopyWith<$Res> implements $FactoryProfileEntityCopyWith<$Res> {
  factory _$FactoryProfileEntityCopyWith(_FactoryProfileEntity value, $Res Function(_FactoryProfileEntity) _then) = __$FactoryProfileEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String ownerId, String name, String city, List<String> specialties, int minQuantity, int leadTimeDays, double rating, int reviewCount, String? coverImageUrl, List<String> portfolioImages, bool isFastResponder
});




}
/// @nodoc
class __$FactoryProfileEntityCopyWithImpl<$Res>
    implements _$FactoryProfileEntityCopyWith<$Res> {
  __$FactoryProfileEntityCopyWithImpl(this._self, this._then);

  final _FactoryProfileEntity _self;
  final $Res Function(_FactoryProfileEntity) _then;

/// Create a copy of FactoryProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = null,Object? name = null,Object? city = null,Object? specialties = null,Object? minQuantity = null,Object? leadTimeDays = null,Object? rating = null,Object? reviewCount = null,Object? coverImageUrl = freezed,Object? portfolioImages = null,Object? isFastResponder = null,}) {
  return _then(_FactoryProfileEntity(
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
