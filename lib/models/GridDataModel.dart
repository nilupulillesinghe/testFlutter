class GridDataModel{
  bool _isSelected;
  String _name;

  GridDataModel(this._isSelected, this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }
}