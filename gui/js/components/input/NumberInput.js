import Input from "./Input";

class NumberInput extends Input {
  constructor(id, label, defaultValue = 0) {
    super(id, label, defaultValue);
  }

  render() {
    const div = document.createElement('div');
    div.classList.add('mb-2');

    const labelEl = document.createElement('label');
    labelEl.setAttribute('for', this.id);
    labelEl.classList.add('form-label');
    labelEl.textContent = this.label;

    const input = document.createElement('input');
    input.type = 'number';
    input.id = this.id;
    input.classList.add('form-control');
    input.value = this.defaultValue;

    div.appendChild(labelEl);
    div.appendChild(input);
    return div;
  }
}

export default NumberInput;