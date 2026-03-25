// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfferEntity {

 String get id; String get requestId; String get factoryId; String get factoryName; double get factoryRating; double get pricePerPiece; int get leadTimeDays; String? get notes; OfferStatus get status; DateTime get createdAt; int get quantity; String get productType;
/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferEntityCopyWith<OfferEntity> get copyWith => _$OfferEntityCopyWithImpl<OfferEntity>(this as OfferEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.factoryId, factoryId) || other.factoryId == factoryId)&&(identical(other.factoryName, factoryName) || other.factoryName == factoryName)&&(identical(other.factoryRating, factoryRating) || other.factoryRating == factoryRating)&&(identical(other.pricePerPiece, pricePerPiece) || other.pricePerPiece == pricePerPiece)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productType, productType) || other.productType == productType));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestId,factoryId,factoryName,factoryRating,pricePerPiece,leadTimeDays,notes,status,createdAt,quantity,productType);

@override
String toString() {
  return 'OfferEntity(id: $id, requestId: $requestId, factoryId: $factoryId, factoryName: $factoryName, factoryRating: $factoryRating, pricePerPiece: $pricePerPiece, leadTimeDays: $leadTimeDays, notes: $notes, status: $status, createdAt: $createdAt, quantity: $quantity, productType: $productType)';
}


}

/// @nodoc
abstract mixin class $OfferEntityCopyWith<$Res>  {
  factory $OfferEntityCopyWith(OfferEntity value, $Res Function(OfferEntity) _then) = _$OfferEntityCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, String factoryId, String factoryName, double factoryRating, double pricePerPiece, int leadTimeDays, String? notes, OfferStatus status, DateTime createdAt, int quantity, String productType
});




}
/// @nodoc
class _$OfferEntityCopyWithImpl<$Res>
    implements $OfferEntityCopyWith<$Res> {
  _$OfferEntityCopyWithImpl(this._self, this._then);

  final OfferEntity _self;
  final $Res Function(OfferEntity) _then;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? factoryId = null,Object? factoryName = null,Object? factoryRating = null,Object? pricePerPiece = null,Object? leadTimeDays = null,Object? notes = freezed,Object? status = null,Object? createdAt = null,Object? quantity = null,Object? productType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,factoryId: null == factoryId ? _self.factoryId : factoryId // ignore: cast_nullable_to_non_nullable
as String,factoryName: null == factoryName ? _self.factoryName : factoryName // ignore: cast_nullable_to_non_nullable
as String,factoryRating: null == factoryRating ? _self.factoryRating : factoryRating // ignore: cast_nullable_to_non_nullable
as double,pricePerPiece: null == pricePerPiece ? _self.pricePerPiece : pricePerPiece // ignore: cast_nullable_to_non_nullable
as double,leadTimeDays: null == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferEntity].
extension OfferEntityPatterns on OfferEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferEntity value)  $default,){
final _that = this;
switch (_that) {
case _OfferEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  String factoryId,  String factoryName,  double factoryRating,  double pricePerPiece,  int leadTimeDays,  String? notes,  OfferStatus status,  DateTime createdAt,  int quantity,  String productType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
return $default(_that.id,_that.requestId,_that.factoryId,_that.factoryName,_that.factoryRating,_that.pricePerPiece,_that.leadTimeDays,_that.notes,_that.status,_that.createdAt,_that.quantity,_that.productType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  String factoryId,  String factoryName,  double factoryRating,  double pricePerPiece,  int leadTimeDays,  String? notes,  OfferStatus status,  DateTime createdAt,  int quantity,  String productType)  $default,) {final _that = this;
switch (_that) {
case _OfferEntity():
return $default(_that.id,_that.requestId,_that.factoryId,_that.factoryName,_that.factoryRating,_that.pricePerPiece,_that.leadTimeDays,_that.notes,_that.status,_that.createdAt,_that.quantity,_that.productType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  String factoryId,  String factoryName,  double factoryRating,  double pricePerPiece,  int leadTimeDays,  String? notes,  OfferStatus status,  DateTime createdAt,  int quantity,  String productType)?  $default,) {final _that = this;
switch (_that) {
case _OfferEntity() when $default != null:
return $default(_that.id,_that.requestId,_that.factoryId,_that.factoryName,_that.factoryRating,_that.pricePerPiece,_that.leadTimeDays,_that.notes,_that.status,_that.createdAt,_that.quantity,_that.productType);case _:
  return null;

}
}

}

/// @nodoc


class _OfferEntity extends OfferEntity {
  const _OfferEntity({required this.id, required this.requestId, required this.factoryId, required this.factoryName, this.factoryRating = 0.0, required this.pricePerPiece, required this.leadTimeDays, this.notes, this.status = OfferStatus.pending, required this.createdAt, this.quantity = 0, this.productType = ''}): super._();
  

@override final  String id;
@override final  String requestId;
@override final  String factoryId;
@override final  String factoryName;
@override@JsonKey() final  double factoryRating;
@override final  double pricePerPiece;
@override final  int leadTimeDays;
@override final  String? notes;
@override@JsonKey() final  OfferStatus status;
@override final  DateTime createdAt;
@override@JsonKey() final  int quantity;
@override@JsonKey() final  String productType;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferEntityCopyWith<_OfferEntity> get copyWith => __$OfferEntityCopyWithImpl<_OfferEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.factoryId, factoryId) || other.factoryId == factoryId)&&(identical(other.factoryName, factoryName) || other.factoryName == factoryName)&&(identical(other.factoryRating, factoryRating) || other.factoryRating == factoryRating)&&(identical(other.pricePerPiece, pricePerPiece) || other.pricePerPiece == pricePerPiece)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productType, productType) || other.productType == productType));
}


@override
int get hashCode => Object.hash(runtimeType,id,requestId,factoryId,factoryName,factoryRating,pricePerPiece,leadTimeDays,notes,status,createdAt,quantity,productType);

@override
String toString() {
  return 'OfferEntity(id: $id, requestId: $requestId, factoryId: $factoryId, factoryName: $factoryName, factoryRating: $factoryRating, pricePerPiece: $pricePerPiece, leadTimeDays: $leadTimeDays, notes: $notes, status: $status, createdAt: $createdAt, quantity: $quantity, productType: $productType)';
}


}

/// @nodoc
abstract mixin class _$OfferEntityCopyWith<$Res> implements $OfferEntityCopyWith<$Res> {
  factory _$OfferEntityCopyWith(_OfferEntity value, $Res Function(_OfferEntity) _then) = __$OfferEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, String factoryId, String factoryName, double factoryRating, double pricePerPiece, int leadTimeDays, String? notes, OfferStatus status, DateTime createdAt, int quantity, String productType
});




}
/// @nodoc
class __$OfferEntityCopyWithImpl<$Res>
    implements _$OfferEntityCopyWith<$Res> {
  __$OfferEntityCopyWithImpl(this._self, this._then);

  final _OfferEntity _self;
  final $Res Function(_OfferEntity) _then;

/// Create a copy of OfferEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? factoryId = null,Object? factoryName = null,Object? factoryRating = null,Object? pricePerPiece = null,Object? leadTimeDays = null,Object? notes = freezed,Object? status = null,Object? createdAt = null,Object? quantity = null,Object? productType = null,}) {
  return _then(_OfferEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,factoryId: null == factoryId ? _self.factoryId : factoryId // ignore: cast_nullable_to_non_nullable
as String,factoryName: null == factoryName ? _self.factoryName : factoryName // ignore: cast_nullable_to_non_nullable
as String,factoryRating: null == factoryRating ? _self.factoryRating : factoryRating // ignore: cast_nullable_to_non_nullable
as double,pricePerPiece: null == pricePerPiece ? _self.pricePerPiece : pricePerPiece // ignore: cast_nullable_to_non_nullable
as double,leadTimeDays: null == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
