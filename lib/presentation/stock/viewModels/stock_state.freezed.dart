// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockState {

 List<Stock> get stocks; List<Stock> get filteredStocks; User? get currentUser; StockStateStatus get status; Set<String> get selectedStockIds; String get searchQuery; StockStatus? get filterStatus; SortBy get sortBy; SortOrder get sortOrder; bool get isBulkSelectionMode; String? get errorMessage;
/// Create a copy of StockState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockStateCopyWith<StockState> get copyWith => _$StockStateCopyWithImpl<StockState>(this as StockState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockState&&const DeepCollectionEquality().equals(other.stocks, stocks)&&const DeepCollectionEquality().equals(other.filteredStocks, filteredStocks)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&const DeepCollectionEquality().equals(other.status, status)&&const DeepCollectionEquality().equals(other.selectedStockIds, selectedStockIds)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filterStatus, filterStatus) || other.filterStatus == filterStatus)&&const DeepCollectionEquality().equals(other.sortBy, sortBy)&&const DeepCollectionEquality().equals(other.sortOrder, sortOrder)&&(identical(other.isBulkSelectionMode, isBulkSelectionMode) || other.isBulkSelectionMode == isBulkSelectionMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(stocks),const DeepCollectionEquality().hash(filteredStocks),currentUser,const DeepCollectionEquality().hash(status),const DeepCollectionEquality().hash(selectedStockIds),searchQuery,filterStatus,const DeepCollectionEquality().hash(sortBy),const DeepCollectionEquality().hash(sortOrder),isBulkSelectionMode,errorMessage);

@override
String toString() {
  return 'StockState(stocks: $stocks, filteredStocks: $filteredStocks, currentUser: $currentUser, status: $status, selectedStockIds: $selectedStockIds, searchQuery: $searchQuery, filterStatus: $filterStatus, sortBy: $sortBy, sortOrder: $sortOrder, isBulkSelectionMode: $isBulkSelectionMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StockStateCopyWith<$Res>  {
  factory $StockStateCopyWith(StockState value, $Res Function(StockState) _then) = _$StockStateCopyWithImpl;
@useResult
$Res call({
 List<Stock> stocks, List<Stock> filteredStocks, User? currentUser, StockStateStatus status, Set<String> selectedStockIds, String searchQuery, StockStatus? filterStatus, SortBy sortBy, SortOrder sortOrder, bool isBulkSelectionMode, String? errorMessage
});




}
/// @nodoc
class _$StockStateCopyWithImpl<$Res>
    implements $StockStateCopyWith<$Res> {
  _$StockStateCopyWithImpl(this._self, this._then);

  final StockState _self;
  final $Res Function(StockState) _then;

/// Create a copy of StockState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stocks = null,Object? filteredStocks = null,Object? currentUser = freezed,Object? status = freezed,Object? selectedStockIds = null,Object? searchQuery = null,Object? filterStatus = freezed,Object? sortBy = freezed,Object? sortOrder = freezed,Object? isBulkSelectionMode = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
stocks: null == stocks ? _self.stocks : stocks // ignore: cast_nullable_to_non_nullable
as List<Stock>,filteredStocks: null == filteredStocks ? _self.filteredStocks : filteredStocks // ignore: cast_nullable_to_non_nullable
as List<Stock>,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as User?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockStateStatus,selectedStockIds: null == selectedStockIds ? _self.selectedStockIds : selectedStockIds // ignore: cast_nullable_to_non_nullable
as Set<String>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filterStatus: freezed == filterStatus ? _self.filterStatus : filterStatus // ignore: cast_nullable_to_non_nullable
as StockStatus?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortBy,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as SortOrder,isBulkSelectionMode: null == isBulkSelectionMode ? _self.isBulkSelectionMode : isBulkSelectionMode // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockState].
extension StockStatePatterns on StockState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockState value)  $default,){
final _that = this;
switch (_that) {
case _StockState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockState value)?  $default,){
final _that = this;
switch (_that) {
case _StockState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Stock> stocks,  List<Stock> filteredStocks,  User? currentUser,  StockStateStatus status,  Set<String> selectedStockIds,  String searchQuery,  StockStatus? filterStatus,  SortBy sortBy,  SortOrder sortOrder,  bool isBulkSelectionMode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockState() when $default != null:
return $default(_that.stocks,_that.filteredStocks,_that.currentUser,_that.status,_that.selectedStockIds,_that.searchQuery,_that.filterStatus,_that.sortBy,_that.sortOrder,_that.isBulkSelectionMode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Stock> stocks,  List<Stock> filteredStocks,  User? currentUser,  StockStateStatus status,  Set<String> selectedStockIds,  String searchQuery,  StockStatus? filterStatus,  SortBy sortBy,  SortOrder sortOrder,  bool isBulkSelectionMode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StockState():
return $default(_that.stocks,_that.filteredStocks,_that.currentUser,_that.status,_that.selectedStockIds,_that.searchQuery,_that.filterStatus,_that.sortBy,_that.sortOrder,_that.isBulkSelectionMode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Stock> stocks,  List<Stock> filteredStocks,  User? currentUser,  StockStateStatus status,  Set<String> selectedStockIds,  String searchQuery,  StockStatus? filterStatus,  SortBy sortBy,  SortOrder sortOrder,  bool isBulkSelectionMode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StockState() when $default != null:
return $default(_that.stocks,_that.filteredStocks,_that.currentUser,_that.status,_that.selectedStockIds,_that.searchQuery,_that.filterStatus,_that.sortBy,_that.sortOrder,_that.isBulkSelectionMode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _StockState extends StockState {
  const _StockState({final  List<Stock> stocks = const [], final  List<Stock> filteredStocks = const [], this.currentUser, this.status = StockStateStatus.initial, final  Set<String> selectedStockIds = const {}, this.searchQuery = '', this.filterStatus, this.sortBy = SortBy.name, this.sortOrder = SortOrder.ascending, this.isBulkSelectionMode = false, this.errorMessage}): _stocks = stocks,_filteredStocks = filteredStocks,_selectedStockIds = selectedStockIds,super._();
  

 final  List<Stock> _stocks;
@override@JsonKey() List<Stock> get stocks {
  if (_stocks is EqualUnmodifiableListView) return _stocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stocks);
}

 final  List<Stock> _filteredStocks;
@override@JsonKey() List<Stock> get filteredStocks {
  if (_filteredStocks is EqualUnmodifiableListView) return _filteredStocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredStocks);
}

@override final  User? currentUser;
@override@JsonKey() final  StockStateStatus status;
 final  Set<String> _selectedStockIds;
@override@JsonKey() Set<String> get selectedStockIds {
  if (_selectedStockIds is EqualUnmodifiableSetView) return _selectedStockIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedStockIds);
}

@override@JsonKey() final  String searchQuery;
@override final  StockStatus? filterStatus;
@override@JsonKey() final  SortBy sortBy;
@override@JsonKey() final  SortOrder sortOrder;
@override@JsonKey() final  bool isBulkSelectionMode;
@override final  String? errorMessage;

/// Create a copy of StockState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockStateCopyWith<_StockState> get copyWith => __$StockStateCopyWithImpl<_StockState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockState&&const DeepCollectionEquality().equals(other._stocks, _stocks)&&const DeepCollectionEquality().equals(other._filteredStocks, _filteredStocks)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&const DeepCollectionEquality().equals(other.status, status)&&const DeepCollectionEquality().equals(other._selectedStockIds, _selectedStockIds)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.filterStatus, filterStatus) || other.filterStatus == filterStatus)&&const DeepCollectionEquality().equals(other.sortBy, sortBy)&&const DeepCollectionEquality().equals(other.sortOrder, sortOrder)&&(identical(other.isBulkSelectionMode, isBulkSelectionMode) || other.isBulkSelectionMode == isBulkSelectionMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stocks),const DeepCollectionEquality().hash(_filteredStocks),currentUser,const DeepCollectionEquality().hash(status),const DeepCollectionEquality().hash(_selectedStockIds),searchQuery,filterStatus,const DeepCollectionEquality().hash(sortBy),const DeepCollectionEquality().hash(sortOrder),isBulkSelectionMode,errorMessage);

@override
String toString() {
  return 'StockState(stocks: $stocks, filteredStocks: $filteredStocks, currentUser: $currentUser, status: $status, selectedStockIds: $selectedStockIds, searchQuery: $searchQuery, filterStatus: $filterStatus, sortBy: $sortBy, sortOrder: $sortOrder, isBulkSelectionMode: $isBulkSelectionMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StockStateCopyWith<$Res> implements $StockStateCopyWith<$Res> {
  factory _$StockStateCopyWith(_StockState value, $Res Function(_StockState) _then) = __$StockStateCopyWithImpl;
@override @useResult
$Res call({
 List<Stock> stocks, List<Stock> filteredStocks, User? currentUser, StockStateStatus status, Set<String> selectedStockIds, String searchQuery, StockStatus? filterStatus, SortBy sortBy, SortOrder sortOrder, bool isBulkSelectionMode, String? errorMessage
});




}
/// @nodoc
class __$StockStateCopyWithImpl<$Res>
    implements _$StockStateCopyWith<$Res> {
  __$StockStateCopyWithImpl(this._self, this._then);

  final _StockState _self;
  final $Res Function(_StockState) _then;

/// Create a copy of StockState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stocks = null,Object? filteredStocks = null,Object? currentUser = freezed,Object? status = freezed,Object? selectedStockIds = null,Object? searchQuery = null,Object? filterStatus = freezed,Object? sortBy = freezed,Object? sortOrder = freezed,Object? isBulkSelectionMode = null,Object? errorMessage = freezed,}) {
  return _then(_StockState(
stocks: null == stocks ? _self._stocks : stocks // ignore: cast_nullable_to_non_nullable
as List<Stock>,filteredStocks: null == filteredStocks ? _self._filteredStocks : filteredStocks // ignore: cast_nullable_to_non_nullable
as List<Stock>,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as User?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StockStateStatus,selectedStockIds: null == selectedStockIds ? _self._selectedStockIds : selectedStockIds // ignore: cast_nullable_to_non_nullable
as Set<String>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filterStatus: freezed == filterStatus ? _self.filterStatus : filterStatus // ignore: cast_nullable_to_non_nullable
as StockStatus?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as SortBy,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as SortOrder,isBulkSelectionMode: null == isBulkSelectionMode ? _self.isBulkSelectionMode : isBulkSelectionMode // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
