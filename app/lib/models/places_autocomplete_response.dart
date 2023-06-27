import 'dart:convert';

import 'autocomplete_prediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePredicion>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? json['predictions']
              .map<AutocompletePredicion>(
                  (json) => AutocompletePredicion.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse parseResult(String response) {
    final parsed = json.decode(response).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
