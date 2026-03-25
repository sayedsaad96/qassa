// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_remote_datasource.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferModel {

 String get id;@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'factory_id') String get factoryId;@JsonKey(name: 'factory_name') String get factoryName;@JsonKey(name: 'factory_rating') double get factoryRating;@JsonKey(name: 'price_per_piece') double get pricePerPiece;@JsonKey(name: 'lead_time_days') int get leadTimeDays; String? get notes; String get status;@JsonKey(name: 'created_at') DateTime get createdAt; int get quantity;@JsonKey(name: 'product_type') String get productType;
/// Create a copy of OfferModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferModelCopyWith<OfferModel> get copyWith => _$OfferModelCopyWithImpl<OfferModel>(this as OfferModel, _$identity);

  /// Serializes this OfferModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.factoryId, factoryId) || other.factoryId == factoryId)&&(identical(other.factoryName, factoryName) || other.factoryName == factoryName)&&(identical(other.factoryRating, factoryRating) || other.factoryRating == factoryRating)&&(identical(other.pricePerPiece, pricePerPiece) || other.pricePerPiece == pricePerPiece)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productType, productType) || other.productType == productType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,factoryId,factoryName,factoryRating,pricePerPiece,leadTimeDays,notes,status,createdAt,quantity,productType);

@override
String toString() {
  return 'OfferModel(id: $id, requestId: $requestId, factoryId: $factoryId, factoryName: $factoryName, factoryRating: $factoryRating, pricePerPiece: $pricePerPiece, leadTimeDays: $leadTimeDays, notes: $notes, status: $status, createdAt: $createdAt, quantity: $quantity, productType: $productType)';
}


}

/// @nodoc
abstract mixin class $OfferModelCopyWith<$Res>  {
  factory $OfferModelCopyWith(OfferModel value, $Res Function(OfferModel) _then) = _$OfferModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'factory_id') String factoryId,@JsonKey(name: 'factory_name') String factoryName,@JsonKey(name: 'factory_rating') double factoryRating,@JsonKey(name: 'price_per_piece') double pricePerPiece,@JsonKey(name: 'lead_time_days') int leadTimeDays, String? notes, String status,@JsonKey(name: 'created_at') DateTime createdAt, int quantity,@JsonKey(name: 'product_type') String productType
});




}
/// @nodoc
class _$OfferModelCopyWithImpl<$Res>
    implements $OfferModelCopyWith<$Res> {
  _$OfferModelCopyWithImpl(this._self, this._then);

  final OfferModel _self;
  final $Res Function(OfferModel) _then;

/// Create a copy of OfferModel
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
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferModel].
extension OfferModelPatterns on OfferModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferModel value)  $default,){
final _that = this;
switch (_that) {
case _OfferModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferModel value)?  $default,){
final _that = this;
switch (_that) {
case _OfferModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'factory_id')  String factoryId, @JsonKey(name: 'factory_name')  String factoryName, @JsonKey(name: 'factory_rating')  double factoryRating, @JsonKey(name: 'price_per_piece')  double pricePerPiece, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  String? notes,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  int quantity, @JsonKey(name: 'product_type')  String productType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'factory_id')  String factoryId, @JsonKey(name: 'factory_name')  String factoryName, @JsonKey(name: 'factory_rating')  double factoryRating, @JsonKey(name: 'price_per_piece')  double pricePerPiece, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  String? notes,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  int quantity, @JsonKey(name: 'product_type')  String productType)  $default,) {final _that = this;
switch (_that) {
case _OfferModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'factory_id')  String factoryId, @JsonKey(name: 'factory_name')  String factoryName, @JsonKey(name: 'factory_rating')  double factoryRating, @JsonKey(name: 'price_per_piece')  double pricePerPiece, @JsonKey(name: 'lead_time_days')  int leadTimeDays,  String? notes,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  int quantity, @JsonKey(name: 'product_type')  String productType)?  $default,) {final _that = this;
switch (_that) {
case _OfferModel() when $default != null:
return $default(_that.id,_that.requestId,_that.factoryId,_that.factoryName,_that.factoryRating,_that.pricePerPiece,_that.leadTimeDays,_that.notes,_that.status,_that.createdAt,_that.quantity,_that.productType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferModel extends OfferModel {
  const _OfferModel({required this.id, @JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'factory_id') required this.factoryId, @JsonKey(name: 'factory_name') this.factoryName = 'مصنع', @JsonKey(name: 'factory_rating') this.factoryRating = 0.0, @JsonKey(name: 'price_per_piece') required this.pricePerPiece, @JsonKey(name: 'lead_time_days') required this.leadTimeDays, this.notes, this.status = 'pending', @JsonKey(name: 'created_at') required this.createdAt, this.quantity = 0, @JsonKey(name: 'product_type') this.productType = ''}): super._();
  factory _OfferModel.fromJson(Map<String, dynamic> json) => _$OfferModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'factory_id') final  String factoryId;
@override@JsonKey(name: 'factory_name') final  String factoryName;
@override@JsonKey(name: 'factory_rating') final  double factoryRating;
@override@JsonKey(name: 'price_per_piece') final  double pricePerPiece;
@override@JsonKey(name: 'lead_time_days') final  int leadTimeDays;
@override final  String? notes;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey() final  int quantity;
@override@JsonKey(name: 'product_type') final  String productType;

/// Create a copy of OfferModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferModelCopyWith<_OfferModel> get copyWith => __$OfferModelCopyWithImpl<_OfferModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferModel&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.factoryId, factoryId) || other.factoryId == factoryId)&&(identical(other.factoryName, factoryName) || other.factoryName == factoryName)&&(identical(other.factoryRating, factoryRating) || other.factoryRating == factoryRating)&&(identical(other.pricePerPiece, pricePerPiece) || other.pricePerPiece == pricePerPiece)&&(identical(other.leadTimeDays, leadTimeDays) || other.leadTimeDays == leadTimeDays)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productType, productType) || other.productType == productType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,factoryId,factoryName,factoryRating,pricePerPiece,leadTimeDays,notes,status,createdAt,quantity,productType);

@override
String toString() {
  return 'OfferModel(id: $id, requestId: $requestId, factoryId: $factoryId, factoryName: $factoryName, factoryRating: $factoryRating, pricePerPiece: $pricePerPiece, leadTimeDays: $leadTimeDays, notes: $notes, status: $status, createdAt: $createdAt, quantity: $quantity, productType: $productType)';
}


}

/// @nodoc
abstract mixin class _$OfferModelCopyWith<$Res> implements $OfferModelCopyWith<$Res> {
  factory _$OfferModelCopyWith(_OfferModel value, $Res Function(_OfferModel) _then) = __$OfferModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'factory_id') String factoryId,@JsonKey(name: 'factory_name') String factoryName,@JsonKey(name: 'factory_rating') double factoryRating,@JsonKey(name: 'price_per_piece') double pricePerPiece,@JsonKey(name: 'lead_time_days') int leadTimeDays, String? notes, String status,@JsonKey(name: 'created_at') DateTime createdAt, int quantity,@JsonKey(name: 'product_type') String productType
});




}
/// @nodoc
class __$OfferModelCopyWithImpl<$Res>
    implements _$OfferModelCopyWith<$Res> {
  __$OfferModelCopyWithImpl(this._self, this._then);

  final _OfferModel _self;
  final $Res Function(_OfferModel) _then;

/// Create a copy of OfferModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? factoryId = null,Object? factoryName = null,Object? factoryRating = null,Object? pricePerPiece = null,Object? leadTimeDays = null,Object? notes = freezed,Object? status = null,Object? createdAt = null,Object? quantity = null,Object? productType = null,}) {
  return _then(_OfferModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,factoryId: null == factoryId ? _self.factoryId : factoryId // ignore: cast_nullable_to_non_nullable
as String,factoryName: null == factoryName ? _self.factoryName : factoryName // ignore: cast_nullable_to_non_nullable
as String,factoryRating: null == factoryRating ? _self.factoryRating : factoryRating // ignore: cast_nullable_to_non_nullable
as double,pricePerPiece: null == pricePerPiece ? _self.pricePerPiece : pricePerPiece // ignore: cast_nullable_to_non_nullable
as double,leadTimeDays: null == leadTimeDays ? _self.leadTimeDays : leadTimeDays // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productType: null == productType ? _self.productType : productType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
