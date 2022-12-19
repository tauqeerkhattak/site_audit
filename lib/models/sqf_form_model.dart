class SqfFormModel {
  int? id;
  int? eng_id;
  int? form_id;
  // int? id;
  String? input_type;
  String? label;
  String? hint;
  String? mandatory;
  String? value;

  SqfFormModel(
      {this.eng_id,
      this.form_id,
      this.hint,
      this.id,
      this.input_type,
      this.label,
      this.mandatory,
      this.value});

  factory SqfFormModel.fromMap(map) {
    return SqfFormModel(
      eng_id: map['eng_id'],
      form_id: map['form_id'],
      hint: map['hint'],
      input_type: map['input_type'],
      id: map['id'],
      label: map['label'],
      mandatory: map['mandatory'],
      value: map['value'],
    );
  }

  toMap() {
    return {
      'eng_id': eng_id,
      'form_id': form_id,
      'hint': hint,
      'input_type': input_type,
      'id': id,
      'label': label,
      'mandatory': mandatory,
      'value': value,
    };
  }
}
